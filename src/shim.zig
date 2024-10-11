const builtin = @import("builtin");
const std = @import("std");
const n = @import("napi.zig");
const fns = @import("napi_functions.zig");

const windows = @cImport({
    @cInclude("windows.h");
});

const isWindows = builtin.os.tag == .windows;

var dll: windows.HMODULE = undefined;

pub fn initialize() void {
    if (isWindows) {
        dll = windows.GetModuleHandleA(null);
    }
}

fn nw(f: anytype) ?@TypeOf(f) {
    if (isWindows) {
        return null;
    } else {
        return f;
    }
}

inline fn ensure(f: anytype, comptime names: []const [:0]const u8) void {
    if (!isWindows) {
        return;
    }

    if (f.* == null) {
        for (names) |name| {
            if (f.* != null) break;
            f.* = @ptrCast(windows.GetProcAddress(dll, name));
        }
    }
}

// generated napi shims

var _napi_acquire_threadsafe_function = nw(&fns.napi_acquire_threadsafe_function);
pub fn napi_acquire_threadsafe_function(func: n.napi_threadsafe_function) n.napi_status {
    ensure(&_napi_acquire_threadsafe_function, &.{"napi_acquire_threadsafe_function"});
    return _napi_acquire_threadsafe_function.?(func);
}

var _napi_add_async_cleanup_hook = nw(&fns.napi_add_async_cleanup_hook);
pub fn napi_add_async_cleanup_hook(env: n.node_api_basic_env, hook: n.napi_async_cleanup_hook, arg: ?*anyopaque, remove_handle: [*c]n.napi_async_cleanup_hook_handle) n.napi_status {
    ensure(&_napi_add_async_cleanup_hook, &.{"napi_add_async_cleanup_hook"});
    return _napi_add_async_cleanup_hook.?(env, hook, arg, remove_handle);
}

var _napi_add_env_cleanup_hook = nw(&fns.napi_add_env_cleanup_hook);
pub fn napi_add_env_cleanup_hook(env: n.node_api_basic_env, fun: n.napi_cleanup_hook, arg: ?*anyopaque) n.napi_status {
    ensure(&_napi_add_env_cleanup_hook, &.{"napi_add_env_cleanup_hook"});
    return _napi_add_env_cleanup_hook.?(env, fun, arg);
}

var _napi_add_finalizer = nw(&fns.napi_add_finalizer);
pub fn napi_add_finalizer(env: n.napi_env, js_object: n.napi_value, finalize_data: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_ref) n.napi_status {
    ensure(&_napi_add_finalizer, &.{"napi_add_finalizer"});
    return _napi_add_finalizer.?(env, js_object, finalize_data, finalize_cb, finalize_hint, result);
}

var _napi_adjust_external_memory = nw(&fns.napi_adjust_external_memory);
pub fn napi_adjust_external_memory(env: n.node_api_basic_env, change_in_bytes: i64, adjusted_value: [*c]i64) n.napi_status {
    ensure(&_napi_adjust_external_memory, &.{"napi_adjust_external_memory"});
    return _napi_adjust_external_memory.?(env, change_in_bytes, adjusted_value);
}

var _napi_async_destroy = nw(&fns.napi_async_destroy);
pub fn napi_async_destroy(env: n.napi_env, async_context: n.napi_async_context) n.napi_status {
    ensure(&_napi_async_destroy, &.{"napi_async_destroy"});
    return _napi_async_destroy.?(env, async_context);
}

var _napi_async_init = nw(&fns.napi_async_init);
pub fn napi_async_init(env: n.napi_env, async_resource: n.napi_value, async_resource_name: n.napi_value, result: [*c]n.napi_async_context) n.napi_status {
    ensure(&_napi_async_init, &.{"napi_async_init"});
    return _napi_async_init.?(env, async_resource, async_resource_name, result);
}

var _napi_call_function = nw(&fns.napi_call_function);
pub fn napi_call_function(env: n.napi_env, recv: n.napi_value, func: n.napi_value, argc: usize, argv: [*c]const n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_call_function, &.{"napi_call_function"});
    return _napi_call_function.?(env, recv, func, argc, argv, result);
}

var _napi_call_threadsafe_function = nw(&fns.napi_call_threadsafe_function);
pub fn napi_call_threadsafe_function(func: n.napi_threadsafe_function, data: ?*anyopaque, is_blocking: n.napi_threadsafe_function_call_mode) n.napi_status {
    ensure(&_napi_call_threadsafe_function, &.{"napi_call_threadsafe_function"});
    return _napi_call_threadsafe_function.?(func, data, is_blocking);
}

var _napi_cancel_async_work = nw(&fns.napi_cancel_async_work);
pub fn napi_cancel_async_work(env: n.node_api_basic_env, work: n.napi_async_work) n.napi_status {
    ensure(&_napi_cancel_async_work, &.{"napi_cancel_async_work"});
    return _napi_cancel_async_work.?(env, work);
}

var _napi_check_object_type_tag = nw(&fns.napi_check_object_type_tag);
pub fn napi_check_object_type_tag(env: n.napi_env, value: n.napi_value, type_tag: [*c]const n.napi_type_tag, result: [*c]bool) n.napi_status {
    ensure(&_napi_check_object_type_tag, &.{"napi_check_object_type_tag"});
    return _napi_check_object_type_tag.?(env, value, type_tag, result);
}

var _napi_close_callback_scope = nw(&fns.napi_close_callback_scope);
pub fn napi_close_callback_scope(env: n.napi_env, scope: n.napi_callback_scope) n.napi_status {
    ensure(&_napi_close_callback_scope, &.{"napi_close_callback_scope"});
    return _napi_close_callback_scope.?(env, scope);
}

var _napi_close_escapable_handle_scope = nw(&fns.napi_close_escapable_handle_scope);
pub fn napi_close_escapable_handle_scope(env: n.napi_env, scope: n.napi_escapable_handle_scope) n.napi_status {
    ensure(&_napi_close_escapable_handle_scope, &.{"napi_close_escapable_handle_scope"});
    return _napi_close_escapable_handle_scope.?(env, scope);
}

var _napi_close_handle_scope = nw(&fns.napi_close_handle_scope);
pub fn napi_close_handle_scope(env: n.napi_env, scope: n.napi_handle_scope) n.napi_status {
    ensure(&_napi_close_handle_scope, &.{"napi_close_handle_scope"});
    return _napi_close_handle_scope.?(env, scope);
}

var _napi_coerce_to_bool = nw(&fns.napi_coerce_to_bool);
pub fn napi_coerce_to_bool(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_coerce_to_bool, &.{"napi_coerce_to_bool"});
    return _napi_coerce_to_bool.?(env, value, result);
}

var _napi_coerce_to_number = nw(&fns.napi_coerce_to_number);
pub fn napi_coerce_to_number(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_coerce_to_number, &.{"napi_coerce_to_number"});
    return _napi_coerce_to_number.?(env, value, result);
}

var _napi_coerce_to_object = nw(&fns.napi_coerce_to_object);
pub fn napi_coerce_to_object(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_coerce_to_object, &.{"napi_coerce_to_object"});
    return _napi_coerce_to_object.?(env, value, result);
}

var _napi_coerce_to_string = nw(&fns.napi_coerce_to_string);
pub fn napi_coerce_to_string(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_coerce_to_string, &.{"napi_coerce_to_string"});
    return _napi_coerce_to_string.?(env, value, result);
}

var _napi_create_array = nw(&fns.napi_create_array);
pub fn napi_create_array(env: n.napi_env, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_array, &.{"napi_create_array"});
    return _napi_create_array.?(env, result);
}

var _napi_create_array_with_length = nw(&fns.napi_create_array_with_length);
pub fn napi_create_array_with_length(env: n.napi_env, length: usize, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_array_with_length, &.{"napi_create_array_with_length"});
    return _napi_create_array_with_length.?(env, length, result);
}

var _napi_create_arraybuffer = nw(&fns.napi_create_arraybuffer);
pub fn napi_create_arraybuffer(env: n.napi_env, byte_length: usize, data: [*c]?*anyopaque, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_arraybuffer, &.{"napi_create_arraybuffer"});
    return _napi_create_arraybuffer.?(env, byte_length, data, result);
}

var _napi_create_async_work = nw(&fns.napi_create_async_work);
pub fn napi_create_async_work(env: n.napi_env, async_resource: n.napi_value, async_resource_name: n.napi_value, execute: n.napi_async_execute_callback, complete: n.napi_async_complete_callback, data: ?*anyopaque, result: [*c]n.napi_async_work) n.napi_status {
    ensure(&_napi_create_async_work, &.{"napi_create_async_work"});
    return _napi_create_async_work.?(env, async_resource, async_resource_name, execute, complete, data, result);
}

var _napi_create_bigint_int64 = nw(&fns.napi_create_bigint_int64);
pub fn napi_create_bigint_int64(env: n.napi_env, value: i64, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_bigint_int64, &.{"napi_create_bigint_int64"});
    return _napi_create_bigint_int64.?(env, value, result);
}

var _napi_create_bigint_uint64 = nw(&fns.napi_create_bigint_uint64);
pub fn napi_create_bigint_uint64(env: n.napi_env, value: u64, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_bigint_uint64, &.{"napi_create_bigint_uint64"});
    return _napi_create_bigint_uint64.?(env, value, result);
}

