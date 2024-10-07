const std = @import("std");
const assert = std.debug.assert;
const builtin = @import("builtin");
const nf = @import("napi_functions.zig");
const napi = @import("napi.zig");

const windows = @cImport({
    @cInclude("windows.h");
});

fn nullIfWindows(v: anytype) ?@TypeOf(v) {
    if (builtin.os.tag == .windows) {
        return null;
    } else {
        return v;
    }
}

const Functions = struct {
    napi_throw_error: ?*const @TypeOf(nf.napi_throw_error) = nullIfWindows(&nf.napi_throw_error),
    napi_create_function: ?*const @TypeOf(nf.napi_create_function) = nullIfWindows(&nf.napi_create_function),
    napi_set_property: ?*const @TypeOf(nf.napi_set_property) = nullIfWindows(&nf.napi_set_property),
    napi_set_named_property: ?*const @TypeOf(nf.napi_set_named_property) = nullIfWindows(&nf.napi_set_named_property),
    napi_create_string_utf8: ?*const @TypeOf(nf.napi_create_string_utf8) = nullIfWindows(&nf.napi_create_string_utf8),
    napi_get_null: ?*const @TypeOf(nf.napi_get_null) = nullIfWindows(&nf.napi_get_null),
    napi_get_undefined: ?*const @TypeOf(nf.napi_get_undefined) = nullIfWindows(&nf.napi_get_undefined),
    napi_create_uint32: ?*const @TypeOf(nf.napi_create_uint32) = nullIfWindows(&nf.napi_create_uint32),
    napi_create_int32: ?*const @TypeOf(nf.napi_create_int32) = nullIfWindows(&nf.napi_create_int32),
    napi_get_cb_info: ?*const @TypeOf(nf.napi_get_cb_info) = nullIfWindows(&nf.napi_get_cb_info),
    napi_create_double: ?*const @TypeOf(nf.napi_create_double) = nullIfWindows(&nf.napi_create_double),
    napi_get_buffer_info: ?*const @TypeOf(nf.napi_get_buffer_info) = nullIfWindows(&nf.napi_get_buffer_info),
    napi_get_boolean: ?*const @TypeOf(nf.napi_get_boolean) = nullIfWindows(&nf.napi_get_boolean),
    napi_create_array_with_length: ?*const @TypeOf(nf.napi_create_array_with_length) = nullIfWindows(&nf.napi_create_array_with_length),
    napi_set_element: ?*const @TypeOf(nf.napi_set_element) = nullIfWindows(&nf.napi_set_element),
    napi_create_object: ?*const @TypeOf(nf.napi_create_object) = nullIfWindows(&nf.napi_create_object),
    napi_create_bigint_words: ?*const @TypeOf(nf.napi_create_bigint_words) = nullIfWindows(&nf.napi_create_bigint_words),
    napi_create_buffer_copy: ?*const @TypeOf(nf.napi_create_buffer_copy) = nullIfWindows(&nf.napi_create_buffer_copy),
    napi_typeof: ?*const @TypeOf(nf.napi_typeof) = nullIfWindows(&nf.napi_typeof),
    napi_get_value_string_utf8: ?*const @TypeOf(nf.napi_get_value_string_utf8) = nullIfWindows(&nf.napi_get_value_string_utf8),
    napi_get_property_names: ?*const @TypeOf(nf.napi_get_property_names) = nullIfWindows(&nf.napi_get_property_names),
    napi_get_all_property_names: ?*const @TypeOf(nf.napi_get_all_property_names) = nullIfWindows(&nf.napi_get_all_property_names),
    napi_get_property: ?*const @TypeOf(nf.napi_get_property) = nullIfWindows(&nf.napi_get_property),
    napi_get_array_length: ?*const @TypeOf(nf.napi_get_array_length) = nullIfWindows(&nf.napi_get_array_length),
    napi_get_element: ?*const @TypeOf(nf.napi_get_element) = nullIfWindows(&nf.napi_get_element),
    napi_is_array: ?*const @TypeOf(nf.napi_is_array) = nullIfWindows(&nf.napi_is_array),
    napi_get_value_bigint_words: ?*const @TypeOf(nf.napi_get_value_bigint_words) = nullIfWindows(&nf.napi_get_value_bigint_words),
    napi_get_value_double: ?*const @TypeOf(nf.napi_get_value_double) = nullIfWindows(&nf.napi_get_value_double),
    napi_get_value_bool: ?*const @TypeOf(nf.napi_get_value_bool) = nullIfWindows(&nf.napi_get_value_bool),

    compressBound: ?*const @TypeOf(nf.compressBound) = nullIfWindows(&nf.compressBound),
    compress: ?*const @TypeOf(nf.compress) = nullIfWindows(&nf.compress),
    uncompress: ?*const @TypeOf(nf.uncompress) = nullIfWindows(&nf.uncompress),
};

