const std = @import("std");
const constants = @import("constants.zig");
const Tag = constants.Tag;
const znapi = @import("znapi");
const napi = znapi.napi;

fn ensureOnlySignificantBits(comptime amount: u6, value: u64) bool {
    const mask: u64 = (@as(u64, 1) << amount) - 1;
    return (value & mask) == value;
}

pub fn toString(ctx: *znapi.Ctx, value: napi.napi_value) !napi.napi_value {
    var res: napi.napi_value = undefined;
    try znapi.statusToError(znapi.raw.napi_coerce_to_string(ctx.env, value, &res));
    return res;
}

pub const DecodeOptions = struct {
    bigintsAsStrings: ?bool = false,
};

const DecodeError = error{ BufferSizeMismatch, WrongFormatVersion, SignificantBitError, WrongTag } || znapi.napi_error || znapi.Ctx.TranslationError;
pub const Decoder = struct {
    buffer: []const u8,
    index: usize,
    ctx: *znapi.Ctx,
    allocator: std.mem.Allocator,
    options: DecodeOptions,

    pub fn init(buffer: []const u8, ctx: *znapi.Ctx, allocator: std.mem.Allocator, options: DecodeOptions) !Decoder {
        var dec: Decoder = Decoder{
            .buffer = buffer,
            .index = 0,
            .ctx = ctx,
            .allocator = allocator,
            .options = options,
        };
        const format_version = try dec.read8();

        if (format_version != constants.format_version) {
            return DecodeError.WrongFormatVersion;
        }
        return dec;
    }

    pub fn decode(self: *Decoder) DecodeError!napi.napi_value {
        const ctx = self.ctx;

        const tag: Tag = @enumFromInt(try self.read8());
        return switch (tag) {
            .nil => try ctx.createArray(0),
            .integer => try ctx.createInt32(@bitCast(try self.read32())),
            .small_integer => try ctx.createInt32(@intCast(try self.read8())),
            .atom => try self.atomHelper(try self.slice(try self.read16())),
            .small_atom => try self.atomHelper(try self.slice(try self.read8())),
            .atom_utf8 => try self.atomHelper(try self.slice(try self.read16())),
            .small_atom_utf8 => try self.atomHelper(try self.slice(try self.read8())),
            .binary => try ctx.createString(try self.slice(try self.read32())),
            .small_tuple => try self.decodeArray(try self.read8()),
            .large_tuple => try self.decodeArray(try self.read32()),
            .new_float => try ctx.createDouble(@bitCast(try self.read64())),
            .small_big => try self.decodeBig(try self.read8()),
            .large_big => try self.decodeBig(try self.read32()),
            .list => {
                const arr = try self.decodeArray(try self.read32());
                const tail: Tag = @enumFromInt(try self.read8());
                if (tail != .nil) {
                    return ctx.throw("Invalid tail");
                }
                return arr;
            },
            .map => {
                const map = try ctx.createObject();
                for (0..try self.read32()) |i| {
                    _ = i;
                    const key = try self.decode();
                    const value = try self.decode();
                    try ctx.setProperty(map, key, value);
                }
                return map;
            },
            .string => { // yes, a string is just an array of integers..
                const len = try self.read16();
                const arr = try ctx.createArray(len);
                for (0..len) |i| {
                    try ctx.setElement(arr, @intCast(i), try self.ctx.createInt32(try self.read8()));
                }
                return arr;
            },
            .float => {
                const bytes = try self.slice(31); // yes. 31 bytes of string.
                // cut off null bytes
                const maybe_null_index = std.mem.indexOfScalar(u8, bytes, 0) orelse 31;

                const float = std.fmt.parseFloat(f64, bytes[0..maybe_null_index]) catch return ctx.throw("Failed to parse old float");
                return ctx.createDouble(float);
            },

            //

            .reference => {
                const obj = try ctx.createObject();

                try ensureNextTagAnyAtom(self);
                try ctx.setNamedProperty(obj, "node", try self.decode());

                const ids = try ctx.createArray(1);
                const id = try self.read32();
                if (!ensureOnlySignificantBits(18, id)) {
                    return DecodeError.SignificantBitError;
                }
                try ctx.setElement(ids, 0, try self.ctx.createUint32(id));

                try ctx.setNamedProperty(obj, "id", ids);

                const creation = try self.read8();
                if (!ensureOnlySignificantBits(2, creation)) {
                    return DecodeError.SignificantBitError;
                }
                try ctx.setNamedProperty(obj, "creation", try self.ctx.createUint32(creation));

                return obj;
            },
            .new_reference => {
                const len = try self.read16();
                if (len > 3) {
                    return ctx.throw("Invalid length for new_reference id");
                }

                const obj = try ctx.createObject();

                try ensureNextTagAnyAtom(self);
                try ctx.setNamedProperty(obj, "node", try self.decode());

                const creation = try self.read8();
                if (!ensureOnlySignificantBits(2, creation)) {
                    return DecodeError.SignificantBitError;
                }
                try ctx.setNamedProperty(obj, "creation", try ctx.createUint32(creation));

                const ids = try ctx.createArray(len);
                for (0..len) |i| {
                    if (i == 0) {
                        const id = try self.read32();
                        if (!ensureOnlySignificantBits(18, id)) {
                            return DecodeError.SignificantBitError;
                        }
                        try ctx.setElement(ids, @intCast(i), try ctx.createUint32(id));
                    } else {
                        try ctx.setElement(ids, @intCast(i), try ctx.createUint32(@bitCast(try self.read32())));
                    }
                }
                try ctx.setNamedProperty(obj, "id", ids);

                return obj;
            },
            .newer_reference => {
                const len = try self.read16();
                if (len > 3) {
                    return ctx.throw("Invalid length for newer_reference id");
                }

                const obj = try ctx.createObject();

                try ensureNextTagAnyAtom(self);
                try ctx.setNamedProperty(obj, "node", try self.decode());

                try ctx.setNamedProperty(obj, "creation", try ctx.createInt32(try self.read8()));

                const ids = try ctx.createArray(len);
                for (0..len) |i| {
                    try ctx.setElement(ids, @intCast(i), try ctx.createUint32(@bitCast(try self.read32())));
                }
                try ctx.setNamedProperty(obj, "id", ids);

                return obj;
            },
            .port => {
                const obj = try ctx.createObject();
                try ensureNextTagAnyAtom(self);
                try ctx.setNamedProperty(obj, "node", try self.decode());

                const id = try self.read32();
                if (!ensureOnlySignificantBits(28, id)) {
                    return DecodeError.SignificantBitError;
                }
                try ctx.setNamedProperty(obj, "id", try ctx.createUint32(id));

                const creation = try self.read8();
                if (!ensureOnlySignificantBits(2, creation)) {
                    return DecodeError.SignificantBitError;
                }
                try ctx.setNamedProperty(obj, "creation", try ctx.createUint32(creation));

                return obj;
            },
            .new_port => {
                const obj = try ctx.createObject();
                try ensureNextTagAnyAtom(self);
                try ctx.setNamedProperty(obj, "node", try self.decode());

                const id = try self.read32();
                if (!ensureOnlySignificantBits(28, id)) {
                    return DecodeError.SignificantBitError;
                }
                try ctx.setNamedProperty(obj, "id", try ctx.createUint32(id));

                try ctx.setNamedProperty(obj, "creation", try ctx.createUint32(try self.read32()));
                return obj;
            },
            .pid => {
                const obj = try ctx.createObject();
                try ensureNextTagAnyAtom(self);
                try ctx.setNamedProperty(obj, "node", try self.decode());

                const id = try self.read32();
                if (!ensureOnlySignificantBits(15, id)) {
                    return DecodeError.SignificantBitError;
                }
                try ctx.setNamedProperty(obj, "id", try ctx.createUint32(id));

                const serial = try self.read32();
                if (!ensureOnlySignificantBits(13, serial)) {
                    return DecodeError.SignificantBitError;
                }
                try ctx.setNamedProperty(obj, "serial", try ctx.createUint32(serial));

                const creation = try self.read8();
                if (!ensureOnlySignificantBits(2, creation)) {
                    return DecodeError.SignificantBitError;
                }
                try ctx.setNamedProperty(obj, "creation", try ctx.createUint32(creation));

                return obj;
            },
            .new_pid => {
                const obj = try ctx.createObject();

                try ensureNextTagAnyAtom(self);
                try ctx.setNamedProperty(obj, "node", try self.decode());

                const id = try self.read32();
                if (!ensureOnlySignificantBits(15, id)) {
                    return DecodeError.SignificantBitError;
                }
                try ctx.setNamedProperty(obj, "id", try ctx.createUint32(id));

                const serial = try self.read32();
                if (!ensureOnlySignificantBits(13, serial)) {
                    return DecodeError.SignificantBitError;
                }
                try ctx.setNamedProperty(obj, "serial", try ctx.createUint32(serial));

                try ctx.setNamedProperty(obj, "creation", try ctx.createUint32(try self.read32()));
                return obj;
            },
            .export_ext => {
                const obj = try ctx.createObject();

                try self.ensureNextTagAnyAtom();
                try ctx.setNamedProperty(obj, "mod", try self.decode());

                try self.ensureNextTagAnyAtom();
                try ctx.setNamedProperty(obj, "fun", try self.decode());

                try self.ensureNextTagOneOf(&.{.small_integer});
                try ctx.setNamedProperty(obj, "arity", try self.decode());

                return obj;
            },

            //

            .compressed => {
                const dest_size = try self.read32();
                var _dest_size: c_ulong = @intCast(dest_size);

                const outBuffer = self.allocator.alloc(u8, dest_size) catch return ctx.throw("Out of memory");
                defer self.allocator.free(outBuffer);

                switch (znapi.raw.uncompress(outBuffer.ptr, &_dest_size, self.buffer.ptr + self.index, @intCast(self.buffer.len - self.index))) {
                    0 => {},
                    else => return ctx.throw("Failed to uncompress"),
                }

                self.buffer = outBuffer;
                self.index = 0;
                return try self.decode();
            },

            .distribution_header, .distribution_header_fragmented => ctx.throw("Distribution header is not supported"),
            .bit_binary => ctx.throw("Bit binary is not supported"), // maybe? no idea how to handle it
            .atom_cache_ref => ctx.throw("Atom cache ref is not supported"),
            else => ctx.throw("Unknown tag"),
        };
    }

    pub fn hasReadToCompletion(self: *Decoder) bool {
        return self.index == self.buffer.len;
    }

    fn decodeBig(self: *Decoder, length: u32) !napi.napi_value {
        const sign = try self.read8();
        if (self.index + length > self.buffer.len) {
            return DecodeError.BufferSizeMismatch;
        }

        const parts: []align(@alignOf(u64)) u8 = self.allocator.alignedAlloc(u8, @alignOf(u64), ((length / 8) + 1) * 8) catch return self.ctx.throw("Out of memory");
        defer self.allocator.free(parts);
        @memset(parts, 0);

        std.mem.copyForwards(u8, parts, self.buffer[self.index .. self.index + length]);
        self.index += length;

        const bigint = try self.ctx.createBigintBytes(sign != 0, parts);
        return if (self.options.bigintsAsStrings orelse false) try toString(self.ctx, bigint) else bigint;
    }

    fn decodeArray(self: *Decoder, length: u32) !napi.napi_value {
        const arr = try self.ctx.createArray(@intCast(length));
        for (0..length) |i| {
            try self.ctx.setElement(arr, @intCast(i), try self.decode());
        }
        return arr;
    }

    fn atomHelper(self: *Decoder, str: []const u8) !napi.napi_value {
        const ctx = self.ctx;
        if (str.len > 5) {
            return ctx.createString(str);
        }

        if (std.mem.eql(u8, str, "true")) {
            return try ctx.createBoolean(true);
        }
        if (std.mem.eql(u8, str, "false")) {
            return try ctx.createBoolean(false);
        }
        if (std.mem.eql(u8, str, "nil") or std.mem.eql(u8, str, "null")) {
            return ctx.null;
        }

        return ctx.createString(str);
    }

    fn read8(self: *Decoder) !u8 {
        if (self.index + 1 > self.buffer.len) {
            return DecodeError.BufferSizeMismatch;
        }
        const result = self.buffer[self.index];
        self.index += 1;
        return result;
    }

    fn read16(self: *Decoder) !u16 {
        if (self.index + 2 > self.buffer.len) {
            return DecodeError.BufferSizeMismatch;
        }
        const result = std.mem.readInt(u16, @ptrCast(&self.buffer[self.index]), .big);
        self.index += 2;
        return result;
    }

    fn read32(self: *Decoder) !u32 {
        if (self.index + 4 > self.buffer.len) {
            return DecodeError.BufferSizeMismatch;
        }
        const result = std.mem.readInt(u32, @ptrCast(&self.buffer[self.index]), .big);
        self.index += 4;
        return result;
    }

    fn read64(self: *Decoder) !u64 {
        if (self.index + 8 > self.buffer.len) {
            return DecodeError.BufferSizeMismatch;
        }
        const result = std.mem.readInt(u64, @ptrCast(&self.buffer[self.index]), .big);
        self.index += 8;
        return result;
    }

    fn slice(self: *Decoder, length: usize) ![]const u8 {
        if (self.index + length > self.buffer.len) {
            return DecodeError.BufferSizeMismatch;
        }
        const result = self.buffer[self.index .. self.index + length];
        self.index += length;
        return result;
    }

    fn peek(self: *Decoder) !u8 {
        if (self.index >= self.buffer.len) {
            return DecodeError.BufferSizeMismatch;
        }
        return self.buffer[self.index];
    }

    fn ensureNextTagOneOf(self: *Decoder, tags: []const Tag) !void {
        const tag: Tag = @enumFromInt(try self.peek());
        if (std.mem.indexOfScalar(Tag, tags, tag) == null) {
            return DecodeError.WrongTag;
        }
    }

    // this check gets used for node names, its supposed to only be utf8 ones and ref but we are lax and allow legacy atoms too
    fn ensureNextTagAnyAtom(self: *Decoder) !void {
        try self.ensureNextTagOneOf(&.{ .atom, .small_atom, .atom_utf8, .small_atom_utf8, .atom_cache_ref });
    }
};