var _napi_create_bigint_words = nw(&fns.napi_create_bigint_words);
pub fn napi_create_bigint_words(env: n.napi_env, sign_bit: c_int, word_count: usize, words: [*c]const u64, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_bigint_words, &.{"napi_create_bigint_words"});
    return _napi_create_bigint_words.?(env, sign_bit, word_count, words, result);
}

var _napi_create_buffer = nw(&fns.napi_create_buffer);
pub fn napi_create_buffer(env: n.napi_env, length: usize, data: [*c]?*anyopaque, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_buffer, &.{"napi_create_buffer"});
    return _napi_create_buffer.?(env, length, data, result);
}

var _napi_create_buffer_copy = nw(&fns.napi_create_buffer_copy);
pub fn napi_create_buffer_copy(env: n.napi_env, length: usize, data: ?*const anyopaque, result_data: [*c]?*anyopaque, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_buffer_copy, &.{"napi_create_buffer_copy"});
    return _napi_create_buffer_copy.?(env, length, data, result_data, result);
}

var _napi_create_dataview = nw(&fns.napi_create_dataview);
pub fn napi_create_dataview(env: n.napi_env, length: usize, arraybuffer: n.napi_value, byte_offset: usize, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_dataview, &.{"napi_create_dataview"});
    return _napi_create_dataview.?(env, length, arraybuffer, byte_offset, result);
}

var _napi_create_date = nw(&fns.napi_create_date);
pub fn napi_create_date(env: n.napi_env, time: f64, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_date, &.{"napi_create_date"});
    return _napi_create_date.?(env, time, result);
}

var _napi_create_double = nw(&fns.napi_create_double);
pub fn napi_create_double(env: n.napi_env, value: f64, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_double, &.{"napi_create_double"});
    return _napi_create_double.?(env, value, result);
}

var _napi_create_error = nw(&fns.napi_create_error);
pub fn napi_create_error(env: n.napi_env, code: n.napi_value, msg: n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_error, &.{"napi_create_error"});
    return _napi_create_error.?(env, code, msg, result);
}

var _napi_create_external = nw(&fns.napi_create_external);
pub fn napi_create_external(env: n.napi_env, data: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_external, &.{"napi_create_external"});
    return _napi_create_external.?(env, data, finalize_cb, finalize_hint, result);
}

var _napi_create_external_arraybuffer = nw(&fns.napi_create_external_arraybuffer);
pub fn napi_create_external_arraybuffer(env: n.napi_env, external_data: ?*anyopaque, byte_length: usize, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_external_arraybuffer, &.{"napi_create_external_arraybuffer"});
    return _napi_create_external_arraybuffer.?(env, external_data, byte_length, finalize_cb, finalize_hint, result);
}

var _napi_create_external_buffer = nw(&fns.napi_create_external_buffer);
pub fn napi_create_external_buffer(env: n.napi_env, length: usize, data: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_external_buffer, &.{"napi_create_external_buffer"});
    return _napi_create_external_buffer.?(env, length, data, finalize_cb, finalize_hint, result);
}

var _napi_create_function = nw(&fns.napi_create_function);
pub fn napi_create_function(env: n.napi_env, utf8name: [*c]const u8, length: usize, cb: n.napi_callback, data: ?*anyopaque, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_function, &.{"napi_create_function"});
    return _napi_create_function.?(env, utf8name, length, cb, data, result);
}

var _napi_create_int32 = nw(&fns.napi_create_int32);
pub fn napi_create_int32(env: n.napi_env, value: i32, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_int32, &.{"napi_create_int32"});
    return _napi_create_int32.?(env, value, result);
}

var _napi_create_int64 = nw(&fns.napi_create_int64);
pub fn napi_create_int64(env: n.napi_env, value: i64, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_int64, &.{"napi_create_int64"});
    return _napi_create_int64.?(env, value, result);
}

var _napi_create_object = nw(&fns.napi_create_object);
pub fn napi_create_object(env: n.napi_env, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_object, &.{"napi_create_object"});
    return _napi_create_object.?(env, result);
}

var _napi_create_promise = nw(&fns.napi_create_promise);
pub fn napi_create_promise(env: n.napi_env, deferred: [*c]n.napi_deferred, promise: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_promise, &.{"napi_create_promise"});
    return _napi_create_promise.?(env, deferred, promise);
}

var _napi_create_range_error = nw(&fns.napi_create_range_error);
pub fn napi_create_range_error(env: n.napi_env, code: n.napi_value, msg: n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_range_error, &.{"napi_create_range_error"});
    return _napi_create_range_error.?(env, code, msg, result);
}

var _napi_create_reference = nw(&fns.napi_create_reference);
pub fn napi_create_reference(env: n.napi_env, value: n.napi_value, initial_refcount: u32, result: [*c]n.napi_ref) n.napi_status {
    ensure(&_napi_create_reference, &.{"napi_create_reference"});
    return _napi_create_reference.?(env, value, initial_refcount, result);
}

var _napi_create_string_latin1 = nw(&fns.napi_create_string_latin1);
pub fn napi_create_string_latin1(env: n.napi_env, str: [*c]const u8, length: usize, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_string_latin1, &.{"napi_create_string_latin1"});
    return _napi_create_string_latin1.?(env, str, length, result);
}

var _napi_create_string_utf16 = nw(&fns.napi_create_string_utf16);
pub fn napi_create_string_utf16(env: n.napi_env, str: [*c]const u16, length: usize, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_string_utf16, &.{"napi_create_string_utf16"});
    return _napi_create_string_utf16.?(env, str, length, result);
}

var _napi_create_string_utf8 = nw(&fns.napi_create_string_utf8);
pub fn napi_create_string_utf8(env: n.napi_env, str: [*c]const u8, length: usize, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_string_utf8, &.{"napi_create_string_utf8"});
    return _napi_create_string_utf8.?(env, str, length, result);
}

var _napi_create_symbol = nw(&fns.napi_create_symbol);
pub fn napi_create_symbol(env: n.napi_env, description: n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_symbol, &.{"napi_create_symbol"});
    return _napi_create_symbol.?(env, description, result);
}

var _napi_create_threadsafe_function = nw(&fns.napi_create_threadsafe_function);
pub fn napi_create_threadsafe_function(env: n.napi_env, func: n.napi_value, async_resource: n.napi_value, async_resource_name: n.napi_value, max_queue_size: usize, initial_thread_count: usize, thread_finalize_data: ?*anyopaque, thread_finalize_cb: n.napi_finalize, context: ?*anyopaque, call_js_cb: n.napi_threadsafe_function_call_js, result: [*c]n.napi_threadsafe_function) n.napi_status {
    ensure(&_napi_create_threadsafe_function, &.{"napi_create_threadsafe_function"});
    return _napi_create_threadsafe_function.?(env, func, async_resource, async_resource_name, max_queue_size, initial_thread_count, thread_finalize_data, thread_finalize_cb, context, call_js_cb, result);
}

var _napi_create_type_error = nw(&fns.napi_create_type_error);
pub fn napi_create_type_error(env: n.napi_env, code: n.napi_value, msg: n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_type_error, &.{"napi_create_type_error"});
    return _napi_create_type_error.?(env, code, msg, result);
}

var _napi_create_typedarray = nw(&fns.napi_create_typedarray);
pub fn napi_create_typedarray(env: n.napi_env, @"type": n.napi_typedarray_type, length: usize, arraybuffer: n.napi_value, byte_offset: usize, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_typedarray, &.{"napi_create_typedarray"});
    return _napi_create_typedarray.?(env, @"type", length, arraybuffer, byte_offset, result);
}

var _napi_create_uint32 = nw(&fns.napi_create_uint32);
pub fn napi_create_uint32(env: n.napi_env, value: u32, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_create_uint32, &.{"napi_create_uint32"});
    return _napi_create_uint32.?(env, value, result);
}

var _napi_define_class = nw(&fns.napi_define_class);
pub fn napi_define_class(env: n.napi_env, utf8name: [*c]const u8, length: usize, constructor: n.napi_callback, data: ?*anyopaque, property_count: usize, properties: [*c]const n.napi_property_descriptor, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_define_class, &.{"napi_define_class"});
    return _napi_define_class.?(env, utf8name, length, constructor, data, property_count, properties, result);
}

var _napi_define_properties = nw(&fns.napi_define_properties);
pub fn napi_define_properties(env: n.napi_env, object: n.napi_value, property_count: usize, properties: [*c]const n.napi_property_descriptor) n.napi_status {
    ensure(&_napi_define_properties, &.{"napi_define_properties"});
    return _napi_define_properties.?(env, object, property_count, properties);
}

var _napi_delete_async_work = nw(&fns.napi_delete_async_work);
pub fn napi_delete_async_work(env: n.napi_env, work: n.napi_async_work) n.napi_status {
    ensure(&_napi_delete_async_work, &.{"napi_delete_async_work"});
    return _napi_delete_async_work.?(env, work);
}

var _napi_delete_element = nw(&fns.napi_delete_element);
pub fn napi_delete_element(env: n.napi_env, object: n.napi_value, index: u32, result: [*c]bool) n.napi_status {
    ensure(&_napi_delete_element, &.{"napi_delete_element"});
    return _napi_delete_element.?(env, object, index, result);
}

