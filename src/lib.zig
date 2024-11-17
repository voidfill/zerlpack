const std = @import("std");
const znapi = @import("znapi");
const napi = znapi.napi;

const decoder = @import("decoder.zig");
const encoder = @import("encoder.zig");

comptime {
    znapi.defineModule(.{
        .decode = decode,
        .unpack = decode,

        .encode = encode,
        .pack = encode,
    });
}

fn decode(ctx: *znapi.Ctx, cbi: napi.napi_callback_info) !napi.napi_value {
    const args = try ctx.getCbArgs(cbi, 1);
    const buffer = try ctx.getBufferInfo(args[0]);
    if (buffer.len == 0) {
        return ctx.throw("Buffer is empty");
    }

    var dec: decoder.Decoder = try decoder.Decoder.init(buffer, ctx, std.heap.c_allocator);
    const ret = try dec.decode();

    if (!dec.hasReadToCompletion()) {
        return ctx.throw("BufferSizeMismatch: Items leftover.");
    }

    return ret;
}

fn encode(ctx: *znapi.Ctx, cbi: napi.napi_callback_info) !napi.napi_value {
    const args = try ctx.parseArgs(struct { napi.napi_value, ?bool }, cbi, null);

    var enc: encoder.Encoder = try encoder.Encoder.init(ctx, std.heap.c_allocator);
    try enc.encode(args[0], 256);

    return if (args[1] orelse false) enc.outputCompressed() else enc.output();
}
