const std = @import("std");
const c = @import("c.zig");
const translate = @import("translate.zig");
const constants = @import("constants.zig");
const Tag = constants.Tag;

fn ensureOnlySignificantBits(comptime amount: u6, value: u64) bool {
    const mask: u64 = (@as(u64, 1) << amount) - 1;
    return (value & mask) == value;
}

const DecodeError = error{ BufferSizeMismatch, WrongFormatVersion, SignificantBitError, WrongTag } || translate.TranslationError;
pub const Decoder = struct {
    buffer: []const u8,
    index: usize,
    env: c.napi_env,
    global_null: c.napi_value,
    global_undefined: c.napi_value,
    allocator: std.mem.Allocator,

    pub fn init(buffer: []const u8, env: c.napi_env, allocator: std.mem.Allocator) !Decoder {
        var dec: Decoder = Decoder{
            .buffer = buffer,
            .index = 0,
            .env = env,
            .global_null = try translate.getNull(env),
            .global_undefined = try translate.getUndefined(env),
            .allocator = allocator,
        };
        const format_version = try dec.read8();

        if (format_version != constants.format_version) {
            return DecodeError.WrongFormatVersion;
        }
        return dec;
    }

    pub fn decode(self: *Decoder) DecodeError!c.napi_value {
        const tag: Tag = @enumFromInt(try self.read8());
        return switch (tag) {
            .nil => try translate.createArrayWithLength(self.env, 0),
            .integer => try translate.createInt32(self.env, @bitCast(try self.read32())),
            .small_integer => try translate.createInt32(self.env, @intCast(try self.read8())),
            .atom => try self.atomHelper(try self.slice(try self.read16())),
            .small_atom => try self.atomHelper(try self.slice(try self.read8())),
            .atom_utf8 => try self.utf8AtomHelper(try self.slice(try self.read16())),
            .small_atom_utf8 => try self.utf8AtomHelper(try self.slice(try self.read8())),
            .binary => try translate.createStringFromSlice(self.env, try self.slice(try self.read32())),
            .small_tuple => try self.decodeArray(try self.read8()),
            .large_tuple => try self.decodeArray(try self.read32()),
            .new_float => try translate.createDouble(self.env, @bitCast(try self.read64())),
            .small_big => try self.decodeBig(try self.read8()),
            .large_big => try self.decodeBig(try self.read32()),
            .list => {
                const arr = try self.decodeArray(try self.read32());
                const tail: Tag = @enumFromInt(try self.read8());
                if (tail != .nil) {
                    return translate.throw(self.env, "Invalid tail");
                }
                return arr;
            },
            .map => {
                const map = try translate.createObject(self.env);
                for (0..try self.read32()) |i| {
                    _ = i;
                    const key = try self.decode();
                    const value = try self.decode();
                    try translate.setProperty(self.env, map, key, value);
                }
                return map;
            },
            .string => { // yes, a string is just an array of integers..
                const len = try self.read16();
                const arr = try translate.createArrayWithLength(self.env, len);
                for (0..len) |i| {
                    try translate.setElement(self.env, arr, @intCast(i), try translate.createInt32(self.env, try self.read8()));
                }
                return arr;
            },
            .float => {
                const bytes = try self.slice(31); // yes. 31 bytes of string.
                // cut off null bytes
                const maybe_null_index = std.mem.indexOfScalar(u8, bytes, 0) orelse 31;

                const float = std.fmt.parseFloat(f64, bytes[0..maybe_null_index]) catch return translate.throw(self.env, "Failed to parse old float");
                return translate.createDouble(self.env, float);
            },

            //

            .reference => {
                const obj = try translate.createObject(self.env);

                try ensureNextTagAnyAtom(self);
                try translate.setNamedProperty(self.env, obj, "node", try self.decode());

                const ids = try translate.createArrayWithLength(self.env, 1);
                const id = try self.read32();
                if (!ensureOnlySignificantBits(18, id)) {
                    return DecodeError.SignificantBitError;
                }
                try translate.setElement(self.env, ids, 0, try translate.createUint32(self.env, id));

                try translate.setNamedProperty(self.env, obj, "id", ids);

                const creation = try self.read8();
                if (!ensureOnlySignificantBits(2, creation)) {
                    return DecodeError.SignificantBitError;
                }
                try translate.setNamedProperty(self.env, obj, "creation", try translate.createUint32(self.env, creation));

                return obj;
            },
            .new_reference => {
                const len = try self.read16();
                if (len > 3) {
                    return translate.throw(self.env, "Invalid length for new_reference id");
                }

                const obj = try translate.createObject(self.env);

                try ensureNextTagAnyAtom(self);
                try translate.setNamedProperty(self.env, obj, "node", try self.decode());

                const creation = try self.read8();
                if (!ensureOnlySignificantBits(2, creation)) {
                    return DecodeError.SignificantBitError;
                }
                try translate.setNamedProperty(self.env, obj, "creation", try translate.createUint32(self.env, creation));

                const ids = try translate.createArrayWithLength(self.env, len);
                for (0..len) |i| {
                    if (i == 0) {
                        const id = try self.read32();
                        if (!ensureOnlySignificantBits(18, id)) {
                            return DecodeError.SignificantBitError;
                        }
                        try translate.setElement(self.env, ids, @intCast(i), try translate.createUint32(self.env, id));
                    } else {
                        try translate.setElement(self.env, ids, @intCast(i), try translate.createUint32(self.env, @bitCast(try self.read32())));
                    }
                }
                try translate.setNamedProperty(self.env, obj, "id", ids);

                return obj;
            },
            .newer_reference => {
                const len = try self.read16();
                if (len > 3) {
                    return translate.throw(self.env, "Invalid length for newer_reference id");
                }

                const obj = try translate.createObject(self.env);

                try ensureNextTagAnyAtom(self);
                try translate.setNamedProperty(self.env, obj, "node", try self.decode());

                try translate.setNamedProperty(self.env, obj, "creation", try translate.createInt32(self.env, try self.read8()));

                const ids = try translate.createArrayWithLength(self.env, len);
                for (0..len) |i| {
                    try translate.setElement(self.env, ids, @intCast(i), try translate.createUint32(self.env, @bitCast(try self.read32())));
                }
                try translate.setNamedProperty(self.env, obj, "id", ids);

                return obj;
            },
            .port => {
                const obj = try translate.createObject(self.env);
                try ensureNextTagAnyAtom(self);
                try translate.setNamedProperty(self.env, obj, "node", try self.decode());

                const id = try self.read32();
                if (!ensureOnlySignificantBits(28, id)) {
                    return DecodeError.SignificantBitError;
                }
                try translate.setNamedProperty(self.env, obj, "id", try translate.createUint32(self.env, id));

                const creation = try self.read8();
                if (!ensureOnlySignificantBits(2, creation)) {
                    return DecodeError.SignificantBitError;
                }
                try translate.setNamedProperty(self.env, obj, "creation", try translate.createUint32(self.env, creation));

                return obj;
            },
            .new_port => {
                const obj = try translate.createObject(self.env);
                try ensureNextTagAnyAtom(self);
                try translate.setNamedProperty(self.env, obj, "node", try self.decode());

                const id = try self.read32();
                if (!ensureOnlySignificantBits(28, id)) {
                    return DecodeError.SignificantBitError;
                }
                try translate.setNamedProperty(self.env, obj, "id", try translate.createUint32(self.env, id));

                try translate.setNamedProperty(self.env, obj, "creation", try translate.createUint32(self.env, try self.read32()));
                return obj;
            },
            .pid => {
                const obj = try translate.createObject(self.env);
                try ensureNextTagAnyAtom(self);
                try translate.setNamedProperty(self.env, obj, "node", try self.decode());

                const id = try self.read32();
                if (!ensureOnlySignificantBits(15, id)) {
                    return DecodeError.SignificantBitError;
                }
                try translate.setNamedProperty(self.env, obj, "id", try translate.createUint32(self.env, id));

                const serial = try self.read32();
                if (!ensureOnlySignificantBits(13, serial)) {
                    return DecodeError.SignificantBitError;
                }
                try translate.setNamedProperty(self.env, obj, "serial", try translate.createUint32(self.env, serial));

                const creation = try self.read8();
                if (!ensureOnlySignificantBits(2, creation)) {
                    return DecodeError.SignificantBitError;
                }
                try translate.setNamedProperty(self.env, obj, "creation", try translate.createUint32(self.env, creation));

                return obj;
            },
            .new_pid => {
                const obj = try translate.createObject(self.env);

                try ensureNextTagAnyAtom(self);
                try translate.setNamedProperty(self.env, obj, "node", try self.decode());

                const id = try self.read32();
                if (!ensureOnlySignificantBits(15, id)) {
                    return DecodeError.SignificantBitError;
                }
                try translate.setNamedProperty(self.env, obj, "id", try translate.createUint32(self.env, id));

                const serial = try self.read32();
                if (!ensureOnlySignificantBits(13, serial)) {
                    return DecodeError.SignificantBitError;
                }
                try translate.setNamedProperty(self.env, obj, "serial", try translate.createUint32(self.env, serial));

                try translate.setNamedProperty(self.env, obj, "creation", try translate.createUint32(self.env, try self.read32()));
                return obj;
            },
            .export_ext => {
                const obj = try translate.createObject(self.env);

                try self.ensureNextTagAnyAtom();
                try translate.setNamedProperty(self.env, obj, "mod", try self.decode());

                try self.ensureNextTagAnyAtom();
                try translate.setNamedProperty(self.env, obj, "fun", try self.decode());

                try self.ensureNextTagOneOf(&.{.small_integer});
                try translate.setNamedProperty(self.env, obj, "arity", try self.decode());

                return obj;
            },

            //

            .compressed => translate.throw(self.env, "Compressed data is not supported"), // TODO: implement?
            .distribution_header, .distribution_header_fragmented => translate.throw(self.env, "Distribution header is not supported"),
            .bit_binary => translate.throw(self.env, "Bit binary is not supported"), // maybe? no idea how to handle it
            .atom_cache_ref => translate.throw(self.env, "Atom cache ref is not supported"),
            else => translate.throw(self.env, "Unknown tag"),
        };
    }

    pub fn hasReadToCompletion(self: *Decoder) bool {
        return self.index == self.buffer.len;
    }

    fn decodeBig(self: *Decoder, length: u32) !c.napi_value {
        const sign = try self.read8();
        if (self.index + length > self.buffer.len) {
            return DecodeError.BufferSizeMismatch;
        }

        const part_length = (length / 8) + @intFromBool(@mod(length, 8) > 0);
        var parts: []u64 = self.allocator.alloc(u64, part_length) catch return translate.throw(self.env, "Out of memory");
        defer self.allocator.free(parts);
        for (0..(length / 8)) |i| {
            parts[i] = try self.read64Little();
        }

        var last_part: u64 = 0;
        for (0..@mod(length, 8)) |i| {
            last_part |= @as(u64, try self.read8()) << @as(u6, @intCast(i * 8));
        }
        if (length % 8 != 0) {
            parts[part_length - 1] = last_part;
        }

        return translate.createBigintWords(self.env, sign, parts);
    }

    fn decodeArray(self: *Decoder, length: u32) !c.napi_value {
        const arr = try translate.createArrayWithLength(self.env, @intCast(length));
        for (0..length) |i| {
            try translate.setElement(self.env, arr, @intCast(i), try self.decode());
        }
        return arr;
    }

    fn atomHelper(self: *Decoder, str: []const u8) !c.napi_value {
        if (str.len > 5) {
            return translate.createStringFromSlice(self.env, str);
        }

        if (std.mem.eql(u8, str, "true")) {
            return try translate.getBool(self.env, true);
        }
        if (std.mem.eql(u8, str, "false")) {
            return try translate.getBool(self.env, false);
        }
        if (std.mem.eql(u8, str, "nil") or std.mem.eql(u8, str, "null")) {
            return self.global_null;
        }

        return translate.createStringFromSlice(self.env, str);
    }

    fn utf8AtomHelper(self: *Decoder, str: []const u8) !c.napi_value {
        if (str.len > 5) {
            return translate.createUtf8StringFromSlice(self.env, str);
        }

        if (std.mem.eql(u8, str, "true")) {
            return try translate.getBool(self.env, true);
        }
        if (std.mem.eql(u8, str, "false")) {
            return try translate.getBool(self.env, false);
        }
        if (std.mem.eql(u8, str, "nil") or std.mem.eql(u8, str, "null")) {
            return self.global_null;
        }

        return translate.createUtf8StringFromSlice(self.env, str);
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

    fn read64Little(self: *Decoder) !u64 {
        if (self.index + 8 > self.buffer.len) {
            return DecodeError.BufferSizeMismatch;
        }
        const result = std.mem.readInt(u64, @ptrCast(&self.buffer[self.index]), .little);
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
