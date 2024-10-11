const std = @import("std");
const assert = std.debug.assert;
const builtin = @import("builtin");
const napi = @import("napi.zig");
const shim = @import("shim.zig");

const napi_env = napi.napi_env;
const napi_value = napi.napi_value;
const napi_callback_info = napi.napi_callback_info;
const napi_callback = napi.napi_callback;
const napi_status = napi.napi_status;

pub const TranslationError = error{ExceptionThrown};
pub fn throw(env: napi_env, comptime message: [:0]const u8) TranslationError {
    _ = shim.napi_throw_error(env, null, @as([*c]const u8, @ptrCast(message)));

    return TranslationError.ExceptionThrown;
}

fn maybeError(env: napi_env, comptime message: [:0]const u8, result: napi_status) TranslationError!void {
    if (result != .ok) {
        return throw(env, message);
    }
}

pub fn createFunction(env: napi_env, function: napi_callback) !napi_value {
    var napi_function: napi_value = undefined;
    try maybeError(env, "Failed to create function", shim.napi_create_function(env, null, 0, function, null, &napi_function));
    return napi_function;
}

pub fn createNamedFunction(env: napi_env, name: [:0]const u8, function: napi_callback) !napi_value {
    var napi_function: napi_value = undefined;
    try maybeError(env, "Failed to create named function", shim.napi_create_function(env, name, name.len, function, null, &napi_function));
    return napi_function;
}

pub fn setProperty(env: napi_env, object: napi_value, key: napi_value, value: napi_value) !void {
    try maybeError(env, "Failed to set property", shim.napi_set_property(env, object, key, value));
}

pub fn setNamedProperty(env: napi_env, object: napi_value, name: [:0]const u8, value: napi_value) !void {
    try maybeError(env, "Failed to set named property", shim.napi_set_named_property(env, object, name, value));
}

pub fn createString(env: napi_env, slice: []const u8) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to create string", shim.napi_create_string_utf8(env, slice.ptr, slice.len, &result));
    return result;
}

pub fn getNull(env: napi_env) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to get null", shim.napi_get_null(env, &result));
    return result;
}

pub fn getUndefined(env: napi_env) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to get undefined", shim.napi_get_undefined(env, &result));
    return result;
}

pub fn createUint32(env: napi_env, value: u32) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to create uint32", shim.napi_create_uint32(env, value, &result));
    return result;
}

pub fn createInt32(env: napi_env, value: i32) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to create int32", shim.napi_create_int32(env, value, &result));
    return result;
}

pub fn extractArgs(env: napi_env, info: napi_callback_info, comptime argc: usize) !struct {
    argv: [argc]napi_value,
    argc: usize,
} {
    var _argc: usize = argc;
    var argv: [argc]napi_value = undefined;
    try maybeError(env, "Failed to extract args", shim.napi_get_cb_info(env, info, &_argc, &argv, null, null));
    return .{ .argv = argv, .argc = _argc };
}

pub fn createDouble(env: napi_env, value: f64) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to create double", shim.napi_create_double(env, value, &result));
    return result;
}

pub fn getBufferInfo(env: napi_env, value: napi_value) ![]const u8 {
    var data: ?*anyopaque = null;
    var len: usize = undefined;
    try maybeError(env, "Failed to get buffer info", shim.napi_get_buffer_info(env, value, &data, &len));
    if (data == null) {
        return &[0]u8{};
    }

    return @as([*]u8, @ptrCast(data))[0..len];
}

pub fn getBool(env: napi_env, value: bool) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to get bool", shim.napi_get_boolean(env, value, &result));
    return result;
}

pub fn createArrayWithLength(env: napi_env, length: usize) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to create array", shim.napi_create_array_with_length(env, length, &result));
    return result;
}

pub fn setElement(env: napi_env, object: napi_value, index: u32, value: napi_value) !void {
    try maybeError(env, "Failed to set element", shim.napi_set_element(env, object, index, value));
}

pub fn createObject(env: napi_env) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to create object", shim.napi_create_object(env, &result));
    return result;
}

