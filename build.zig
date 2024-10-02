const std = @import("std");

pub fn build(b: *std.Build) !void {
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = std.builtin.OptimizeMode.ReleaseSmall });

    const pnpm_install = b.addSystemCommand(&.{ "pnpm", "install" });
    const download_headers = b.addSystemCommand(&.{ "node", "scripts/downloadHeaders.js" });
    const write_def_file = b.addSystemCommand(&.{ "node", "scripts/writeDefFile.js" });

    download_headers.step.dependOn(&pnpm_install.step);
    write_def_file.step.dependOn(&pnpm_install.step);

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

        const lib = b.addSharedLibrary(.{
            .name = "zerlpack",
            .root_source_file = b.path("src/lib.zig"),
            .target = resolved,
            .optimize = optimize,
            .link_libc = true,
        });
        lib.addSystemIncludePath(.{ .src_path = .{ .owner = b, .sub_path = b.pathJoin(&.{ "include", "node" }) } });
        lib.linker_allow_shlib_undefined = true;
        lib.step.dependOn(&download_headers.step);

        if (resolved.result.os.tag == .windows) {
            if (resolved.result.cpu.arch == .x86_64) {
                var run_dll_tool = b.addSystemCommand(&.{ b.graph.zig_exe, "dlltool", "-m", "i386:x86-64", "-D", "node.exe", "-l", "node_x86-64.lib", "-d", "node.def" });
                run_dll_tool.cwd = b.path("./def");

                run_dll_tool.step.dependOn(&write_def_file.step);
                lib.step.dependOn(&run_dll_tool.step);

                lib.addLibraryPath(b.path("./def"));
                lib.linkSystemLibrary("node_x86-64");
            } else if (resolved.result.cpu.arch == .aarch64) {
                var run_dll_tool = b.addSystemCommand(&.{ b.graph.zig_exe, "dlltool", "-m", "arm64", "-D", "node.exe", "-l", "node_arm64.lib", "-d", "node.def" });
                run_dll_tool.cwd = b.path("./def");

                run_dll_tool.step.dependOn(&write_def_file.step);
                lib.step.dependOn(&run_dll_tool.step);

                lib.addLibraryPath(b.path("./def"));
                lib.linkSystemLibrary("node_arm64");
            }
        }

        const output = b.addInstallFileWithDir(lib.getEmittedBin(), .{ .custom = try target.zigTriple(b.allocator) }, "zerlpack.node");

        b.getInstallStep().dependOn(&output.step);
    }
}
