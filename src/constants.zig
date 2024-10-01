pub const format_version = 131;

pub const Tag = enum(u8) {
    distribution_header = 68,
    distribution_header_fragmented = 69,
    new_float = 70, // float: f64
    bit_binary = 77,
    compressed = 80, // uncompressed_size: u32, value: []u8
    atom_cache_ref = 82, // index: u8
    new_pid = 88,
    new_port = 89,
    newer_reference = 90,
    small_integer = 97, // value: u8
    integer = 98, // value: u32
    float = 99, // value: [31]u8
    atom = 100, // length: u16, value: [length]u8
    reference = 101,
    port = 102,
    pid = 103,
    small_tuple = 104,
    large_tuple = 105,
    nil = 106, // -
    string = 107, // length: u32, value: [length]u8
    list = 108, // length: u32, value: [length], tail: nil
    binary = 109, // length: u32, value: [length]u8
    small_big = 110, // arity: u8, sign: u8, [arity]u8
    large_big = 111, // arity: u32, sign: u8, [arity]u8
    new_fun = 112,
    export_ext = 113,
    new_reference = 114,
    small_atom = 115, // length: u8, value: [length]u8
    map = 116, // arity: u32, pairs: pair[arity]
    fun = 117,
    atom_utf8 = 118,
    small_atom_utf8 = 119,
    _,
};