const functions = &functions_store;
var functions_store: Functions = .{};

pub fn initialize() !void {
    if (builtin.os.tag == .windows) {
        // get handle to self, be that node or electron or renamed electron
        const dll = windows.GetModuleHandleA(null);

        functions_store = .{
            .napi_throw_error = @ptrCast(windows.GetProcAddress(dll, "napi_throw_error")),
            .napi_create_function = @ptrCast(windows.GetProcAddress(dll, "napi_create_function")),
            .napi_set_property = @ptrCast(windows.GetProcAddress(dll, "napi_set_property")),
            .napi_set_named_property = @ptrCast(windows.GetProcAddress(dll, "napi_set_named_property")),
            .napi_create_string_utf8 = @ptrCast(windows.GetProcAddress(dll, "napi_create_string_utf8")),
            .napi_get_null = @ptrCast(windows.GetProcAddress(dll, "napi_get_null")),
            .napi_get_undefined = @ptrCast(windows.GetProcAddress(dll, "napi_get_undefined")),
            .napi_create_uint32 = @ptrCast(windows.GetProcAddress(dll, "napi_create_uint32")),
            .napi_create_int32 = @ptrCast(windows.GetProcAddress(dll, "napi_create_int32")),
            .napi_get_cb_info = @ptrCast(windows.GetProcAddress(dll, "napi_get_cb_info")),
            .napi_create_double = @ptrCast(windows.GetProcAddress(dll, "napi_create_double")),
            .napi_get_buffer_info = @ptrCast(windows.GetProcAddress(dll, "napi_get_buffer_info")),
            .napi_get_boolean = @ptrCast(windows.GetProcAddress(dll, "napi_get_boolean")),
            .napi_create_array_with_length = @ptrCast(windows.GetProcAddress(dll, "napi_create_array_with_length")),
            .napi_set_element = @ptrCast(windows.GetProcAddress(dll, "napi_set_element")),
            .napi_create_object = @ptrCast(windows.GetProcAddress(dll, "napi_create_object")),
            .napi_create_bigint_words = @ptrCast(windows.GetProcAddress(dll, "napi_create_bigint_words")),
            .napi_create_buffer_copy = @ptrCast(windows.GetProcAddress(dll, "napi_create_buffer_copy")),
            .napi_typeof = @ptrCast(windows.GetProcAddress(dll, "napi_typeof")),
            .napi_get_value_string_utf8 = @ptrCast(windows.GetProcAddress(dll, "napi_get_value_string_utf8")),
            .napi_get_property_names = @ptrCast(windows.GetProcAddress(dll, "napi_get_property_names")),
            .napi_get_all_property_names = @ptrCast(windows.GetProcAddress(dll, "napi_get_all_property_names")),
            .napi_get_property = @ptrCast(windows.GetProcAddress(dll, "napi_get_property")),
            .napi_get_array_length = @ptrCast(windows.GetProcAddress(dll, "napi_get_array_length")),
            .napi_get_element = @ptrCast(windows.GetProcAddress(dll, "napi_get_element")),
            .napi_is_array = @ptrCast(windows.GetProcAddress(dll, "napi_is_array")),
            .napi_get_value_bigint_words = @ptrCast(windows.GetProcAddress(dll, "napi_get_value_bigint_words")),
            .napi_get_value_double = @ptrCast(windows.GetProcAddress(dll, "napi_get_value_double")),
            .napi_get_value_bool = @ptrCast(windows.GetProcAddress(dll, "napi_get_value_bool")),

            .compressBound = @ptrCast(windows.GetProcAddress(dll, "compressBound")),
            .compress = @ptrCast(windows.GetProcAddress(dll, "compress")),
            .uncompress = @ptrCast(windows.GetProcAddress(dll, "uncompress")),
        };

        // we are in electron, zlib exports are prefixed with "Cr_z_"
        if (functions_store.compressBound == null) {
            functions_store.compressBound = @ptrCast(windows.GetProcAddress(dll, "Cr_z_compressBound"));
            functions_store.compress = @ptrCast(windows.GetProcAddress(dll, "Cr_z_compress"));
            functions_store.uncompress = @ptrCast(windows.GetProcAddress(dll, "Cr_z_uncompress"));
        }
    }
}

pub fn compressBound(sourceLen: c_ulong) c_ulong {
    assert(functions.compressBound != null);
    return functions.compressBound.?(sourceLen);
}

pub fn compress(dest: [*c]u8, destLen: [*c]c_ulong, source: [*c]const u8, sourceLen: c_ulong) c_int {
    assert(functions.compress != null);
    return functions.compress.?(dest, destLen, source, sourceLen);
}

