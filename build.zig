const std = @import("std");

pub fn build(b: *std.Build) !void {
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = std.builtin.OptimizeMode.ReleaseSmall });

    const targets: []const std.Target.Query = &.{
        .{ .cpu_arch = .aarch64, .os_tag = .linux, .abi = .gnu },
        .{ .cpu_arch = .aarch64, .os_tag = .linux, .abi = .musl },
        .{ .cpu_arch = .aarch64, .os_tag = .macos },
        .{ .cpu_arch = .aarch64, .os_tag = .windows },

        .{ .cpu_arch = .x86_64, .os_tag = .linux, .abi = .gnu },
        .{ .cpu_arch = .x86_64, .os_tag = .linux, .abi = .musl },
        .{ .cpu_arch = .x86_64, .os_tag = .macos },
        .{ .cpu_arch = .x86_64, .os_tag = .windows },
    };

    inline for (targets) |target| {
        const resolved = b.resolveTargetQuery(target);

        var lib = b.addSharedLibrary(.{
            .name = "zerlpack",
            .root_source_file = b.path("src/lib.zig"),
            .target = resolved,
            .optimize = optimize,
            .link_libc = true,
        });
        lib.linker_allow_shlib_undefined = true;

        const output = b.addInstallFileWithDir(lib.getEmittedBin(), .{ .custom = try target.zigTriple(b.allocator) }, "zerlpack.node");
        b.getInstallStep().dependOn(&output.step);
    }
}
