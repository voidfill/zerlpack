const std = @import("std");
const builtin = @import("builtin");
const constants = @import("constants.zig");
const Tag = constants.Tag;
const native_endian = builtin.cpu.arch.endian();
const znapi = @import("znapi");
const napi = znapi.napi;

const initial_buffer_size = std.mem.page_size;

fn nearestPowerOfTwo(x: u32) u32 {
    var r = x - 1;
    r |= r >> 1;
    r |= r >> 2;
    r |= r >> 4;
    r |= r >> 8;
    r |= r >> 16;
    return r + 1;
}

fn maybeSwap(comptime to: std.builtin.Endian, value: anytype) @TypeOf(value) {
    return if (to == native_endian) value else @byteSwap(value);
}

pub const Encoder = struct {
    buffer: []u8,
    index: usize,
    ctx: *znapi.Ctx,
    allocator: std.mem.Allocator,

    pub fn init(ctx: *znapi.Ctx, allocator: std.mem.Allocator) !Encoder {
        var buffer = try allocator.alloc(u8, initial_buffer_size);
        buffer[0] = constants.format_version;

        return Encoder{
            .buffer = buffer,
            .index = 1,
            .ctx = ctx,
            .allocator = allocator,
        };
    }

    pub fn output(self: *Encoder) !napi.napi_value {
        defer self.allocator.free(self.buffer);
        return self.ctx.createArrayBuffer(self.buffer[0..self.index]);
    }

    pub fn outputCompressed(self: *Encoder) !napi.napi_value {
        const ctx = self.ctx;
        defer self.allocator.free(self.buffer);

        var destLen = znapi.raw.compressBound(@intCast(self.index - 1));
        const dest = try self.allocator.alloc(u8, destLen + 6);
        defer self.allocator.free(dest);

        switch (znapi.raw.compress(dest.ptr + 6, &destLen, self.buffer.ptr + 1, @intCast(self.index - 1))) {
            0 => {},
            else => return ctx.throw("Failed to compress"),
        }

        dest[0] = constants.format_version;
        dest[1] = @intFromEnum(Tag.compressed);
        const uncompressedSize = self.index - 1;
        dest[2] = @intCast(uncompressedSize >> 24 & 0xFF);
        dest[3] = @intCast(uncompressedSize >> 16 & 0xFF);
        dest[4] = @intCast(uncompressedSize >> 8 & 0xFF);
        dest[5] = @intCast(uncompressedSize & 0xFF);

        return ctx.createArrayBuffer(dest[0 .. destLen + 6]);
    }

    fn append(self: *Encoder, data: []const u8) !void {
        const new_index = self.index + data.len;
        if (new_index > self.buffer.len) {
            const new_buffer = try self.allocator.realloc(self.buffer, nearestPowerOfTwo(@intCast(new_index)));
            self.buffer = new_buffer;
        }
        std.mem.copyForwards(u8, self.buffer[self.index..new_index], data);
        self.index = new_index;
    }

    fn appendInt(self: *Encoder, comptime T: type, value: T, comptime endian: std.builtin.Endian) !void {
        const bytes: *[@divExact(@typeInfo(T).Int.bits, 8)]u8 = @ptrCast(@constCast(&maybeSwap(endian, value)));
        try self.append(bytes);
    }

    pub fn encode(self: *Encoder, value: napi.napi_value, _nestlimit: u16) !void {
        const ctx = self.ctx;
        const nestLimit = _nestlimit - 1;
        if (nestLimit == 0) {
            return ctx.throw("Reached nesting limit");
        }

        switch (try ctx.napiTypeOf(value)) {
            .undefined, .null => {
                try self.append(&[_]u8{ @intFromEnum(Tag.small_atom_utf8), 3, 'n', 'i', 'l' });
            },
            .boolean => {
                if (try ctx.getBool(value)) {
                    try self.append(&[_]u8{ @intFromEnum(Tag.small_atom_utf8), 4, 't', 'r', 'u', 'e' });
                } else {
                    try self.append(&[_]u8{ @intFromEnum(Tag.small_atom_utf8), 5, 'f', 'a', 'l', 's', 'e' });
                }
            },
            .string => {
                const str = try ctx.getStringUtf8(value, self.allocator);
                defer self.allocator.free(str);
                try self.append(&[_]u8{@intFromEnum(Tag.binary)});
                try self.appendInt(u32, @intCast(str.len), .big);
                try self.append(str);
            },
            .object => {
                if (try ctx.isArray(value)) {
                    const len = try ctx.getArrayLength(value);

                    try self.append(&[_]u8{@intFromEnum(Tag.list)});
                    try self.appendInt(u32, len, .big);

                    for (0..len) |i| {
                        try self.encode(try ctx.getElement(value, @intCast(i)), nestLimit);
                    }

                    try self.append(&[_]u8{@intFromEnum(Tag.nil)});
                } else {
                    const keys = try ctx.getAllPropertyNames(
                        value,
                        .own_only,
                        @enumFromInt(@intFromEnum(napi.napi_key_filter.all_properties) | @intFromEnum(napi.napi_key_filter.skip_symbols)), // just skip symbols, not worth erroring on
                        .keep_numbers,
                    );
                    const len = try ctx.getArrayLength(keys);

                    try self.append(&[_]u8{@intFromEnum(Tag.map)});
                    try self.appendInt(u32, len, .big);

                    for (0..len) |i| {
                        const key = try ctx.getElement(keys, @intCast(i));
                        try self.encode(key, nestLimit);
                        try self.encode(try ctx.getProperty2(value, key), nestLimit);
                    }
                }
            },
            .bigint => {
                const v = try ctx.getBigintBytes(value, self.allocator);
                defer self.allocator.free(v.bytes);

                // cut off null bytes
                var real_len = v.bytes.len;
                while (real_len > 0 and v.bytes[real_len - 1] == 0) {
                    real_len -= 1;
                }

                if (real_len > 255) {
                    try self.append(&[_]u8{@intFromEnum(Tag.large_big)});
                    try self.appendInt(u32, @intCast(real_len), .big);
                } else {
                    try self.append(&[_]u8{@intFromEnum(Tag.small_big)});
                    try self.append(&[_]u8{@intCast(real_len)});
                }

                try self.appendInt(u8, @intFromBool(v.sign), .big);
                try self.append(v.bytes[0..real_len]);
            },
            .number => {
                const d = try ctx.getDouble(value);

                if (std.math.ceil(d) != d or d > std.math.maxInt(u32) or d < std.math.minInt(i32)) {
                    try self.append(&[_]u8{@intFromEnum(Tag.new_float)});
                    try self.appendInt(u64, @bitCast(d), .big);
                    return;
                }

                if (d > std.math.maxInt(i32)) {
                    // u32, turn into bigint
                    const u: u32 = @intFromFloat(d);
                    try self.append(&[_]u8{
                        @intFromEnum(Tag.small_big),
                        4,
                        0,
                        @intCast(u >> 24 & 0xFF),
                        @intCast(u >> 16 & 0xFF),
                        @intCast(u >> 8 & 0xFF),
                        @intCast(u & 0xFF),
                    });
                    return;
                }

                const i: i32 = @intFromFloat(d);
                if (i >= 0 and i <= 255) {
                    try self.append(&[_]u8{@intFromEnum(Tag.small_integer)});
                    try self.append(&[_]u8{@intCast(i)});
                } else {
                    try self.append(&[_]u8{@intFromEnum(Tag.integer)});
                    try self.appendInt(u32, @bitCast(i), .big);
                }
            },

            .function => {
                return ctx.throw("Functions are not supported");
            },
            .external => {
                return ctx.throw("Externals are not supported");
            },
            .symbol => {
                return ctx.throw("Symbols are not supported");
            },
        }
    }
};
