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

pub fn createString(env: c.napi_env, slice: []const u8) !c.napi_value {
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

pub fn extractArgs(env: c.napi_env, info: c.napi_callback_info, comptime argc: usize) !struct {
    argv: [argc]c.napi_value,
    argc: usize,
} {
    var _argc: usize = argc;
    var argv: [argc]c.napi_value = undefined;
    try maybeError(env, "Failed to extract args", c.napi_get_cb_info(env, info, &_argc, &argv, null, null));
    return .{ .argv = argv, .argc = _argc };
}

pub fn createDouble(env: c.napi_env, value: f64) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to create double", c.napi_create_double(env, value, &result));
    return result;
}

pub fn getBufferInfo(env: c.napi_env, value: c.napi_value) ![]const u8 {
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

pub fn createBigintBytes(env: c.napi_env, sign: u8, bytes: []const u8) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to create bigint", c.napi_create_bigint_words(env, sign, bytes.len / 8, @alignCast(@ptrCast(bytes.ptr)), &result));
    return result;
}

pub fn createArrayBuffer(env: c.napi_env, data: []const u8) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to create array buffer", c.napi_create_buffer_copy(env, data.len, data.ptr, null, &result));
    return result;
}

pub fn typeof(env: c.napi_env, value: c.napi_value) !c.napi_valuetype {
    var result: c.napi_valuetype = undefined;
    try maybeError(env, "Failed to get type", c.napi_typeof(env, value, &result));
    return result;
}

pub fn getBoolValue(env: c.napi_env, value: c.napi_value) !bool {
    var result: bool = undefined;
    try maybeError(env, "Failed to get bool value", c.napi_get_value_bool(env, value, &result));
    return result;
}

pub fn getStringUtf8Value(env: c.napi_env, value: c.napi_value, allocator: std.mem.Allocator) ![:0]const u8 {
    var length: usize = undefined;
    try maybeError(env, "Failed to get string length", c.napi_get_value_string_utf8(env, value, null, 0, &length));
    const buffer = try allocator.allocSentinel(u8, length, 0);
    try maybeError(env, "Failed to get string value", c.napi_get_value_string_utf8(env, value, buffer.ptr, buffer.len + 1, &length));
    return buffer;
}

pub fn getPropertyNames(env: c.napi_env, value: c.napi_value) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to get property names", c.napi_get_property_names(env, value, &result));
    return result;
}

pub fn getAllPropertyNames(
    env: c.napi_env,
    value: c.napi_value,
    key_mode: c.napi_key_collection_mode,
    key_filter: c.napi_key_filter,
    key_conversion: c.napi_key_conversion,
) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to get property names", c.napi_get_all_property_names(env, value, key_mode, key_filter, key_conversion, &result));
    return result;
}

pub fn getProperty(env: c.napi_env, object: c.napi_value, key: c.napi_value) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to get property", c.napi_get_property(env, object, key, &result));
    return result;
}

pub fn getArrayLength(env: c.napi_env, value: c.napi_value) !u32 {
    var result: u32 = undefined;
    try maybeError(env, "Failed to get array length", c.napi_get_array_length(env, value, &result));
    return result;
}

pub fn getElement(env: c.napi_env, value: c.napi_value, index: u32) !c.napi_value {
    var result: c.napi_value = undefined;
    try maybeError(env, "Failed to get element", c.napi_get_element(env, value, index, &result));
    return result;
}

pub fn isArray(env: c.napi_env, value: c.napi_value) !bool {
    var result: bool = undefined;
    try maybeError(env, "Failed to get array length", c.napi_is_array(env, value, &result));
    return result;
}

pub fn getBigintValueBytes(env: c.napi_env, value: c.napi_value, allocator: std.mem.Allocator) !struct { sign: c_int, bytes: []const u8 } {
    var word_count: usize = undefined;
    try maybeError(env, "Failed to get bigint words length", c.napi_get_value_bigint_words(env, value, null, &word_count, null));
    var sign: c_int = undefined;
    const bytes = try allocator.alloc(u8, word_count * 8);
    try maybeError(env, "Failed to get bigint words", c.napi_get_value_bigint_words(env, value, &sign, &word_count, @ptrCast(@alignCast(bytes.ptr))));
    return .{ .sign = sign, .bytes = bytes };
}

pub fn getDoubleValue(env: c.napi_env, value: c.napi_value) !f64 {
    var result: f64 = undefined;
    try maybeError(env, "Failed to get double value", c.napi_get_value_double(env, value, &result));
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
