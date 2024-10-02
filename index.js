"use strict";

const os = require("os");
const fs = require("fs");

const arch = {
	"x64": "x86_64",
	"arm64": "aarch64"
}[os.arch()];

if (!arch) throw new Error("Unsupported architecture: " + os.arch());

const platform =  {
	"win32": "windows",
	"darwin": "macos",
	"linux": "linux"
}[os.platform()];

if (!platform) throw new Error("Unsupported platform: " + os.platform());

const libc = platform !== "linux" ? undefined : fs.existsSync("/etc/alpine-release") ? "musl" : "gnu";

module.exports = require(`./zig-out/${[arch, platform, libc].filter(Boolean).join("-")}/zerlpack.node`)