var _napi_delete_property = nw(&fns.napi_delete_property);
pub fn napi_delete_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, result: [*c]bool) n.napi_status {
    ensure(&_napi_delete_property, &.{"napi_delete_property"});
    return _napi_delete_property.?(env, object, key, result);
}

var _napi_delete_reference = nw(&fns.napi_delete_reference);
pub fn napi_delete_reference(env: n.napi_env, ref: n.napi_ref) n.napi_status {
    ensure(&_napi_delete_reference, &.{"napi_delete_reference"});
    return _napi_delete_reference.?(env, ref);
}

var _napi_detach_arraybuffer = nw(&fns.napi_detach_arraybuffer);
pub fn napi_detach_arraybuffer(env: n.napi_env, arraybuffer: n.napi_value) n.napi_status {
    ensure(&_napi_detach_arraybuffer, &.{"napi_detach_arraybuffer"});
    return _napi_detach_arraybuffer.?(env, arraybuffer);
}

var _napi_escape_handle = nw(&fns.napi_escape_handle);
pub fn napi_escape_handle(env: n.napi_env, scope: n.napi_escapable_handle_scope, escapee: n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_escape_handle, &.{"napi_escape_handle"});
    return _napi_escape_handle.?(env, scope, escapee, result);
}

var _napi_fatal_error = nw(&fns.napi_fatal_error);
pub fn napi_fatal_error(location: [*c]const u8, location_len: usize, message: [*c]const u8, message_len: usize) noreturn {
    ensure(&_napi_fatal_error, &.{"napi_fatal_error"});
    return _napi_fatal_error.?(location, location_len, message, message_len);
}

var _napi_fatal_exception = nw(&fns.napi_fatal_exception);
pub fn napi_fatal_exception(env: n.napi_env, err: n.napi_value) n.napi_status {
    ensure(&_napi_fatal_exception, &.{"napi_fatal_exception"});
    return _napi_fatal_exception.?(env, err);
}

var _napi_get_all_property_names = nw(&fns.napi_get_all_property_names);
pub fn napi_get_all_property_names(env: n.napi_env, object: n.napi_value, key_mode: n.napi_key_collection_mode, key_filter: n.napi_key_filter, key_conversion: n.napi_key_conversion, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_get_all_property_names, &.{"napi_get_all_property_names"});
    return _napi_get_all_property_names.?(env, object, key_mode, key_filter, key_conversion, result);
}

var _napi_get_and_clear_last_exception = nw(&fns.napi_get_and_clear_last_exception);
pub fn napi_get_and_clear_last_exception(env: n.napi_env, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_get_and_clear_last_exception, &.{"napi_get_and_clear_last_exception"});
    return _napi_get_and_clear_last_exception.?(env, result);
}

var _napi_get_array_length = nw(&fns.napi_get_array_length);
pub fn napi_get_array_length(env: n.napi_env, value: n.napi_value, result: [*c]u32) n.napi_status {
    ensure(&_napi_get_array_length, &.{"napi_get_array_length"});
    return _napi_get_array_length.?(env, value, result);
}

var _napi_get_arraybuffer_info = nw(&fns.napi_get_arraybuffer_info);
pub fn napi_get_arraybuffer_info(env: n.napi_env, arraybuffer: n.napi_value, data: [*c]?*anyopaque, byte_length: [*c]usize) n.napi_status {
    ensure(&_napi_get_arraybuffer_info, &.{"napi_get_arraybuffer_info"});
    return _napi_get_arraybuffer_info.?(env, arraybuffer, data, byte_length);
}

var _napi_get_boolean = nw(&fns.napi_get_boolean);
pub fn napi_get_boolean(env: n.napi_env, value: bool, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_get_boolean, &.{"napi_get_boolean"});
    return _napi_get_boolean.?(env, value, result);
}

var _napi_get_buffer_info = nw(&fns.napi_get_buffer_info);
pub fn napi_get_buffer_info(env: n.napi_env, value: n.napi_value, data: [*c]?*anyopaque, length: [*c]usize) n.napi_status {
    ensure(&_napi_get_buffer_info, &.{"napi_get_buffer_info"});
    return _napi_get_buffer_info.?(env, value, data, length);
}

var _napi_get_cb_info = nw(&fns.napi_get_cb_info);
pub fn napi_get_cb_info(env: n.napi_env, cbinfo: n.napi_callback_info, argc: [*c]usize, argv: [*c]n.napi_value, this_arg: [*c]n.napi_value, data: [*c]?*anyopaque) n.napi_status {
    ensure(&_napi_get_cb_info, &.{"napi_get_cb_info"});
    return _napi_get_cb_info.?(env, cbinfo, argc, argv, this_arg, data);
}

var _napi_get_dataview_info = nw(&fns.napi_get_dataview_info);
pub fn napi_get_dataview_info(env: n.napi_env, dataview: n.napi_value, bytelength: [*c]usize, data: [*c]?*anyopaque, arraybuffer: [*c]n.napi_value, byte_offset: [*c]usize) n.napi_status {
    ensure(&_napi_get_dataview_info, &.{"napi_get_dataview_info"});
    return _napi_get_dataview_info.?(env, dataview, bytelength, data, arraybuffer, byte_offset);
}

var _napi_get_date_value = nw(&fns.napi_get_date_value);
pub fn napi_get_date_value(env: n.napi_env, value: n.napi_value, result: [*c]f64) n.napi_status {
    ensure(&_napi_get_date_value, &.{"napi_get_date_value"});
    return _napi_get_date_value.?(env, value, result);
}

var _napi_get_element = nw(&fns.napi_get_element);
pub fn napi_get_element(env: n.napi_env, object: n.napi_value, index: u32, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_get_element, &.{"napi_get_element"});
    return _napi_get_element.?(env, object, index, result);
}

var _napi_get_global = nw(&fns.napi_get_global);
pub fn napi_get_global(env: n.napi_env, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_get_global, &.{"napi_get_global"});
    return _napi_get_global.?(env, result);
}

var _napi_get_instance_data = nw(&fns.napi_get_instance_data);
pub fn napi_get_instance_data(env: n.node_api_basic_env, data: [*c]?*anyopaque) n.napi_status {
    ensure(&_napi_get_instance_data, &.{"napi_get_instance_data"});
    return _napi_get_instance_data.?(env, data);
}

var _napi_get_last_error_info = nw(&fns.napi_get_last_error_info);
pub fn napi_get_last_error_info(env: n.node_api_basic_env, result: [*c][*c]const n.napi_extended_error_info) n.napi_status {
    ensure(&_napi_get_last_error_info, &.{"napi_get_last_error_info"});
    return _napi_get_last_error_info.?(env, result);
}

var _napi_get_named_property = nw(&fns.napi_get_named_property);
pub fn napi_get_named_property(env: n.napi_env, object: n.napi_value, utf8name: [*c]const u8, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_get_named_property, &.{"napi_get_named_property"});
    return _napi_get_named_property.?(env, object, utf8name, result);
}

var _napi_get_new_target = nw(&fns.napi_get_new_target);
pub fn napi_get_new_target(env: n.napi_env, cbinfo: n.napi_callback_info, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_get_new_target, &.{"napi_get_new_target"});
    return _napi_get_new_target.?(env, cbinfo, result);
}

var _napi_get_node_version = nw(&fns.napi_get_node_version);
pub fn napi_get_node_version(env: n.node_api_basic_env, version: [*c][*c]const n.napi_node_version) n.napi_status {
    ensure(&_napi_get_node_version, &.{"napi_get_node_version"});
    return _napi_get_node_version.?(env, version);
}

var _napi_get_null = nw(&fns.napi_get_null);
pub fn napi_get_null(env: n.napi_env, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_get_null, &.{"napi_get_null"});
    return _napi_get_null.?(env, result);
}

var _napi_get_property = nw(&fns.napi_get_property);
pub fn napi_get_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_get_property, &.{"napi_get_property"});
    return _napi_get_property.?(env, object, key, result);
}

var _napi_get_property_names = nw(&fns.napi_get_property_names);
pub fn napi_get_property_names(env: n.napi_env, object: n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_get_property_names, &.{"napi_get_property_names"});
    return _napi_get_property_names.?(env, object, result);
}

var _napi_get_prototype = nw(&fns.napi_get_prototype);
pub fn napi_get_prototype(env: n.napi_env, object: n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_get_prototype, &.{"napi_get_prototype"});
    return _napi_get_prototype.?(env, object, result);
}

var _napi_get_reference_value = nw(&fns.napi_get_reference_value);
pub fn napi_get_reference_value(env: n.napi_env, ref: n.napi_ref, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_get_reference_value, &.{"napi_get_reference_value"});
    return _napi_get_reference_value.?(env, ref, result);
}

var _napi_get_threadsafe_function_context = nw(&fns.napi_get_threadsafe_function_context);
pub fn napi_get_threadsafe_function_context(func: n.napi_threadsafe_function, result: [*c]?*anyopaque) n.napi_status {
    ensure(&_napi_get_threadsafe_function_context, &.{"napi_get_threadsafe_function_context"});
    return _napi_get_threadsafe_function_context.?(func, result);
}

