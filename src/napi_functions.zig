const n = @import("napi.zig");

// napi

pub extern fn napi_acquire_threadsafe_function(func: n.napi_threadsafe_function) n.napi_status;
pub extern fn napi_add_async_cleanup_hook(env: n.node_api_basic_env, hook: n.napi_async_cleanup_hook, arg: ?*anyopaque, remove_handle: [*c]n.napi_async_cleanup_hook_handle) n.napi_status;
pub extern fn napi_add_env_cleanup_hook(env: n.node_api_basic_env, fun: n.napi_cleanup_hook, arg: ?*anyopaque) n.napi_status;
pub extern fn napi_add_finalizer(env: n.napi_env, js_object: n.napi_value, finalize_data: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_ref) n.napi_status;
pub extern fn napi_adjust_external_memory(env: n.node_api_basic_env, change_in_bytes: i64, adjusted_value: [*c]i64) n.napi_status;
pub extern fn napi_async_destroy(env: n.napi_env, async_context: n.napi_async_context) n.napi_status;
pub extern fn napi_async_init(env: n.napi_env, async_resource: n.napi_value, async_resource_name: n.napi_value, result: [*c]n.napi_async_context) n.napi_status;
pub extern fn napi_call_function(env: n.napi_env, recv: n.napi_value, func: n.napi_value, argc: usize, argv: [*c]const n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_call_threadsafe_function(func: n.napi_threadsafe_function, data: ?*anyopaque, is_blocking: n.napi_threadsafe_function_call_mode) n.napi_status;
pub extern fn napi_cancel_async_work(env: n.node_api_basic_env, work: n.napi_async_work) n.napi_status;
pub extern fn napi_check_object_type_tag(env: n.napi_env, value: n.napi_value, type_tag: [*c]const n.napi_type_tag, result: [*c]bool) n.napi_status;
pub extern fn napi_close_callback_scope(env: n.napi_env, scope: n.napi_callback_scope) n.napi_status;
pub extern fn napi_close_escapable_handle_scope(env: n.napi_env, scope: n.napi_escapable_handle_scope) n.napi_status;
pub extern fn napi_close_handle_scope(env: n.napi_env, scope: n.napi_handle_scope) n.napi_status;
pub extern fn napi_coerce_to_bool(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_coerce_to_number(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_coerce_to_object(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_coerce_to_string(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_array(env: n.napi_env, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_array_with_length(env: n.napi_env, length: usize, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_arraybuffer(env: n.napi_env, byte_length: usize, data: [*c]?*anyopaque, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_async_work(env: n.napi_env, async_resource: n.napi_value, async_resource_name: n.napi_value, execute: n.napi_async_execute_callback, complete: n.napi_async_complete_callback, data: ?*anyopaque, result: [*c]n.napi_async_work) n.napi_status;
pub extern fn napi_create_bigint_int64(env: n.napi_env, value: i64, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_bigint_uint64(env: n.napi_env, value: u64, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_bigint_words(env: n.napi_env, sign_bit: c_int, word_count: usize, words: [*c]const u64, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_buffer(env: n.napi_env, length: usize, data: [*c]?*anyopaque, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_buffer_copy(env: n.napi_env, length: usize, data: ?*const anyopaque, result_data: [*c]?*anyopaque, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_dataview(env: n.napi_env, length: usize, arraybuffer: n.napi_value, byte_offset: usize, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_date(env: n.napi_env, time: f64, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_double(env: n.napi_env, value: f64, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_error(env: n.napi_env, code: n.napi_value, msg: n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_external(env: n.napi_env, data: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_external_arraybuffer(env: n.napi_env, external_data: ?*anyopaque, byte_length: usize, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_external_buffer(env: n.napi_env, length: usize, data: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_function(env: n.napi_env, utf8name: [*c]const u8, length: usize, cb: n.napi_callback, data: ?*anyopaque, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_int32(env: n.napi_env, value: i32, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_int64(env: n.napi_env, value: i64, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_object(env: n.napi_env, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_promise(env: n.napi_env, deferred: [*c]n.napi_deferred, promise: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_range_error(env: n.napi_env, code: n.napi_value, msg: n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_reference(env: n.napi_env, value: n.napi_value, initial_refcount: u32, result: [*c]n.napi_ref) n.napi_status;
pub extern fn napi_create_string_latin1(env: n.napi_env, str: [*c]const u8, length: usize, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_string_utf16(env: n.napi_env, str: [*c]const u16, length: usize, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_string_utf8(env: n.napi_env, str: [*c]const u8, length: usize, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_symbol(env: n.napi_env, description: n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_threadsafe_function(env: n.napi_env, func: n.napi_value, async_resource: n.napi_value, async_resource_name: n.napi_value, max_queue_size: usize, initial_thread_count: usize, thread_finalize_data: ?*anyopaque, thread_finalize_cb: n.napi_finalize, context: ?*anyopaque, call_js_cb: n.napi_threadsafe_function_call_js, result: [*c]n.napi_threadsafe_function) n.napi_status;
pub extern fn napi_create_type_error(env: n.napi_env, code: n.napi_value, msg: n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_typedarray(env: n.napi_env, @"type": n.napi_typedarray_type, length: usize, arraybuffer: n.napi_value, byte_offset: usize, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_create_uint32(env: n.napi_env, value: u32, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_define_class(env: n.napi_env, utf8name: [*c]const u8, length: usize, constructor: n.napi_callback, data: ?*anyopaque, property_count: usize, properties: [*c]const n.napi_property_descriptor, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_define_properties(env: n.napi_env, object: n.napi_value, property_count: usize, properties: [*c]const n.napi_property_descriptor) n.napi_status;
pub extern fn napi_delete_async_work(env: n.napi_env, work: n.napi_async_work) n.napi_status;
pub extern fn napi_delete_element(env: n.napi_env, object: n.napi_value, index: u32, result: [*c]bool) n.napi_status;
pub extern fn napi_delete_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, result: [*c]bool) n.napi_status;
pub extern fn napi_delete_reference(env: n.napi_env, ref: n.napi_ref) n.napi_status;
pub extern fn napi_detach_arraybuffer(env: n.napi_env, arraybuffer: n.napi_value) n.napi_status;
pub extern fn napi_escape_handle(env: n.napi_env, scope: n.napi_escapable_handle_scope, escapee: n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_fatal_error(location: [*c]const u8, location_len: usize, message: [*c]const u8, message_len: usize) noreturn;
pub extern fn napi_fatal_exception(env: n.napi_env, err: n.napi_value) n.napi_status;
pub extern fn napi_get_all_property_names(env: n.napi_env, object: n.napi_value, key_mode: n.napi_key_collection_mode, key_filter: n.napi_key_filter, key_conversion: n.napi_key_conversion, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_get_and_clear_last_exception(env: n.napi_env, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_get_array_length(env: n.napi_env, value: n.napi_value, result: [*c]u32) n.napi_status;
pub extern fn napi_get_arraybuffer_info(env: n.napi_env, arraybuffer: n.napi_value, data: [*c]?*anyopaque, byte_length: [*c]usize) n.napi_status;
pub extern fn napi_get_boolean(env: n.napi_env, value: bool, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_get_buffer_info(env: n.napi_env, value: n.napi_value, data: [*c]?*anyopaque, length: [*c]usize) n.napi_status;
pub extern fn napi_get_cb_info(env: n.napi_env, cbinfo: n.napi_callback_info, argc: [*c]usize, argv: [*c]n.napi_value, this_arg: [*c]n.napi_value, data: [*c]?*anyopaque) n.napi_status;
pub extern fn napi_get_dataview_info(env: n.napi_env, dataview: n.napi_value, bytelength: [*c]usize, data: [*c]?*anyopaque, arraybuffer: [*c]n.napi_value, byte_offset: [*c]usize) n.napi_status;
pub extern fn napi_get_date_value(env: n.napi_env, value: n.napi_value, result: [*c]f64) n.napi_status;
pub extern fn napi_get_element(env: n.napi_env, object: n.napi_value, index: u32, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_get_global(env: n.napi_env, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_get_instance_data(env: n.node_api_basic_env, data: [*c]?*anyopaque) n.napi_status;
pub extern fn napi_get_last_error_info(env: n.node_api_basic_env, result: [*c][*c]const n.napi_extended_error_info) n.napi_status;
pub extern fn napi_get_named_property(env: n.napi_env, object: n.napi_value, utf8name: [*c]const u8, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_get_new_target(env: n.napi_env, cbinfo: n.napi_callback_info, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_get_node_version(env: n.node_api_basic_env, version: [*c][*c]const n.napi_node_version) n.napi_status;
pub extern fn napi_get_null(env: n.napi_env, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_get_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_get_property_names(env: n.napi_env, object: n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_get_prototype(env: n.napi_env, object: n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_get_reference_value(env: n.napi_env, ref: n.napi_ref, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_get_threadsafe_function_context(func: n.napi_threadsafe_function, result: [*c]?*anyopaque) n.napi_status;
pub extern fn napi_get_typedarray_info(env: n.napi_env, typedarray: n.napi_value, @"type": [*c]n.napi_typedarray_type, length: [*c]usize, data: [*c]?*anyopaque, arraybuffer: [*c]n.napi_value, byte_offset: [*c]usize) n.napi_status;
pub extern fn napi_get_undefined(env: n.napi_env, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_get_uv_event_loop(env: n.node_api_basic_env, loop: [*c]?*n.struct_uv_loop_s) n.napi_status;
pub extern fn napi_get_value_bigint_int64(env: n.napi_env, value: n.napi_value, result: [*c]i64, lossless: [*c]bool) n.napi_status;
pub extern fn napi_get_value_bigint_uint64(env: n.napi_env, value: n.napi_value, result: [*c]u64, lossless: [*c]bool) n.napi_status;
pub extern fn napi_get_value_bigint_words(env: n.napi_env, value: n.napi_value, sign_bit: [*c]c_int, word_count: [*c]usize, words: [*c]u64) n.napi_status;
pub extern fn napi_get_value_bool(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
pub extern fn napi_get_value_double(env: n.napi_env, value: n.napi_value, result: [*c]f64) n.napi_status;
pub extern fn napi_get_value_external(env: n.napi_env, value: n.napi_value, result: [*c]?*anyopaque) n.napi_status;
pub extern fn napi_get_value_int32(env: n.napi_env, value: n.napi_value, result: [*c]i32) n.napi_status;
pub extern fn napi_get_value_int64(env: n.napi_env, value: n.napi_value, result: [*c]i64) n.napi_status;
pub extern fn napi_get_value_string_latin1(env: n.napi_env, value: n.napi_value, buf: [*c]u8, bufsize: usize, result: [*c]usize) n.napi_status;
pub extern fn napi_get_value_string_utf16(env: n.napi_env, value: n.napi_value, buf: [*c]u16, bufsize: usize, result: [*c]usize) n.napi_status;
pub extern fn napi_get_value_string_utf8(env: n.napi_env, value: n.napi_value, buf: [*c]u8, bufsize: usize, result: [*c]usize) n.napi_status;
pub extern fn napi_get_value_uint32(env: n.napi_env, value: n.napi_value, result: [*c]u32) n.napi_status;
pub extern fn napi_get_version(env: n.node_api_basic_env, result: [*c]u32) n.napi_status;
pub extern fn napi_has_element(env: n.napi_env, object: n.napi_value, index: u32, result: [*c]bool) n.napi_status;
pub extern fn napi_has_named_property(env: n.napi_env, object: n.napi_value, utf8name: [*c]const u8, result: [*c]bool) n.napi_status;
pub extern fn napi_has_own_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, result: [*c]bool) n.napi_status;
pub extern fn napi_has_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, result: [*c]bool) n.napi_status;
pub extern fn napi_instanceof(env: n.napi_env, object: n.napi_value, constructor: n.napi_value, result: [*c]bool) n.napi_status;
pub extern fn napi_is_array(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
pub extern fn napi_is_arraybuffer(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
pub extern fn napi_is_buffer(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
pub extern fn napi_is_dataview(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
pub extern fn napi_is_date(env: n.napi_env, value: n.napi_value, is_date: [*c]bool) n.napi_status;
pub extern fn napi_is_detached_arraybuffer(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
pub extern fn napi_is_error(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
pub extern fn napi_is_exception_pending(env: n.napi_env, result: [*c]bool) n.napi_status;
pub extern fn napi_is_promise(env: n.napi_env, value: n.napi_value, is_promise: [*c]bool) n.napi_status;
pub extern fn napi_is_typedarray(env: n.napi_env, value: n.napi_value, result: [*c]bool) n.napi_status;
pub extern fn napi_make_callback(env: n.napi_env, async_context: n.napi_async_context, recv: n.napi_value, func: n.napi_value, argc: usize, argv: [*c]const n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_module_register(mod: [*c]n.napi_module) void;
pub extern fn napi_new_instance(env: n.napi_env, constructor: n.napi_value, argc: usize, argv: [*c]const n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_object_freeze(env: n.napi_env, object: n.napi_value) n.napi_status;
pub extern fn napi_object_seal(env: n.napi_env, object: n.napi_value) n.napi_status;
pub extern fn napi_open_callback_scope(env: n.napi_env, resource_object: n.napi_value, context: n.napi_async_context, result: [*c]n.napi_callback_scope) n.napi_status;
pub extern fn napi_open_escapable_handle_scope(env: n.napi_env, result: [*c]n.napi_escapable_handle_scope) n.napi_status;
pub extern fn napi_open_handle_scope(env: n.napi_env, result: [*c]n.napi_handle_scope) n.napi_status;
pub extern fn napi_queue_async_work(env: n.node_api_basic_env, work: n.napi_async_work) n.napi_status;
pub extern fn napi_ref_threadsafe_function(env: n.node_api_basic_env, func: n.napi_threadsafe_function) n.napi_status;
pub extern fn napi_reference_ref(env: n.napi_env, ref: n.napi_ref, result: [*c]u32) n.napi_status;
pub extern fn napi_reference_unref(env: n.napi_env, ref: n.napi_ref, result: [*c]u32) n.napi_status;
pub extern fn napi_reject_deferred(env: n.napi_env, deferred: n.napi_deferred, rejection: n.napi_value) n.napi_status;
pub extern fn napi_release_threadsafe_function(func: n.napi_threadsafe_function, mode: n.napi_threadsafe_function_release_mode) n.napi_status;
pub extern fn napi_remove_async_cleanup_hook(remove_handle: n.napi_async_cleanup_hook_handle) n.napi_status;
pub extern fn napi_remove_env_cleanup_hook(env: n.node_api_basic_env, fun: n.napi_cleanup_hook, arg: ?*anyopaque) n.napi_status;
pub extern fn napi_remove_wrap(env: n.napi_env, js_object: n.napi_value, result: [*c]?*anyopaque) n.napi_status;
pub extern fn napi_resolve_deferred(env: n.napi_env, deferred: n.napi_deferred, resolution: n.napi_value) n.napi_status;
pub extern fn napi_run_script(env: n.napi_env, script: n.napi_value, result: [*c]n.napi_value) n.napi_status;
pub extern fn napi_set_element(env: n.napi_env, object: n.napi_value, index: u32, value: n.napi_value) n.napi_status;
pub extern fn napi_set_instance_data(env: n.node_api_basic_env, data: ?*anyopaque, finalize_cb: n.napi_finalize, finalize_hint: ?*anyopaque) n.napi_status;
pub extern fn napi_set_named_property(env: n.napi_env, object: n.napi_value, utf8name: [*c]const u8, value: n.napi_value) n.napi_status;
pub extern fn napi_set_property(env: n.napi_env, object: n.napi_value, key: n.napi_value, value: n.napi_value) n.napi_status;
pub extern fn napi_strict_equals(env: n.napi_env, lhs: n.napi_value, rhs: n.napi_value, result: [*c]bool) n.napi_status;
pub extern fn napi_throw(env: n.napi_env, @"error": n.napi_value) n.napi_status;
pub extern fn napi_throw_error(env: n.napi_env, code: [*c]const u8, msg: [*c]const u8) n.napi_status;
pub extern fn napi_throw_range_error(env: n.napi_env, code: [*c]const u8, msg: [*c]const u8) n.napi_status;
pub extern fn napi_throw_type_error(env: n.napi_env, code: [*c]const u8, msg: [*c]const u8) n.napi_status;
pub extern fn napi_type_tag_object(env: n.napi_env, value: n.napi_value, type_tag: [*c]const n.napi_type_tag) n.napi_status;
pub extern fn napi_typeof(env: n.napi_env, value: n.napi_value, result: [*c]n.napi_valuetype) n.napi_status;
pub extern fn napi_unref_threadsafe_function(env: n.node_api_basic_env, func: n.napi_threadsafe_function) n.napi_status;
pub extern fn napi_unwrap(env: n.napi_env, js_object: n.napi_value, result: [*c]?*anyopaque) n.napi_status;
pub extern fn napi_wrap(env: n.napi_env, js_object: n.napi_value, native_object: ?*anyopaque, finalize_cb: n.node_api_basic_finalize, finalize_hint: ?*anyopaque, result: [*c]n.napi_ref) n.napi_status;

// zlib

pub extern fn adler32(adler: c_ulong, buf: [*c]const u8, len: c_uint) c_ulong;
pub extern fn adler32_combine(c_ulong, c_ulong, c_long) c_ulong;
pub extern fn adler32_z(adler: c_ulong, buf: [*c]const u8, len: usize) c_ulong;
pub extern fn compress(dest: [*c]u8, destLen: [*c]c_ulong, source: [*c]const u8, sourceLen: c_ulong) c_int;
pub extern fn compress2(dest: [*c]u8, destLen: [*c]c_ulong, source: [*c]const u8, sourceLen: c_ulong, level: c_int) c_int;
pub extern fn compressBound(sourceLen: c_ulong) c_ulong;
pub extern fn crc32(crc: c_ulong, buf: [*c]const u8, len: c_uint) c_ulong;
pub extern fn crc32_combine(c_ulong, c_ulong, c_long) c_ulong;
pub extern fn crc32_combine_gen(c_long) c_ulong;
pub extern fn crc32_combine_op(crc1: c_ulong, crc2: c_ulong, op: c_ulong) c_ulong;
pub extern fn crc32_z(crc: c_ulong, buf: [*c]const u8, len: usize) c_ulong;
pub extern fn deflate(strm: n.z_streamp, flush: c_int) c_int;
pub extern fn deflateBound(strm: n.z_streamp, sourceLen: c_ulong) c_ulong;
pub extern fn deflateCopy(dest: n.z_streamp, source: n.z_streamp) c_int;
pub extern fn deflateEnd(strm: n.z_streamp) c_int;
pub extern fn deflateGetDictionary(strm: n.z_streamp, dictionary: [*c]u8, dictLength: [*c]c_uint) c_int;
pub extern fn deflateInit2_(strm: n.z_streamp, level: c_int, method: c_int, windowBits: c_int, memLevel: c_int, strategy: c_int, version: [*c]const u8, stream_size: c_int) c_int;
pub extern fn deflateInit_(strm: n.z_streamp, level: c_int, version: [*c]const u8, stream_size: c_int) c_int;
pub extern fn deflateParams(strm: n.z_streamp, level: c_int, strategy: c_int) c_int;
pub extern fn deflatePending(strm: n.z_streamp, pending: [*c]c_uint, bits: [*c]c_int) c_int;
pub extern fn deflatePrime(strm: n.z_streamp, bits: c_int, value: c_int) c_int;
pub extern fn deflateReset(strm: n.z_streamp) c_int;
pub extern fn deflateResetKeep(n.z_streamp) c_int;
pub extern fn deflateSetDictionary(strm: n.z_streamp, dictionary: [*c]const u8, dictLength: c_uint) c_int;
pub extern fn deflateSetHeader(strm: n.z_streamp, head: n.gz_headerp) c_int;
pub extern fn deflateTune(strm: n.z_streamp, good_length: c_int, max_lazy: c_int, nice_length: c_int, max_chain: c_int) c_int;
pub extern fn get_crc_table() [*c]const c_uint;
pub extern fn gzbuffer(file: n.gzFile, size: c_uint) c_int;
pub extern fn gzclearerr(file: n.gzFile) void;
pub extern fn gzclose(file: n.gzFile) c_int;
pub extern fn gzclose_r(file: n.gzFile) c_int;
pub extern fn gzclose_w(file: n.gzFile) c_int;
pub extern fn gzdirect(file: n.gzFile) c_int;
pub extern fn gzdopen(fd: c_int, mode: [*c]const u8) n.gzFile;
pub extern fn gzeof(file: n.gzFile) c_int;
pub extern fn gzerror(file: n.gzFile, errnum: [*c]c_int) [*c]const u8;
pub extern fn gzflush(file: n.gzFile, flush: c_int) c_int;
pub extern fn gzfread(buf: ?*anyopaque, size: usize, nitems: usize, file: n.gzFile) usize;
pub extern fn gzfwrite(buf: ?*const anyopaque, size: usize, nitems: usize, file: n.gzFile) usize;
pub extern fn gzgetc(file: n.gzFile) c_int;
pub extern fn gzgetc_(file: n.gzFile) c_int;
pub extern fn gzgets(file: n.gzFile, buf: [*c]u8, len: c_int) [*c]u8;
pub extern fn gzoffset(n.gzFile) c_long;
pub extern fn gzopen([*c]const u8, [*c]const u8) n.gzFile;
pub extern fn gzprintf(file: n.gzFile, format: [*c]const u8, ...) c_int;
pub extern fn gzputc(file: n.gzFile, c: c_int) c_int;
pub extern fn gzputs(file: n.gzFile, s: [*c]const u8) c_int;
pub extern fn gzread(file: n.gzFile, buf: ?*anyopaque, len: c_uint) c_int;
pub extern fn gzrewind(file: n.gzFile) c_int;
pub extern fn gzseek(n.gzFile, c_long, c_int) c_long;
pub extern fn gzsetparams(file: n.gzFile, level: c_int, strategy: c_int) c_int;
pub extern fn gztell(n.gzFile) c_long;
pub extern fn gzungetc(c: c_int, file: n.gzFile) c_int;
pub extern fn gzwrite(file: n.gzFile, buf: ?*const anyopaque, len: c_uint) c_int;
pub extern fn inflate(strm: n.z_streamp, flush: c_int) c_int;
pub extern fn inflateBack(strm: n.z_streamp, in: n.in_func, in_desc: ?*anyopaque, out: n.out_func, out_desc: ?*anyopaque) c_int;
pub extern fn inflateBackEnd(strm: n.z_streamp) c_int;
pub extern fn inflateBackInit_(strm: n.z_streamp, windowBits: c_int, window: [*c]u8, version: [*c]const u8, stream_size: c_int) c_int;
pub extern fn inflateCodesUsed(n.z_streamp) c_ulong;
pub extern fn inflateCopy(dest: n.z_streamp, source: n.z_streamp) c_int;
pub extern fn inflateEnd(strm: n.z_streamp) c_int;
pub extern fn inflateGetDictionary(strm: n.z_streamp, dictionary: [*c]u8, dictLength: [*c]c_uint) c_int;
pub extern fn inflateGetHeader(strm: n.z_streamp, head: n.gz_headerp) c_int;
pub extern fn inflateInit2_(strm: n.z_streamp, windowBits: c_int, version: [*c]const u8, stream_size: c_int) c_int;
pub extern fn inflateInit_(strm: n.z_streamp, version: [*c]const u8, stream_size: c_int) c_int;
pub extern fn inflateMark(strm: n.z_streamp) c_long;
pub extern fn inflatePrime(strm: n.z_streamp, bits: c_int, value: c_int) c_int;
pub extern fn inflateReset(strm: n.z_streamp) c_int;
pub extern fn inflateReset2(strm: n.z_streamp, windowBits: c_int) c_int;
pub extern fn inflateResetKeep(n.z_streamp) c_int;
pub extern fn inflateSetDictionary(strm: n.z_streamp, dictionary: [*c]const u8, dictLength: c_uint) c_int;
pub extern fn inflateSync(strm: n.z_streamp) c_int;
pub extern fn inflateSyncPoint(n.z_streamp) c_int;
pub extern fn inflateUndermine(n.z_streamp, c_int) c_int;
pub extern fn inflateValidate(n.z_streamp, c_int) c_int;
pub extern fn uncompress(dest: [*c]u8, destLen: [*c]c_ulong, source: [*c]const u8, sourceLen: c_ulong) c_int;
pub extern fn uncompress2(dest: [*c]u8, destLen: [*c]c_ulong, source: [*c]const u8, sourceLen: [*c]c_ulong) c_int;
pub extern fn zError(c_int) [*c]const u8;
pub extern fn zlibCompileFlags() c_ulong;
pub extern fn zlibVersion() [*c]const u8;
