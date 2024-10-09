const zeroes = @import("std").mem.zeroes;

pub const napi_env = ?*opaque {};
pub const node_api_basic_env = ?*opaque {};
pub const napi_value = ?*opaque {};
pub const napi_ref = ?*opaque {};
pub const napi_handle_scope = ?*opaque {};
pub const napi_escapable_handle_scope = ?*opaque {};
pub const napi_callback_info = ?*opaque {};
pub const node_api_nogc_finalize = napi_finalize;
pub const node_api_basic_finalize = node_api_nogc_finalize;
pub const napi_deferred = ?*opaque {};
pub const napi_callback_scope = ?*opaque {};
pub const napi_async_context = ?*opaque {};
pub const napi_async_work = ?*opaque {};
pub const napi_threadsafe_function = ?*opaque {};
pub const napi_async_cleanup_hook_handle = ?*opaque {};
pub const struct_uv_loop_s = opaque {};

pub const napi_callback = ?*const fn (napi_env, napi_callback_info) callconv(.C) napi_value;
pub const napi_finalize = ?*const fn (napi_env, ?*anyopaque, ?*anyopaque) callconv(.C) void;
pub const napi_cleanup_hook = ?*const fn (?*anyopaque) callconv(.C) void;
pub const napi_async_execute_callback = ?*const fn (napi_env, ?*anyopaque) callconv(.C) void;
pub const napi_async_complete_callback = ?*const fn (napi_env, napi_status, ?*anyopaque) callconv(.C) void;
pub const napi_threadsafe_function_call_js = ?*const fn (napi_env, napi_value, ?*anyopaque, ?*anyopaque) callconv(.C) void;
pub const napi_async_cleanup_hook = ?*const fn (napi_async_cleanup_hook_handle, ?*anyopaque) callconv(.C) void;
pub const napi_addon_register_func = ?*const fn (napi_env, napi_value) callconv(.C) napi_value;
pub const node_api_addon_get_api_version_func = ?*const fn () callconv(.C) i32;

pub const napi_status = enum(c_uint) {
    ok = 0,
    invalid_arg = 1,
    object_expected = 2,
    string_expected = 3,
    name_expected = 4,
    function_expected = 5,
    number_expected = 6,
    boolean_expected = 7,
    array_expected = 8,
    generic_failure = 9,
    pending_exception = 10,
    cancelled = 11,
    escape_called_twice = 12,
    handle_scope_mismatch = 13,
    callback_scope_mismatch = 14,
    queue_full = 15,
    closing = 16,
    bigint_expected = 17,
    date_expected = 18,
    arraybuffer_expected = 19,
    detachable_arraybuffer_expected = 20,
    would_deadlock = 21,
    no_external_buffers_allowed = 22,
    cannot_run_js = 23,
};

pub const napi_property_attributes = enum(c_uint) {
    default = 0,
    writable = 1,
    enumerable = 2,
    configurable = 4,
    static = 1024,
    default_method = 5,
    default_jsproperty = 7,
};

pub const napi_valuetype = enum(c_uint) {
    undefined = 0,
    null = 1,
    boolean = 2,
    number = 3,
    string = 4,
    symbol = 5,
    object = 6,
    function = 7,
    external = 8,
    bigint = 9,
};

pub const napi_typedarray_type = enum(c_uint) {
    int8_array = 0,
    uint8_array = 1,
    uint8_clamped_array = 2,
    int16_array = 3,
    uint16_array = 4,
    int32_array = 5,
    uint32_array = 6,
    float32_array = 7,
    float64_array = 8,
    bigint64_array = 9,
    biguint64_array = 10,
};

pub const napi_key_collection_mode = enum(c_uint) {
    include_prototypes = 0,
    own_only = 1,
};

pub const napi_key_filter = enum(c_uint) {
    all_properties = 0,
    only_writable = 1,
    only_enumerable = 2,
    only_configurable = 4,
    skip_strings = 8,
    skip_symbols = 16,
    _,
};

pub const napi_key_conversion = enum(c_uint) {
    keep_numbers = 0,
    numbers_to_strings = 1,
};