pub fn uncompress(dest: [*c]u8, destLen: [*c]c_ulong, source: [*c]const u8, sourceLen: c_ulong) c_int {
    assert(functions.uncompress != null);
    return functions.uncompress.?(dest, destLen, source, sourceLen);
}

const napi_env = napi.napi_env;
const napi_value = napi.napi_value;
const napi_callback_info = napi.napi_callback_info;
const napi_callback = napi.napi_callback;
const napi_status = napi.napi_status;

pub const TranslationError = error{ExceptionThrown};
pub fn throw(env: napi_env, comptime message: [:0]const u8) TranslationError {
    assert(functions.napi_throw_error != null);

    _ = functions.napi_throw_error.?(env, null, @as([*c]const u8, @ptrCast(message)));

    return TranslationError.ExceptionThrown;
}

fn maybeError(env: napi_env, comptime message: [:0]const u8, result: napi_status) TranslationError!void {
    if (result != .ok) {
        return throw(env, message);
    }
}

pub fn createFunction(env: napi_env, function: napi_callback) !napi_value {
    assert(functions.napi_create_function != null);

    var napi_function: napi_value = undefined;
    try maybeError(env, "Failed to create function", functions.napi_create_function.?(env, null, 0, function, null, &napi_function));
    return napi_function;
}

pub fn createNamedFunction(env: napi_env, name: [:0]const u8, function: napi_callback) !napi_value {
    assert(functions.napi_create_named_function != null);

    var napi_function: napi_value = undefined;
    try maybeError(env, "Failed to create named function", functions.napi_create_function.?(env, name, name.len, function, null, &napi_function));
    return napi_function;
}

pub fn setProperty(env: napi_env, object: napi_value, key: napi_value, value: napi_value) !void {
    assert(functions.napi_set_property != null);

    try maybeError(env, "Failed to set property", functions.napi_set_property.?(env, object, key, value));
}

pub fn setNamedProperty(env: napi_env, object: napi_value, name: [:0]const u8, value: napi_value) !void {
    assert(functions.napi_set_named_property != null);

    try maybeError(env, "Failed to set named property", functions.napi_set_named_property.?(env, object, name, value));
}

