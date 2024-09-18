const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = std.builtin.OptimizeMode.ReleaseSmall });

    const headersUrlCmd = b.addSystemCommand(&.{ "node", "-p", "process.release.headersUrl" });
    headersUrlCmd.has_side_effects = true; // mark as always rerun, need to rebuild on node version change
    const tarballCmd = b.addSystemCommand(&.{ "xargs", "-a" });
    tarballCmd.addFileArg(headersUrlCmd.captureStdOut());
    tarballCmd.addArgs(&.{ "curl", "-s" });
    const extractCmd = b.addSystemCommand(&.{ "tar", "-xf" });
    extractCmd.addFileArg(tarballCmd.captureStdOut());
    extractCmd.addArg("--strip-components=1");

    const header_step = b.step("headers", "Download Node.js headers");
    header_step.dependOn(&extractCmd.step);

    const lib = b.addSharedLibrary(.{
        .name = "zerlpack",
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    lib.addSystemIncludePath(.{ .src_path = .{ .owner = b, .sub_path = b.pathJoin(&.{ "include", "node" }) } });
    lib.linker_allow_shlib_undefined = true;

    lib.step.dependOn(header_step);

    const f = b.addInstallFile(lib.getEmittedBin(), "zerlpack.node");
    b.getInstallStep().dependOn(&f.step);
}
