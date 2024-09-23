const std = @import("std");
const assert = std.debug.assert;
const c = @import("c.zig");

pub const TranslationError = error{ExceptionThrown};
pub fn throw(env: c.napi_env, comptime message: [:0]const u8) TranslationError {
    _ = c.napi_throw_error(env, null, @as([*c]const u8, @ptrCast(message)));

    return TranslationError.ExceptionThrown;
}

fn maybeError(env: c.napi_env, comptime message: [:0]const u8, result: c.napi_status) TranslationError!void {
    if (result != c.napi_ok) {
        return throw(env, message);
    }
}

// primitive wrappers

pub fn createFunction(env: c.napi_env, function: fn (c.napi_env, c.napi_callback_info) callconv(.C) c.napi_value) !c.napi_value {
    var napi_function: c.napi_value = undefined;
    try maybeError(env, "Failed to create function", c.napi_create_function(env, null, 0, function, null, &napi_function));
    return napi_function;
}

pub fn createNamedFunction(env: c.napi_env, name: [:0]const u8, function: fn (c.napi_env, c.napi_callback_info) callconv(.C) c.napi_value) !c.napi_value {
    var napi_function: c.napi_value = undefined;
    try maybeError(env, "Failed to create named function", c.napi_create_named_function(env, name, name.len, function, null, &napi_function));
    return napi_function;
}

pub fn setProperty(env: c.napi_env, object: c.napi_value, key: c.napi_value, value: c.napi_value) !void {
    try maybeError(env, "Failed to set property", c.napi_set_property(env, object, key, value));
}

pub fn setNamedProperty(env: c.napi_env, object: c.napi_value, name: [:0]const u8, value: c.napi_value) !void {
    try maybeError(env, "Failed to set named property", c.napi_set_named_property(env, object, name, value));
}

pub fn createString(env: c.napi_env, value: [:0]const u8) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to create string", c.napi_create_string_utf8(env, value, value.len, &result));
    return result;
}

pub fn createStringFromSlice(env: c.napi_env, slice: []const u8) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to create string", c.napi_create_string_utf8(env, slice.ptr, slice.len, &result));
    return result;
}

pub fn createUtf8StringFromSlice(env: c.napi_env, slice: []const u8) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to create string", c.napi_create_string_utf8(env, slice.ptr, slice.len, &result));
    return result;
}

pub fn getNull(env: c.napi_env) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to get null", c.napi_get_null(env, &result));
    return result;
}

pub fn getUndefined(env: c.napi_env) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to get undefined", c.napi_get_undefined(env, &result));
    return result;
}

pub fn createUint32(env: c.napi_env, value: u32) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to create uint32", c.napi_create_uint32(env, value, &result));
    return result;
}

pub fn createInt32(env: c.napi_env, value: i32) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to create int32", c.napi_create_int32(env, value, &result));
    return result;
}

pub fn extractArgs(env: c.napi_env, info: c.napi_callback_info, comptime argc: usize) ![argc]c.napi_value {
    var _argc: usize = argc;
    var argv: [argc]c.napi_value = undefined;

    try maybeError(env, "Failed to extract args", c.napi_get_cb_info(env, info, &_argc, &argv, null, null));
    if (_argc != argc) {
        return throw(env, "Wrong number of arguments");
    }

    return argv;
}

pub fn createDouble(env: c.napi_env, value: f64) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to create double", c.napi_create_double(env, value, &result));
    return result;
}

pub fn getBufferInfo(env: c.napi_env, value: c.napi_value) ![]u8 {
    var data: ?*anyopaque = null;
    var len: usize = undefined;
    try maybeError(env, "Failed to get buffer info", c.napi_get_buffer_info(env, value, &data, &len));
    if (data == null) {
        return &[0]u8{};
    }

    return @as([*]u8, @ptrCast(data))[0..len];
}

pub fn getBool(env: c.napi_env, value: bool) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to get bool", c.napi_get_boolean(env, value, &result));
    return result;
}

pub fn createArrayWithLength(env: c.napi_env, length: usize) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to create array", c.napi_create_array_with_length(env, length, &result));
    return result;
}

pub fn setElement(env: c.napi_env, object: c.napi_value, index: u32, value: c.napi_value) !void {
    try maybeError(env, "Failed to set element", c.napi_set_element(env, object, index, value));
}

pub fn createObject(env: c.napi_env) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to create object", c.napi_create_object(env, &result));
    return result;
}

pub fn createBigintWords(env: c.napi_env, sign: u8, words: []const u64) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to create bigint", c.napi_create_bigint_words(env, sign, words.len, words.ptr, &result));
    return result;
}

// helpers

pub fn registerFunction(
    env: c.napi_env,
    exports: c.napi_value,
    comptime name: [:0]const u8,
    function: fn (c.napi_env, c.napi_callback_info) callconv(.C) c.napi_value,
) !void {
    const function_value = try createFunction(env, function);
    try setNamedProperty(env, exports, name, function_value);
}