pub const napi_property_descriptor = extern struct {
    utf8name: [*c]const u8 = zeroes([*c]const u8),
    name: napi_value = zeroes(napi_value),
    method: napi_callback = zeroes(napi_callback),
    getter: napi_callback = zeroes(napi_callback),
    setter: napi_callback = zeroes(napi_callback),
    value: napi_value = zeroes(napi_value),
    attributes: napi_property_attributes = zeroes(napi_property_attributes),
    data: ?*anyopaque = zeroes(?*anyopaque),
};

pub const napi_extended_error_info = extern struct {
    error_message: [*c]const u8 = zeroes([*c]const u8),
    engine_reserved: ?*anyopaque = zeroes(?*anyopaque),
    engine_error_code: u32 = zeroes(u32),
    error_code: napi_status = zeroes(napi_status),
};

pub const napi_type_tag = extern struct {
    lower: u64 = zeroes(u64),
    upper: u64 = zeroes(u64),
};

pub const napi_threadsafe_function_release_mode = enum(c_uint) {
    napi_tsfn_release = 0,
    napi_tsfn_abort = 1,
};

pub const napi_threadsafe_function_call_mode = enum(c_uint) {
    napi_tsfn_nonblocking = 0,
    napi_tsfn_blocking = 1,
};

pub const napi_node_version = extern struct {
    major: u32 = zeroes(u32),
    minor: u32 = zeroes(u32),
    patch: u32 = zeroes(u32),
    release: [*c]const u8 = zeroes([*c]const u8),
};

pub const napi_module = extern struct {
    nm_version: c_uint = zeroes(c_uint),
    nm_flags: c_uint = zeroes(c_uint),
    nm_filename: [*c]const u8 = zeroes([*c]const u8),
    nm_register_func: napi_addon_register_func = zeroes(napi_addon_register_func),
    nm_modname: [*c]const u8 = zeroes([*c]const u8),
    nm_priv: ?*anyopaque = zeroes(?*anyopaque),
    reserved: [4]?*anyopaque = zeroes([4]?*anyopaque),
};

//

pub const in_func = ?*const fn (?*anyopaque, [*c][*c]u8) callconv(.C) c_uint;
pub const out_func = ?*const fn (?*anyopaque, [*c]u8, c_uint) callconv(.C) c_int;
pub const alloc_func = ?*const fn (?*anyopaque, c_uint, c_uint) callconv(.C) ?*anyopaque;
pub const free_func = ?*const fn (?*anyopaque, ?*anyopaque) callconv(.C) void;
pub const internal_state = opaque {};

pub const z_stream = extern struct {
    next_in: [*c]u8 = zeroes([*c]u8),
    avail_in: c_uint = zeroes(c_uint),
    total_in: c_ulong = zeroes(c_ulong),
    next_out: [*c]u8 = zeroes([*c]u8),
    avail_out: c_uint = zeroes(c_uint),
    total_out: c_ulong = zeroes(c_ulong),
    msg: [*c]u8 = zeroes([*c]u8),
    state: ?*internal_state = zeroes(?*internal_state),
    zalloc: alloc_func = zeroes(alloc_func),
    zfree: free_func = zeroes(free_func),
    @"opaque": ?*anyopaque = zeroes(?*anyopaque),
    data_type: c_int = zeroes(c_int),
    adler: c_ulong = zeroes(c_ulong),
    reserved: c_ulong = zeroes(c_ulong),
};

pub const z_streamp = [*c]z_stream;

pub const gz_header = extern struct {
    text: c_int = zeroes(c_int),
    time: c_ulong = zeroes(c_ulong),
    xflags: c_int = zeroes(c_int),
    os: c_int = zeroes(c_int),
    extra: [*c]u8 = zeroes([*c]u8),
    extra_len: c_uint = zeroes(c_uint),
    extra_max: c_uint = zeroes(c_uint),
    name: [*c]u8 = zeroes([*c]u8),
    name_max: c_uint = zeroes(c_uint),
    comment: [*c]u8 = zeroes([*c]u8),
    comm_max: c_uint = zeroes(c_uint),
    hcrc: c_int = zeroes(c_int),
    done: c_int = zeroes(c_int),
};

pub const gz_headerp = [*c]gz_header;

pub const struct_gzFile_s = extern struct {
    have: c_ulong = zeroes(c_ulong),
    next: [*c]u8 = zeroes([*c]u8),
    pos: c_long = zeroes(c_long),
};
pub const gzFile = [*c]struct_gzFile_s;