pub fn createBigintBytes(env: napi_env, sign: u8, bytes: []const u8) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to create bigint", shim.napi_create_bigint_words(env, sign, bytes.len / 8, @ptrCast(@alignCast(bytes.ptr)), &result));
    return result;
}

pub fn createArrayBuffer(env: napi_env, data: []const u8) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to create array buffer", shim.napi_create_buffer_copy(env, data.len, data.ptr, null, &result));
    return result;
}

pub fn typeof(env: napi_env, value: napi_value) !napi.napi_valuetype {
    var result: napi.napi_valuetype = undefined;
    try maybeError(env, "Failed to get type", shim.napi_typeof(env, value, &result));
    return result;
}

pub fn getBoolValue(env: napi_env, value: napi_value) !bool {
    var result: bool = undefined;
    try maybeError(env, "Failed to get bool value", shim.napi_get_value_bool(env, value, &result));
    return result;
}

pub fn getStringUtf8Value(env: napi_env, value: napi_value, allocator: std.mem.Allocator) ![:0]const u8 {
    var length: usize = undefined;
    try maybeError(env, "Failed to get string length", shim.napi_get_value_string_utf8(env, value, null, 0, &length));
    const buffer = try allocator.allocSentinel(u8, length, 0);
    try maybeError(env, "Failed to get string value", shim.napi_get_value_string_utf8(env, value, buffer.ptr, buffer.len + 1, &length));
    return buffer;
}

pub fn getPropertyNames(env: napi_env, value: napi_value) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to get property names", shim.napi_get_property_names(env, value, &result));
    return result;
}

pub fn getAllPropertyNames(
    env: napi_env,
    value: napi_value,
    key_mode: napi.napi_key_collection_mode,
    key_filter: napi.napi_key_filter,
    key_conversion: napi.napi_key_conversion,
) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to get property names", shim.napi_get_all_property_names(env, value, key_mode, key_filter, key_conversion, &result));
    return result;
}

pub fn getProperty(env: napi_env, object: napi_value, key: napi_value) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to get property", shim.napi_get_property(env, object, key, &result));
    return result;
}

pub fn getArrayLength(env: napi_env, value: napi_value) !u32 {
    var result: u32 = undefined;
    try maybeError(env, "Failed to get array length", shim.napi_get_array_length(env, value, &result));
    return result;
}

pub fn getElement(env: napi_env, value: napi_value, index: u32) !napi_value {
    var result: napi_value = undefined;
    try maybeError(env, "Failed to get element", shim.napi_get_element(env, value, index, &result));
    return result;
}

pub fn isArray(env: napi_env, value: napi_value) !bool {
    var result: bool = undefined;
    try maybeError(env, "Failed to get array length", shim.napi_is_array(env, value, &result));
    return result;
}

pub fn getBigintValueBytes(env: napi_env, value: napi_value, allocator: std.mem.Allocator) !struct { sign: c_int, bytes: []const u8 } {
    var word_count: usize = undefined;
    try maybeError(env, "Failed to get bigint words length", shim.napi_get_value_bigint_words(env, value, null, &word_count, null));
    var sign: c_int = undefined;
    const bytes = try allocator.alignedAlloc(u8, @alignOf(u64), word_count * 8);
    try maybeError(env, "Failed to get bigint words", shim.napi_get_value_bigint_words(env, value, &sign, &word_count, @ptrCast(@alignCast(bytes.ptr))));
    return .{ .sign = sign, .bytes = bytes };
}

pub fn getDoubleValue(env: napi_env, value: napi_value) !f64 {
    var result: f64 = undefined;
    try maybeError(env, "Failed to get double value", shim.napi_get_value_double(env, value, &result));
    return result;
}

pub fn registerFunction(
    env: napi_env,
    exports: napi_value,
    comptime name: [:0]const u8,
    function: fn (napi_env, napi_callback_info) callconv(.C) napi_value,
) !void {
    const function_value = try createFunction(env, function);
    try setNamedProperty(env, exports, name, function_value);
}