pub fn createString(env: napi_env, slice: []const u8) !napi_value {
    assert(functions.napi_create_string_utf8 != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to create string", functions.napi_create_string_utf8.?(env, slice.ptr, slice.len, &result));
    return result;
}

pub fn getNull(env: napi_env) !napi_value {
    assert(functions.napi_get_null != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to get null", functions.napi_get_null.?(env, &result));
    return result;
}

pub fn getUndefined(env: napi_env) !napi_value {
    assert(functions.napi_get_undefined != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to get undefined", functions.napi_get_undefined.?(env, &result));
    return result;
}

pub fn createUint32(env: napi_env, value: u32) !napi_value {
    assert(functions.napi_create_uint32 != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to create uint32", functions.napi_create_uint32.?(env, value, &result));
    return result;
}

pub fn createInt32(env: napi_env, value: i32) !napi_value {
    assert(functions.napi_create_int32 != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to create int32", functions.napi_create_int32.?(env, value, &result));
    return result;
}

pub fn extractArgs(env: napi_env, info: napi_callback_info, comptime argc: usize) !struct {
    argv: [argc]napi_value,
    argc: usize,
} {
    assert(functions.napi_get_cb_info != null);

    var _argc: usize = argc;
    var argv: [argc]napi_value = undefined;
    try maybeError(env, "Failed to extract args", functions.napi_get_cb_info.?(env, info, &_argc, &argv, null, null));
    return .{ .argv = argv, .argc = _argc };
}

pub fn createDouble(env: napi_env, value: f64) !napi_value {
    assert(functions.napi_create_double != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to create double", functions.napi_create_double.?(env, value, &result));
    return result;
}

pub fn getBufferInfo(env: napi_env, value: napi_value) ![]const u8 {
    assert(functions.napi_get_buffer_info != null);

    var data: ?*anyopaque = null;
    var len: usize = undefined;
    try maybeError(env, "Failed to get buffer info", functions.napi_get_buffer_info.?(env, value, &data, &len));
    if (data == null) {
        return &[0]u8{};
    }

    return @as([*]u8, @ptrCast(data))[0..len];
}

pub fn getBool(env: napi_env, value: bool) !napi_value {
    assert(functions.napi_get_boolean != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to get bool", functions.napi_get_boolean.?(env, value, &result));
    return result;
}

pub fn createArrayWithLength(env: napi_env, length: usize) !napi_value {
    assert(functions.napi_create_array_with_length != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to create array", functions.napi_create_array_with_length.?(env, length, &result));
    return result;
}

pub fn setElement(env: napi_env, object: napi_value, index: u32, value: napi_value) !void {
    assert(functions.napi_set_element != null);

    try maybeError(env, "Failed to set element", functions.napi_set_element.?(env, object, index, value));
}

pub fn createObject(env: napi_env) !napi_value {
    assert(functions.napi_create_object != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to create object", functions.napi_create_object.?(env, &result));
    return result;
}

pub fn createBigintBytes(env: napi_env, sign: u8, bytes: []const u8) !napi_value {
    assert(functions.napi_create_bigint_words != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to create bigint", functions.napi_create_bigint_words.?(env, sign, bytes.len / 8, @ptrCast(@alignCast(bytes.ptr)), &result));
    return result;
}

pub fn createArrayBuffer(env: napi_env, data: []const u8) !napi_value {
    assert(functions.napi_create_buffer_copy != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to create array buffer", functions.napi_create_buffer_copy.?(env, data.len, data.ptr, null, &result));
    return result;
}

pub fn typeof(env: napi_env, value: napi_value) !napi.napi_valuetype {
    assert(functions.napi_typeof != null);

    var result: napi.napi_valuetype = undefined;
    try maybeError(env, "Failed to get type", functions.napi_typeof.?(env, value, &result));
    return result;
}

pub fn getBoolValue(env: napi_env, value: napi_value) !bool {
    assert(functions.napi_get_value_bool != null);

    var result: bool = undefined;
    try maybeError(env, "Failed to get bool value", functions.napi_get_value_bool.?(env, value, &result));
    return result;
}

pub fn getStringUtf8Value(env: napi_env, value: napi_value, allocator: std.mem.Allocator) ![:0]const u8 {
    assert(functions.napi_get_value_string_utf8 != null);

    var length: usize = undefined;
    try maybeError(env, "Failed to get string length", functions.napi_get_value_string_utf8.?(env, value, null, 0, &length));
    const buffer = try allocator.allocSentinel(u8, length, 0);
    try maybeError(env, "Failed to get string value", functions.napi_get_value_string_utf8.?(env, value, buffer.ptr, buffer.len + 1, &length));
    return buffer;
}

pub fn getPropertyNames(env: napi_env, value: napi_value) !napi_value {
    assert(functions.napi_get_property_names != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to get property names", functions.napi_get_property_names.?(env, value, &result));
    return result;
}

pub fn getAllPropertyNames(
    env: napi_env,
    value: napi_value,
    key_mode: napi.napi_key_collection_mode,
    key_filter: napi.napi_key_filter,
    key_conversion: napi.napi_key_conversion,
) !napi_value {
    assert(functions.napi_get_all_property_names != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to get property names", functions.napi_get_all_property_names.?(env, value, key_mode, key_filter, key_conversion, &result));
    return result;
}

pub fn getProperty(env: napi_env, object: napi_value, key: napi_value) !napi_value {
    assert(functions.napi_get_property != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to get property", functions.napi_get_property.?(env, object, key, &result));
    return result;
}

pub fn getArrayLength(env: napi_env, value: napi_value) !u32 {
    assert(functions.napi_get_array_length != null);

    var result: u32 = undefined;
    try maybeError(env, "Failed to get array length", functions.napi_get_array_length.?(env, value, &result));
    return result;
}

pub fn getElement(env: napi_env, value: napi_value, index: u32) !napi_value {
    assert(functions.napi_get_element != null);

    var result: napi_value = undefined;
    try maybeError(env, "Failed to get element", functions.napi_get_element.?(env, value, index, &result));
    return result;
}

pub fn isArray(env: napi_env, value: napi_value) !bool {
    assert(functions.napi_is_array != null);

    var result: bool = undefined;
    try maybeError(env, "Failed to get array length", functions.napi_is_array.?(env, value, &result));
    return result;
}

pub fn getBigintValueBytes(env: napi_env, value: napi_value, allocator: std.mem.Allocator) !struct { sign: c_int, bytes: []const u8 } {
    assert(functions.napi_get_value_bigint_words != null);

    var word_count: usize = undefined;
    try maybeError(env, "Failed to get bigint words length", functions.napi_get_value_bigint_words.?(env, value, null, &word_count, null));
    var sign: c_int = undefined;
    const bytes = try allocator.alignedAlloc(u8, @alignOf(u64), word_count * 8);
    try maybeError(env, "Failed to get bigint words", functions.napi_get_value_bigint_words.?(env, value, &sign, &word_count, @ptrCast(@alignCast(bytes.ptr))));
    return .{ .sign = sign, .bytes = bytes };
}

pub fn getDoubleValue(env: napi_env, value: napi_value) !f64 {
    assert(functions.napi_get_value_double != null);

    var result: f64 = undefined;
    try maybeError(env, "Failed to get double value", functions.napi_get_value_double.?(env, value, &result));
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