var _napi_get_typedarray_info = nw(&fns.napi_get_typedarray_info);
pub fn napi_get_typedarray_info(env: n.napi_env, typedarray: n.napi_value, @"type": [*c]n.napi_typedarray_type, length: [*c]usize, data: [*c]?*anyopaque, arraybuffer: [*c]n.napi_value, byte_offset: [*c]usize) n.napi_status {
    ensure(&_napi_get_typedarray_info, &.{"napi_get_typedarray_info"});
    return _napi_get_typedarray_info.?(env, typedarray, @"type", length, data, arraybuffer, byte_offset);
}

var _napi_get_undefined = nw(&fns.napi_get_undefined);
pub fn napi_get_undefined(env: n.napi_env, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_get_undefined, &.{"napi_get_undefined"});
    return _napi_get_undefined.?(env, result);
}

var _napi_get_uv_event_loop = nw(&fns.napi_get_uv_event_loop);
pub fn napi_get_uv_event_loop(env: n.node_api_basic_env, loop: [*c]?*n.struct_uv_loop_s) n.napi_status {
    ensure(&_napi_get_uv_event_loop, &.{"napi_get_uv_event_loop"});
    return _napi_get_uv_event_loop.?(env, loop);
}

var _napi_get_value_bigint_int64 = nw(&fns.napi_get_value_bigint_int64);
pub fn napi_get_value_bigint_int64(env: n.napi_env, value: n.napi_value, result: [*c]i64, lossless: [*c]bool) n.napi_status {
    ensure(&_napi_get_value_bigint_int64, &.{"napi_get_value_bigint_int64"});
    return _napi_get_value_bigint_int64.?(env, value, result, lossless);
}

var _napi_get_value_bigint_uint64 = nw(&fns.napi_get_value_bigint_uint64);
pub fn napi_get_value_bigint_uint64(env: n.napi_env, value: n.napi_value, result: [*c]u64, lossless: [*c]bool) n.napi_status {
    ensure(&_napi_get_value_bigint_uint64, &.{"napi_get_value_bigint_uint64"});
    return _napi_get_value_bigint_uint64.?(env, value, result, lossless);
}

var _napi_get_value_bigint_words = nw(&fns.napi_get_value_bigint_words);
pub fn napi_get_value_bigint_words(env: n.napi_env, value: n.napi_value, sign_bit: [*c]c_int, word_count: [*c]usize, words: [*c]u64) n.napi_status {
    ensure(&_napi_get_value_bigint_words, &.{"napi_get_value_bigint_words"});
    return _napi_get_value_bigint_words.?(env, value, sign_bit, word_count, words);
}

var _napi_get_value_bool = nw(&fns.napi_get_value_bool);
pub fn napi_get_value_bool(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status {
    ensure(&_napi_get_value_bool, &.{"napi_get_value_bool"});
    return _napi_get_value_bool.?(env, value, result);
}

var _napi_get_value_double = nw(&fns.napi_get_value_double);
pub fn napi_get_value_double(env: n.napi_env, value: n.napi_value, result: [*c]f64) n.napi_status {
    ensure(&_napi_get_value_double, &.{"napi_get_value_double"});
    return _napi_get_value_double.?(env, value, result);
}

var _napi_get_value_external = nw(&fns.napi_get_value_external);
pub fn napi_get_value_external(env: n.napi_env, value: n.napi_value, result: [*c]?*anyopaque) n.napi_status {
    ensure(&_napi_get_value_external, &.{"napi_get_value_external"});
    return _napi_get_value_external.?(env, value, result);
}

var _napi_get_value_int32 = nw(&fns.napi_get_value_int32);
pub fn napi_get_value_int32(env: n.napi_env, value: n.napi_value, result: [*c]i32) n.napi_status {
    ensure(&_napi_get_value_int32, &.{"napi_get_value_int32"});
    return _napi_get_value_int32.?(env, value, result);
}

var _napi_get_value_int64 = nw(&fns.napi_get_value_int64);
pub fn napi_get_value_int64(env: n.napi_env, value: n.napi_value, result: [*c]i64) n.napi_status {
    ensure(&_napi_get_value_int64, &.{"napi_get_value_int64"});
    return _napi_get_value_int64.?(env, value, result);
}

var _napi_get_value_string_latin1 = nw(&fns.napi_get_value_string_latin1);
pub fn napi_get_value_string_latin1(env: n.napi_env, value: n.napi_value, buf: [*c]u8, bufsize: usize, result: [*c]usize) n.napi_status {
    ensure(&_napi_get_value_string_latin1, &.{"napi_get_value_string_latin1"});
    return _napi_get_value_string_latin1.?(env, value, buf, bufsize, result);
}

var _napi_get_value_string_utf16 = nw(&fns.napi_get_value_string_utf16);
pub fn napi_get_value_string_utf16(env: n.napi_env, value: n.napi_value, buf: [*c]u16, bufsize: usize, result: [*c]usize) n.napi_status {
    ensure(&_napi_get_value_string_utf16, &.{"napi_get_value_string_utf16"});
    return _napi_get_value_string_utf16.?(env, value, buf, bufsize, result);
}

var _napi_get_value_string_utf8 = nw(&fns.napi_get_value_string_utf8);
pub fn napi_get_value_string_utf8(env: n.napi_env, value: n.napi_value, buf: [*c]u8, bufsize: usize, result: [*c]usize) n.napi_status {
    ensure(&_napi_get_value_string_utf8, &.{"napi_get_value_string_utf8"});
    return _napi_get_value_string_utf8.?(env, value, buf, bufsize, result);
}

var _napi_get_value_uint32 = nw(&fns.napi_get_value_uint32);
pub fn napi_get_value_uint32(env: n.napi_env, value: n.napi_value, result: [*c]u32) n.napi_status {
    ensure(&_napi_get_value_uint32, &.{"napi_get_value_uint32"});
    return _napi_get_value_uint32.?(env, value, result);
}

var _napi_get_version = nw(&fns.napi_get_version);
pub fn napi_get_version(env: n.node_api_basic_env, result: [*c]u32) n.napi_status {
    ensure(&_napi_get_version, &.{"napi_get_version"});
    return _napi_get_version.?(env, result);
}

var _napi_has_element = nw(&fns.napi_has_element);
pub fn napi_has_element(env: n.napi_env, object: n.napi_value, index: u32, result: [*c]bool) n.napi_status {
    ensure(&_napi_has_element, &.{"napi_has_element"});
    return _napi_has_element.?(env, object, index, result);
}

var _napi_has_named_property = nw(&fns.napi_has_named_property);
pub fn napi_has_named_property(env: n.napi_env, object: n.napi_value, utf8name: [*c]const u8, result: [*c]bool) n.napi_status {
    ensure(&_napi_has_named_property, &.{"napi_has_named_property"});
    return _napi_has_named_property.?(env, object, utf8name, result);
}

var _napi_has_own_property = nw(&fns.napi_has_own_property);
pub fn napi_has_own_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, result: [*c]bool) n.napi_status {
    ensure(&_napi_has_own_property, &.{"napi_has_own_property"});
    return _napi_has_own_property.?(env, object, key, result);
}

var _napi_has_property = nw(&fns.napi_has_property);
pub fn napi_has_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, result: [*c]bool) n.napi_status {
    ensure(&_napi_has_property, &.{"napi_has_property"});
    return _napi_has_property.?(env, object, key, result);
}

var _napi_instanceof = nw(&fns.napi_instanceof);
pub fn napi_instanceof(env: n.napi_env, object: n.napi_value, constructor: n.napi_value, result: [*c]bool) n.napi_status {
    ensure(&_napi_instanceof, &.{"napi_instanceof"});
    return _napi_instanceof.?(env, object, constructor, result);
}

