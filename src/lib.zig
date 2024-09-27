const std = @import("std");
const c = @import("c.zig");
const translate = @import("translate.zig");
const decoder = @import("decoder.zig");

export fn napi_register_module_v1(env: c.napi_env, exports: c.napi_value) c.napi_value {
    translate.registerFunction(env, exports, "unpack", decodeWrapper) catch return null;
    return exports;
}

fn decode(env: c.napi_env, info: c.napi_callback_info) !c.napi_value {
    const arguments: [1]c.napi_value = try translate.extractArgs(env, info, 1);
    const buffer = try translate.getBufferInfo(env, arguments[0]);
    if (buffer.len == 0) {
        return translate.throw(env, "Buffer is empty");
    }

    var dec: decoder.Decoder = try decoder.Decoder.init(buffer, env, std.heap.c_allocator);
    const ret = try dec.decode();
    if (!dec.hasReadToCompletion()) {
        return translate.throw(env, "Buffer size mismatch: Items leftover.");
    }

    return ret;
}

fn decodeWrapper(env: c.napi_env, info: c.napi_callback_info) callconv(.C) c.napi_value {
    return decode(env, info) catch |e| {
        switch (e) {
            error.ExceptionThrown => return null, // only "rethrow" zig native errors
            error.BufferSizeMismatch => translate.throw(env, "Buffer size mismatch.") catch return null,
            error.WrongFormatVersion => translate.throw(env, "Wrong format version.") catch return null,
            error.SignificantBitError => translate.throw(env, "Expected unsignificant bits to be zero.") catch return null,
            error.WrongTag => translate.throw(env, "Expected a different tag.") catch return null,
        }
    };
}
