const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = std.builtin.OptimizeMode.ReleaseSmall });

    const lib = b.addSharedLibrary(.{
        .name = "zerlpack",
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    lib.addSystemIncludePath(.{ .src_path = .{ .owner = b, .sub_path = b.pathJoin(&.{ "include", "node" }) } });
    lib.linker_allow_shlib_undefined = true;

    const f = b.addInstallFile(lib.getEmittedBin(), "zerlpack.node");
    b.getInstallStep().dependOn(&f.step);
}