var _napi_is_array = nw(&fns.napi_is_array);
pub fn napi_is_array(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status {
    ensure(&_napi_is_array, &.{"napi_is_array"});
    return _napi_is_array.?(env, value, result);
}

var _napi_is_arraybuffer = nw(&fns.napi_is_arraybuffer);
pub fn napi_is_arraybuffer(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status {
    ensure(&_napi_is_arraybuffer, &.{"napi_is_arraybuffer"});
    return _napi_is_arraybuffer.?(env, value, result);
}

var _napi_is_buffer = nw(&fns.napi_is_buffer);
pub fn napi_is_buffer(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status {
    ensure(&_napi_is_buffer, &.{"napi_is_buffer"});
    return _napi_is_buffer.?(env, value, result);
}

var _napi_is_dataview = nw(&fns.napi_is_dataview);
pub fn napi_is_dataview(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status {
    ensure(&_napi_is_dataview, &.{"napi_is_dataview"});
    return _napi_is_dataview.?(env, value, result);
}

var _napi_is_date = nw(&fns.napi_is_date);
pub fn napi_is_date(env: n.napi_env, value: n.napi_value, is_date: [*c]bool) n.napi_status {
    ensure(&_napi_is_date, &.{"napi_is_date"});
    return _napi_is_date.?(env, value, is_date);
}

var _napi_is_detached_arraybuffer = nw(&fns.napi_is_detached_arraybuffer);
pub fn napi_is_detached_arraybuffer(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status {
    ensure(&_napi_is_detached_arraybuffer, &.{"napi_is_detached_arraybuffer"});
    return _napi_is_detached_arraybuffer.?(env, value, result);
}

var _napi_is_error = nw(&fns.napi_is_error);
pub fn napi_is_error(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status {
    ensure(&_napi_is_error, &.{"napi_is_error"});
    return _napi_is_error.?(env, value, result);
}

var _napi_is_exception_pending = nw(&fns.napi_is_exception_pending);
pub fn napi_is_exception_pending(env: n.napi_env, result: [*c]bool) n.napi_status {
    ensure(&_napi_is_exception_pending, &.{"napi_is_exception_pending"});
    return _napi_is_exception_pending.?(env, result);
}

var _napi_is_promise = nw(&fns.napi_is_promise);
pub fn napi_is_promise(env: n.napi_env, value: n.napi_value, is_promise: [*c]bool) n.napi_status {
    ensure(&_napi_is_promise, &.{"napi_is_promise"});
    return _napi_is_promise.?(env, value, is_promise);
}

var _napi_is_typedarray = nw(&fns.napi_is_typedarray);
pub fn napi_is_typedarray(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status {
    ensure(&_napi_is_typedarray, &.{"napi_is_typedarray"});
    return _napi_is_typedarray.?(env, value, result);
}

var _napi_make_callback = nw(&fns.napi_make_callback);
pub fn napi_make_callback(env: n.napi_env, async_context: n.napi_async_context, recv: n.napi_value, func: n.napi_value, argc: usize, argv: [*c]const n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_make_callback, &.{"napi_make_callback"});
    return _napi_make_callback.?(env, async_context, recv, func, argc, argv, result);
}

var _napi_module_register = nw(&fns.napi_module_register);
pub fn napi_module_register(mod: [*c]n.napi_module) void {
    ensure(&_napi_module_register, &.{"napi_module_register"});
    return _napi_module_register.?(mod);
}

var _napi_new_instance = nw(&fns.napi_new_instance);
pub fn napi_new_instance(env: n.napi_env, constructor: n.napi_value, argc: usize, argv: [*c]const n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_new_instance, &.{"napi_new_instance"});
    return _napi_new_instance.?(env, constructor, argc, argv, result);
}

var _napi_object_freeze = nw(&fns.napi_object_freeze);
pub fn napi_object_freeze(env: n.napi_env, object: n.napi_value) n.napi_status {
    ensure(&_napi_object_freeze, &.{"napi_object_freeze"});
    return _napi_object_freeze.?(env, object);
}

var _napi_object_seal = nw(&fns.napi_object_seal);
pub fn napi_object_seal(env: n.napi_env, object: n.napi_value) n.napi_status {
    ensure(&_napi_object_seal, &.{"napi_object_seal"});
    return _napi_object_seal.?(env, object);
}

var _napi_open_callback_scope = nw(&fns.napi_open_callback_scope);
pub fn napi_open_callback_scope(env: n.napi_env, resource_object: n.napi_value, context: n.napi_async_context, result: [*c]n.napi_callback_scope) n.napi_status {
    ensure(&_napi_open_callback_scope, &.{"napi_open_callback_scope"});
    return _napi_open_callback_scope.?(env, resource_object, context, result);
}

var _napi_open_escapable_handle_scope = nw(&fns.napi_open_escapable_handle_scope);
pub fn napi_open_escapable_handle_scope(env: n.napi_env, result: [*c]n.napi_escapable_handle_scope) n.napi_status {
    ensure(&_napi_open_escapable_handle_scope, &.{"napi_open_escapable_handle_scope"});
    return _napi_open_escapable_handle_scope.?(env, result);
}

var _napi_open_handle_scope = nw(&fns.napi_open_handle_scope);
pub fn napi_open_handle_scope(env: n.napi_env, result: [*c]n.napi_handle_scope) n.napi_status {
    ensure(&_napi_open_handle_scope, &.{"napi_open_handle_scope"});
    return _napi_open_handle_scope.?(env, result);
}

var _napi_queue_async_work = nw(&fns.napi_queue_async_work);
pub fn napi_queue_async_work(env: n.node_api_basic_env, work: n.napi_async_work) n.napi_status {
    ensure(&_napi_queue_async_work, &.{"napi_queue_async_work"});
    return _napi_queue_async_work.?(env, work);
}

var _napi_ref_threadsafe_function = nw(&fns.napi_ref_threadsafe_function);
pub fn napi_ref_threadsafe_function(env: n.node_api_basic_env, func: n.napi_threadsafe_function) n.napi_status {
    ensure(&_napi_ref_threadsafe_function, &.{"napi_ref_threadsafe_function"});
    return _napi_ref_threadsafe_function.?(env, func);
}

var _napi_reference_ref = nw(&fns.napi_reference_ref);
pub fn napi_reference_ref(env: n.napi_env, ref: n.napi_ref, result: [*c]u32) n.napi_status {
    ensure(&_napi_reference_ref, &.{"napi_reference_ref"});
    return _napi_reference_ref.?(env, ref, result);
}

var _napi_reference_unref = nw(&fns.napi_reference_unref);
pub fn napi_reference_unref(env: n.napi_env, ref: n.napi_ref, result: [*c]u32) n.napi_status {
    ensure(&_napi_reference_unref, &.{"napi_reference_unref"});
    return _napi_reference_unref.?(env, ref, result);
}

var _napi_reject_deferred = nw(&fns.napi_reject_deferred);
pub fn napi_reject_deferred(env: n.napi_env, deferred: n.napi_deferred, rejection: n.napi_value) n.napi_status {
    ensure(&_napi_reject_deferred, &.{"napi_reject_deferred"});
    return _napi_reject_deferred.?(env, deferred, rejection);
}

var _napi_release_threadsafe_function = nw(&fns.napi_release_threadsafe_function);
pub fn napi_release_threadsafe_function(func: n.napi_threadsafe_function, mode: n.napi_threadsafe_function_release_mode) n.napi_status {
    ensure(&_napi_release_threadsafe_function, &.{"napi_release_threadsafe_function"});
    return _napi_release_threadsafe_function.?(func, mode);
}

var _napi_remove_async_cleanup_hook = nw(&fns.napi_remove_async_cleanup_hook);
pub fn napi_remove_async_cleanup_hook(remove_handle: n.napi_async_cleanup_hook_handle) n.napi_status {
    ensure(&_napi_remove_async_cleanup_hook, &.{"napi_remove_async_cleanup_hook"});
    return _napi_remove_async_cleanup_hook.?(remove_handle);
}

var _napi_remove_env_cleanup_hook = nw(&fns.napi_remove_env_cleanup_hook);
pub fn napi_remove_env_cleanup_hook(env: n.node_api_basic_env, fun: n.napi_cleanup_hook, arg: ?*anyopaque) n.napi_status {
    ensure(&_napi_remove_env_cleanup_hook, &.{"napi_remove_env_cleanup_hook"});
    return _napi_remove_env_cleanup_hook.?(env, fun, arg);
}

var _napi_remove_wrap = nw(&fns.napi_remove_wrap);
pub fn napi_remove_wrap(env: n.napi_env, js_object: n.napi_value, result: [*c]?*anyopaque) n.napi_status {
    ensure(&_napi_remove_wrap, &.{"napi_remove_wrap"});
    return _napi_remove_wrap.?(env, js_object, result);
}

var _napi_resolve_deferred = nw(&fns.napi_resolve_deferred);
pub fn napi_resolve_deferred(env: n.napi_env, deferred: n.napi_deferred, resolution: n.napi_value) n.napi_status {
    ensure(&_napi_resolve_deferred, &.{"napi_resolve_deferred"});
    return _napi_resolve_deferred.?(env, deferred, resolution);
}

var _napi_run_script = nw(&fns.napi_run_script);
pub fn napi_run_script(env: n.napi_env, script: n.napi_value, result: [*c]n.napi_value) n.napi_status {
    ensure(&_napi_run_script, &.{"napi_run_script"});
    return _napi_run_script.?(env, script, result);
}

var _napi_set_element = nw(&fns.napi_set_element);
pub fn napi_set_element(env: n.napi_env, object: n.napi_value, index: u32, value: n.napi_value) n.napi_status {
    ensure(&_napi_set_element, &.{"napi_set_element"});
    return _napi_set_element.?(env, object, index, value);
}

var _napi_set_instance_data = nw(&fns.napi_set_instance_data);
pub fn napi_set_instance_data(env: n.node_api_basic_env, data: ?*anyopaque, finalize_cb: n.napi_finalize, finalize_hint: ?*anyopaque) n.napi_status {
    ensure(&_napi_set_instance_data, &.{"napi_set_instance_data"});
    return _napi_set_instance_data.?(env, data, finalize_cb, finalize_hint);
}

var _napi_set_named_property = nw(&fns.napi_set_named_property);
pub fn napi_set_named_property(env: n.napi_env, object: n.napi_value, utf8name: [*c]const u8, value: n.napi_value) n.napi_status {
    ensure(&_napi_set_named_property, &.{"napi_set_named_property"});
    return _napi_set_named_property.?(env, object, utf8name, value);
}

var _napi_set_property = nw(&fns.napi_set_property);
pub fn napi_set_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, value: n.napi_value) n.napi_status {
    ensure(&_napi_set_property, &.{"napi_set_property"});
    return _napi_set_property.?(env, object, key, value);
}

var _napi_strict_equals = nw(&fns.napi_strict_equals);
pub fn napi_strict_equals(env: n.napi_env, lhs: n.napi_value, rhs: n.napi_value, result: [*c]bool) n.napi_status {
    ensure(&_napi_strict_equals, &.{"napi_strict_equals"});
    return _napi_strict_equals.?(env, lhs, rhs, result);
}

var _napi_throw = nw(&fns.napi_throw);
pub fn napi_throw(env: n.napi_env, @"error": n.napi_value) n.napi_status {
    ensure(&_napi_throw, &.{"napi_throw"});
    return _napi_throw.?(env, @"error");
}

var _napi_throw_error = nw(&fns.napi_throw_error);
pub fn napi_throw_error(env: n.napi_env, code: [*c]const u8, msg: [*c]const u8) n.napi_status {
    ensure(&_napi_throw_error, &.{"napi_throw_error"});
    return _napi_throw_error.?(env, code, msg);
}

var _napi_throw_range_error = nw(&fns.napi_throw_range_error);
pub fn napi_throw_range_error(env: n.napi_env, code: [*c]const u8, msg: [*c]const u8) n.napi_status {
    ensure(&_napi_throw_range_error, &.{"napi_throw_range_error"});
    return _napi_throw_range_error.?(env, code, msg);
}

var _napi_throw_type_error = nw(&fns.napi_throw_type_error);
pub fn napi_throw_type_error(env: n.napi_env, code: [*c]const u8, msg: [*c]const u8) n.napi_status {
    ensure(&_napi_throw_type_error, &.{"napi_throw_type_error"});
    return _napi_throw_type_error.?(env, code, msg);
}

var _napi_type_tag_object = nw(&fns.napi_type_tag_object);
pub fn napi_type_tag_object(env: n.napi_env, value: n.napi_value, type_tag: [*c]const n.napi_type_tag) n.napi_status {
    ensure(&_napi_type_tag_object, &.{"napi_type_tag_object"});
    return _napi_type_tag_object.?(env, value, type_tag);
}

var _napi_typeof = nw(&fns.napi_typeof);
pub fn napi_typeof(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_valuetype) n.napi_status {
    ensure(&_napi_typeof, &.{"napi_typeof"});
    return _napi_typeof.?(env, value, result);
}

var _napi_unref_threadsafe_function = nw(&fns.napi_unref_threadsafe_function);
pub fn napi_unref_threadsafe_function(env: n.node_api_basic_env, func: n.napi_threadsafe_function) n.napi_status {
    ensure(&_napi_unref_threadsafe_function, &.{"napi_unref_threadsafe_function"});
    return _napi_unref_threadsafe_function.?(env, func);
}

var _napi_unwrap = nw(&fns.napi_unwrap);
pub fn napi_unwrap(env: n.napi_env, js_object: n.napi_value, result: [*c]?*anyopaque) n.napi_status {
    ensure(&_napi_unwrap, &.{"napi_unwrap"});
    return _napi_unwrap.?(env, js_object, result);
}

var _napi_wrap = nw(&fns.napi_wrap);
pub fn napi_wrap(env: n.napi_env, js_object: n.napi_value, native_object: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_ref) n.napi_status {
    ensure(&_napi_wrap, &.{"napi_wrap"});
    return _napi_wrap.?(env, js_object, native_object, finalize_cb, finalize_hint, result);
}

// generated zlib shims

var _adler32 = nw(&fns.adler32);
pub fn adler32(adler: c_ulong, buf: [*c]const u8, len: c_uint) c_ulong {
    ensure(&_adler32, &.{ "adler32", "Cr_z_adler32" });
    return _adler32.?(adler, buf, len);
}

var _adler32_combine = nw(&fns.adler32_combine);
pub fn adler32_combine(adler1: c_ulong, adler2: c_ulong, len2: c_long) c_ulong {
    ensure(&_adler32_combine, &.{ "adler32_combine", "Cr_z_adler32_combine" });
    return _adler32_combine.?(adler1, adler2, len2);
}

var _adler32_z = nw(&fns.adler32_z);
pub fn adler32_z(adler: c_ulong, buf: [*c]const u8, len: usize) c_ulong {
    ensure(&_adler32_z, &.{ "adler32_z", "Cr_z_adler32_z" });
    return _adler32_z.?(adler, buf, len);
}

var _compress = nw(&fns.compress);
pub fn compress(dest: [*c]u8, destLen: [*c]c_ulong, source: [*c]const u8, sourceLen: c_ulong) c_int {
    ensure(&_compress, &.{ "compress", "Cr_z_compress" });
    return _compress.?(dest, destLen, source, sourceLen);
}

var _compress2 = nw(&fns.compress2);
pub fn compress2(dest: [*c]u8, destLen: [*c]c_ulong, source: [*c]const u8, sourceLen: c_ulong, level: c_int) c_int {
    ensure(&_compress2, &.{ "compress2", "Cr_z_compress2" });
    return _compress2.?(dest, destLen, source, sourceLen, level);
}

var _compressBound = nw(&fns.compressBound);
pub fn compressBound(sourceLen: c_ulong) c_ulong {
    ensure(&_compressBound, &.{ "compressBound", "Cr_z_compressBound" });
    return _compressBound.?(sourceLen);
}

var _crc32 = nw(&fns.crc32);
pub fn crc32(crc: c_ulong, buf: [*c]const u8, len: c_uint) c_ulong {
    ensure(&_crc32, &.{ "crc32", "Cr_z_crc32" });
    return _crc32.?(crc, buf, len);
}

var _crc32_combine = nw(&fns.crc32_combine);
pub fn crc32_combine(crc1: c_ulong, crc2: c_ulong, len2: c_long) c_ulong {
    ensure(&_crc32_combine, &.{ "crc32_combine", "Cr_z_crc32_combine" });
    return _crc32_combine.?(crc1, crc2, len2);
}

var _crc32_combine_gen = nw(&fns.crc32_combine_gen);
pub fn crc32_combine_gen(len2: c_long) c_ulong {
    ensure(&_crc32_combine_gen, &.{ "crc32_combine_gen", "Cr_z_crc32_combine_gen" });
    return _crc32_combine_gen.?(len2);
}

var _crc32_combine_op = nw(&fns.crc32_combine_op);
pub fn crc32_combine_op(crc1: c_ulong, crc2: c_ulong, op: c_ulong) c_ulong {
    ensure(&_crc32_combine_op, &.{ "crc32_combine_op", "Cr_z_crc32_combine_op" });
    return _crc32_combine_op.?(crc1, crc2, op);
}

var _crc32_z = nw(&fns.crc32_z);
pub fn crc32_z(crc: c_ulong, buf: [*c]const u8, len: usize) c_ulong {
    ensure(&_crc32_z, &.{ "crc32_z", "Cr_z_crc32_z" });
    return _crc32_z.?(crc, buf, len);
}

var _deflate = nw(&fns.deflate);
pub fn deflate(strm: n.z_streamp, flush: c_int) c_int {
    ensure(&_deflate, &.{ "deflate", "Cr_z_deflate" });
    return _deflate.?(strm, flush);
}

var _deflateBound = nw(&fns.deflateBound);
pub fn deflateBound(strm: n.z_streamp, sourceLen: c_ulong) c_ulong {
    ensure(&_deflateBound, &.{ "deflateBound", "Cr_z_deflateBound" });
    return _deflateBound.?(strm, sourceLen);
}

var _deflateCopy = nw(&fns.deflateCopy);
pub fn deflateCopy(dest: n.z_streamp, source: n.z_streamp) c_int {
    ensure(&_deflateCopy, &.{ "deflateCopy", "Cr_z_deflateCopy" });
    return _deflateCopy.?(dest, source);
}

var _deflateEnd = nw(&fns.deflateEnd);
pub fn deflateEnd(strm: n.z_streamp) c_int {
    ensure(&_deflateEnd, &.{ "deflateEnd", "Cr_z_deflateEnd" });
    return _deflateEnd.?(strm);
}

var _deflateGetDictionary = nw(&fns.deflateGetDictionary);
pub fn deflateGetDictionary(strm: n.z_streamp, dictionary: [*c]u8, dictLength: [*c]c_uint) c_int {
    ensure(&_deflateGetDictionary, &.{ "deflateGetDictionary", "Cr_z_deflateGetDictionary" });
    return _deflateGetDictionary.?(strm, dictionary, dictLength);
}

var _deflateInit2_ = nw(&fns.deflateInit2_);
pub fn deflateInit2_(strm: n.z_streamp, level: c_int, method: c_int, windowBits: c_int, memLevel: c_int, strategy: c_int, version: [*c]const u8, stream_size: c_int) c_int {
    ensure(&_deflateInit2_, &.{ "deflateInit2_", "Cr_z_deflateInit2_" });
    return _deflateInit2_.?(strm, level, method, windowBits, memLevel, strategy, version, stream_size);
}

var _deflateInit_ = nw(&fns.deflateInit_);
pub fn deflateInit_(strm: n.z_streamp, level: c_int, version: [*c]const u8, stream_size: c_int) c_int {
    ensure(&_deflateInit_, &.{ "deflateInit_", "Cr_z_deflateInit_" });
    return _deflateInit_.?(strm, level, version, stream_size);
}

var _deflateParams = nw(&fns.deflateParams);
pub fn deflateParams(strm: n.z_streamp, level: c_int, strategy: c_int) c_int {
    ensure(&_deflateParams, &.{ "deflateParams", "Cr_z_deflateParams" });
    return _deflateParams.?(strm, level, strategy);
}

var _deflatePending = nw(&fns.deflatePending);
pub fn deflatePending(strm: n.z_streamp, pending: [*c]c_uint, bits: [*c]c_int) c_int {
    ensure(&_deflatePending, &.{ "deflatePending", "Cr_z_deflatePending" });
    return _deflatePending.?(strm, pending, bits);
}

var _deflatePrime = nw(&fns.deflatePrime);
pub fn deflatePrime(strm: n.z_streamp, bits: c_int, value: c_int) c_int {
    ensure(&_deflatePrime, &.{ "deflatePrime", "Cr_z_deflatePrime" });
    return _deflatePrime.?(strm, bits, value);
}

var _deflateReset = nw(&fns.deflateReset);
pub fn deflateReset(strm: n.z_streamp) c_int {
    ensure(&_deflateReset, &.{ "deflateReset", "Cr_z_deflateReset" });
    return _deflateReset.?(strm);
}

var _deflateResetKeep = nw(&fns.deflateResetKeep);
pub fn deflateResetKeep(stream: n.z_streamp) c_int {
    ensure(&_deflateResetKeep, &.{ "deflateResetKeep", "Cr_z_deflateResetKeep" });
    return _deflateResetKeep.?(stream);
}

var _deflateSetDictionary = nw(&fns.deflateSetDictionary);
pub fn deflateSetDictionary(strm: n.z_streamp, dictionary: [*c]const u8, dictLength: c_uint) c_int {
    ensure(&_deflateSetDictionary, &.{ "deflateSetDictionary", "Cr_z_deflateSetDictionary" });
    return _deflateSetDictionary.?(strm, dictionary, dictLength);
}

var _deflateSetHeader = nw(&fns.deflateSetHeader);
pub fn deflateSetHeader(strm: n.z_streamp, head: n.gz_headerp) c_int {
    ensure(&_deflateSetHeader, &.{ "deflateSetHeader", "Cr_z_deflateSetHeader" });
    return _deflateSetHeader.?(strm, head);
}

var _deflateTune = nw(&fns.deflateTune);
pub fn deflateTune(strm: n.z_streamp, good_length: c_int, max_lazy: c_int, nice_length: c_int, max_chain: c_int) c_int {
    ensure(&_deflateTune, &.{ "deflateTune", "Cr_z_deflateTune" });
    return _deflateTune.?(strm, good_length, max_lazy, nice_length, max_chain);
}

var _get_crc_table = nw(&fns.get_crc_table);
pub fn get_crc_table() [*c]const c_uint {
    ensure(&_get_crc_table, &.{ "get_crc_table", "Cr_z_get_crc_table" });
    return _get_crc_table.?();
}

var _gzbuffer = nw(&fns.gzbuffer);
pub fn gzbuffer(file: n.gzFile, size: c_uint) c_int {
    ensure(&_gzbuffer, &.{ "gzbuffer", "Cr_z_gzbuffer" });
    return _gzbuffer.?(file, size);
}

var _gzclearerr = nw(&fns.gzclearerr);
pub fn gzclearerr(file: n.gzFile) void {
    ensure(&_gzclearerr, &.{ "gzclearerr", "Cr_z_gzclearerr" });
    return _gzclearerr.?(file);
}

var _gzclose = nw(&fns.gzclose);
pub fn gzclose(file: n.gzFile) c_int {
    ensure(&_gzclose, &.{ "gzclose", "Cr_z_gzclose" });
    return _gzclose.?(file);
}

var _gzclose_r = nw(&fns.gzclose_r);
pub fn gzclose_r(file: n.gzFile) c_int {
    ensure(&_gzclose_r, &.{ "gzclose_r", "Cr_z_gzclose_r" });
    return _gzclose_r.?(file);
}

var _gzclose_w = nw(&fns.gzclose_w);
pub fn gzclose_w(file: n.gzFile) c_int {
    ensure(&_gzclose_w, &.{ "gzclose_w", "Cr_z_gzclose_w" });
    return _gzclose_w.?(file);
}

var _gzdirect = nw(&fns.gzdirect);
pub fn gzdirect(file: n.gzFile) c_int {
    ensure(&_gzdirect, &.{ "gzdirect", "Cr_z_gzdirect" });
    return _gzdirect.?(file);
}

var _gzdopen = nw(&fns.gzdopen);
pub fn gzdopen(fd: c_int, mode: [*c]const u8) n.gzFile {
    ensure(&_gzdopen, &.{ "gzdopen", "Cr_z_gzdopen" });
    return _gzdopen.?(fd, mode);
}

var _gzeof = nw(&fns.gzeof);
pub fn gzeof(file: n.gzFile) c_int {
    ensure(&_gzeof, &.{ "gzeof", "Cr_z_gzeof" });
    return _gzeof.?(file);
}

var _gzerror = nw(&fns.gzerror);
pub fn gzerror(file: n.gzFile, errnum: [*c]c_int) [*c]const u8 {
    ensure(&_gzerror, &.{ "gzerror", "Cr_z_gzerror" });
    return _gzerror.?(file, errnum);
}

var _gzflush = nw(&fns.gzflush);
pub fn gzflush(file: n.gzFile, flush: c_int) c_int {
    ensure(&_gzflush, &.{ "gzflush", "Cr_z_gzflush" });
    return _gzflush.?(file, flush);
}

var _gzfread = nw(&fns.gzfread);
pub fn gzfread(buf: ?*anyopaque, size: usize, nitems: usize, file: n.gzFile) usize {
    ensure(&_gzfread, &.{ "gzfread", "Cr_z_gzfread" });
    return _gzfread.?(buf, size, nitems, file);
}

var _gzfwrite = nw(&fns.gzfwrite);
pub fn gzfwrite(buf: ?*const anyopaque, size: usize, nitems: usize, file: n.gzFile) usize {
    ensure(&_gzfwrite, &.{ "gzfwrite", "Cr_z_gzfwrite" });
    return _gzfwrite.?(buf, size, nitems, file);
}

var _gzgetc = nw(&fns.gzgetc);
pub fn gzgetc(file: n.gzFile) c_int {
    ensure(&_gzgetc, &.{ "gzgetc", "Cr_z_gzgetc" });
    return _gzgetc.?(file);
}

var _gzgetc_ = nw(&fns.gzgetc_);
pub fn gzgetc_(file: n.gzFile) c_int {
    ensure(&_gzgetc_, &.{ "gzgetc_", "Cr_z_gzgetc_" });
    return _gzgetc_.?(file);
}

var _gzgets = nw(&fns.gzgets);
pub fn gzgets(file: n.gzFile, buf: [*c]u8, len: c_int) [*c]u8 {
    ensure(&_gzgets, &.{ "gzgets", "Cr_z_gzgets" });
    return _gzgets.?(file, buf, len);
}

var _gzoffset = nw(&fns.gzoffset);
pub fn gzoffset(file: n.gzFile) c_long {
    ensure(&_gzoffset, &.{ "gzoffset", "Cr_z_gzoffset" });
    return _gzoffset.?(file);
}

var _gzopen = nw(&fns.gzopen);
pub fn gzopen(path: [*c]const u8, mode: [*c]const u8) n.gzFile {
    ensure(&_gzopen, &.{ "gzopen", "Cr_z_gzopen" });
    return _gzopen.?(path, mode);
}

var _gzprintf = nw(&fns.gzprintf);
pub fn gzprintf(file: n.gzFile, format: [*c]const u8, ...) c_int {
    ensure(&_gzprintf, &.{ "gzprintf", "Cr_z_gzprintf" });
    return _gzprintf.?(file, format);
}

var _gzputc = nw(&fns.gzputc);
pub fn gzputc(file: n.gzFile, c: c_int) c_int {
    ensure(&_gzputc, &.{ "gzputc", "Cr_z_gzputc" });
    return _gzputc.?(file, c);
}

var _gzputs = nw(&fns.gzputs);
pub fn gzputs(file: n.gzFile, s: [*c]const u8) c_int {
    ensure(&_gzputs, &.{ "gzputs", "Cr_z_gzputs" });
    return _gzputs.?(file, s);
}

var _gzread = nw(&fns.gzread);
pub fn gzread(file: n.gzFile, buf: ?*anyopaque, len: c_uint) c_int {
    ensure(&_gzread, &.{ "gzread", "Cr_z_gzread" });
    return _gzread.?(file, buf, len);
}

var _gzrewind = nw(&fns.gzrewind);
pub fn gzrewind(file: n.gzFile) c_int {
    ensure(&_gzrewind, &.{ "gzrewind", "Cr_z_gzrewind" });
    return _gzrewind.?(file);
}

var _gzseek = nw(&fns.gzseek);
pub fn gzseek(file: n.gzFile, offset: c_long, whence: c_int) c_long {
    ensure(&_gzseek, &.{ "gzseek", "Cr_z_gzseek" });
    return _gzseek.?(file, offset, whence);
}

var _gzsetparams = nw(&fns.gzsetparams);
pub fn gzsetparams(file: n.gzFile, level: c_int, strategy: c_int) c_int {
    ensure(&_gzsetparams, &.{ "gzsetparams", "Cr_z_gzsetparams" });
    return _gzsetparams.?(file, level, strategy);
}

var _gztell = nw(&fns.gztell);
pub fn gztell(file: n.gzFile) c_long {
    ensure(&_gztell, &.{ "gztell", "Cr_z_gztell" });
    return _gztell.?(file);
}

var _gzungetc = nw(&fns.gzungetc);
pub fn gzungetc(c: c_int, file: n.gzFile) c_int {
    ensure(&_gzungetc, &.{ "gzungetc", "Cr_z_gzungetc" });
    return _gzungetc.?(c, file);
}

var _gzwrite = nw(&fns.gzwrite);
pub fn gzwrite(file: n.gzFile, buf: ?*const anyopaque, len: c_uint) c_int {
    ensure(&_gzwrite, &.{ "gzwrite", "Cr_z_gzwrite" });
    return _gzwrite.?(file, buf, len);
}

var _inflate = nw(&fns.inflate);
pub fn inflate(strm: n.z_streamp, flush: c_int) c_int {
    ensure(&_inflate, &.{ "inflate", "Cr_z_inflate" });
    return _inflate.?(strm, flush);
}

var _inflateBack = nw(&fns.inflateBack);
pub fn inflateBack(strm: n.z_streamp, in: n.in_func, in_desc: ?*anyopaque, out: n.out_func, out_desc: ?*anyopaque) c_int {
    ensure(&_inflateBack, &.{ "inflateBack", "Cr_z_inflateBack" });
    return _inflateBack.?(strm, in, in_desc, out, out_desc);
}

var _inflateBackEnd = nw(&fns.inflateBackEnd);
pub fn inflateBackEnd(strm: n.z_streamp) c_int {
    ensure(&_inflateBackEnd, &.{ "inflateBackEnd", "Cr_z_inflateBackEnd" });
    return _inflateBackEnd.?(strm);
}

var _inflateBackInit_ = nw(&fns.inflateBackInit_);
pub fn inflateBackInit_(strm: n.z_streamp, windowBits: c_int, window: [*c]u8, version: [*c]const u8, stream_size: c_int) c_int {
    ensure(&_inflateBackInit_, &.{ "inflateBackInit_", "Cr_z_inflateBackInit_" });
    return _inflateBackInit_.?(strm, windowBits, window, version, stream_size);
}

var _inflateCodesUsed = nw(&fns.inflateCodesUsed);
pub fn inflateCodesUsed(stream: n.z_streamp) c_ulong {
    ensure(&_inflateCodesUsed, &.{ "inflateCodesUsed", "Cr_z_inflateCodesUsed" });
    return _inflateCodesUsed.?(stream);
}

var _inflateCopy = nw(&fns.inflateCopy);
pub fn inflateCopy(dest: n.z_streamp, source: n.z_streamp) c_int {
    ensure(&_inflateCopy, &.{ "inflateCopy", "Cr_z_inflateCopy" });
    return _inflateCopy.?(dest, source);
}

var _inflateEnd = nw(&fns.inflateEnd);
pub fn inflateEnd(strm: n.z_streamp) c_int {
    ensure(&_inflateEnd, &.{ "inflateEnd", "Cr_z_inflateEnd" });
    return _inflateEnd.?(strm);
}

var _inflateGetDictionary = nw(&fns.inflateGetDictionary);
pub fn inflateGetDictionary(strm: n.z_streamp, dictionary: [*c]u8, dictLength: [*c]c_uint) c_int {
    ensure(&_inflateGetDictionary, &.{ "inflateGetDictionary", "Cr_z_inflateGetDictionary" });
    return _inflateGetDictionary.?(strm, dictionary, dictLength);
}

var _inflateGetHeader = nw(&fns.inflateGetHeader);
pub fn inflateGetHeader(strm: n.z_streamp, head: n.gz_headerp) c_int {
    ensure(&_inflateGetHeader, &.{ "inflateGetHeader", "Cr_z_inflateGetHeader" });
    return _inflateGetHeader.?(strm, head);
}

var _inflateInit2_ = nw(&fns.inflateInit2_);
pub fn inflateInit2_(strm: n.z_streamp, windowBits: c_int, version: [*c]const u8, stream_size: c_int) c_int {
    ensure(&_inflateInit2_, &.{ "inflateInit2_", "Cr_z_inflateInit2_" });
    return _inflateInit2_.?(strm, windowBits, version, stream_size);
}

var _inflateInit_ = nw(&fns.inflateInit_);
pub fn inflateInit_(strm: n.z_streamp, version: [*c]const u8, stream_size: c_int) c_int {
    ensure(&_inflateInit_, &.{ "inflateInit_", "Cr_z_inflateInit_" });
    return _inflateInit_.?(strm, version, stream_size);
}

var _inflateMark = nw(&fns.inflateMark);
pub fn inflateMark(strm: n.z_streamp) c_long {
    ensure(&_inflateMark, &.{ "inflateMark", "Cr_z_inflateMark" });
    return _inflateMark.?(strm);
}

var _inflatePrime = nw(&fns.inflatePrime);
pub fn inflatePrime(strm: n.z_streamp, bits: c_int, value: c_int) c_int {
    ensure(&_inflatePrime, &.{ "inflatePrime", "Cr_z_inflatePrime" });
    return _inflatePrime.?(strm, bits, value);
}

var _inflateReset = nw(&fns.inflateReset);
pub fn inflateReset(strm: n.z_streamp) c_int {
    ensure(&_inflateReset, &.{ "inflateReset", "Cr_z_inflateReset" });
    return _inflateReset.?(strm);
}

var _inflateReset2 = nw(&fns.inflateReset2);
pub fn inflateReset2(strm: n.z_streamp, windowBits: c_int) c_int {
    ensure(&_inflateReset2, &.{ "inflateReset2", "Cr_z_inflateReset2" });
    return _inflateReset2.?(strm, windowBits);
}

var _inflateResetKeep = nw(&fns.inflateResetKeep);
pub fn inflateResetKeep(stream: n.z_streamp) c_int {
    ensure(&_inflateResetKeep, &.{ "inflateResetKeep", "Cr_z_inflateResetKeep" });
    return _inflateResetKeep.?(stream);
}

var _inflateSetDictionary = nw(&fns.inflateSetDictionary);
pub fn inflateSetDictionary(strm: n.z_streamp, dictionary: [*c]const u8, dictLength: c_uint) c_int {
    ensure(&_inflateSetDictionary, &.{ "inflateSetDictionary", "Cr_z_inflateSetDictionary" });
    return _inflateSetDictionary.?(strm, dictionary, dictLength);
}

var _inflateSync = nw(&fns.inflateSync);
pub fn inflateSync(strm: n.z_streamp) c_int {
    ensure(&_inflateSync, &.{ "inflateSync", "Cr_z_inflateSync" });
    return _inflateSync.?(strm);
}

var _inflateSyncPoint = nw(&fns.inflateSyncPoint);
pub fn inflateSyncPoint(stream: n.z_streamp) c_int {
    ensure(&_inflateSyncPoint, &.{ "inflateSyncPoint", "Cr_z_inflateSyncPoint" });
    return _inflateSyncPoint.?(stream);
}

var _inflateUndermine = nw(&fns.inflateUndermine);
pub fn inflateUndermine(stream: n.z_streamp, i: c_int) c_int {
    ensure(&_inflateUndermine, &.{ "inflateUndermine", "Cr_z_inflateUndermine" });
    return _inflateUndermine.?(stream, i);
}

var _inflateValidate = nw(&fns.inflateValidate);
pub fn inflateValidate(stream: n.z_streamp, i: c_int) c_int {
    ensure(&_inflateValidate, &.{ "inflateValidate", "Cr_z_inflateValidate" });
    return _inflateValidate.?(stream, i);
}

var _uncompress = nw(&fns.uncompress);
pub fn uncompress(dest: [*c]u8, destLen: [*c]c_ulong, source: [*c]const u8, sourceLen: c_ulong) c_int {
    ensure(&_uncompress, &.{ "uncompress", "Cr_z_uncompress" });
    return _uncompress.?(dest, destLen, source, sourceLen);
}

var _uncompress2 = nw(&fns.uncompress2);
pub fn uncompress2(dest: [*c]u8, destLen: [*c]c_ulong, source: [*c]const u8, sourceLen: [*c]c_ulong) c_int {
    ensure(&_uncompress2, &.{ "uncompress2", "Cr_z_uncompress2" });
    return _uncompress2.?(dest, destLen, source, sourceLen);
}

var _zError = nw(&fns.zError);
pub fn zError(i: c_int) [*c]const u8 {
    ensure(&_zError, &.{ "zError", "Cr_z_zError" });
    return _zError.?(i);
}

var _zlibCompileFlags = nw(&fns.zlibCompileFlags);
pub fn zlibCompileFlags() c_ulong {
    ensure(&_zlibCompileFlags, &.{ "zlibCompileFlags", "Cr_z_zlibCompileFlags" });
    return _zlibCompileFlags.?();
}

var _zlibVersion = nw(&fns.zlibVersion);
pub fn zlibVersion() [*c]const u8 {
    ensure(&_zlibVersion, &.{ "zlibVersion", "Cr_z_zlibVersion" });
    return _zlibVersion.?();
}
