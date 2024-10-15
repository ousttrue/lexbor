const std = @import("std");
const lexbor_build = @import("lexbor");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lexbor_dep = b.dependency("lexbor", .{
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .target = target,
        .optimize = optimize,
        .name = "html_parse",
        .link_libc = true,
    });
    exe.entry = .disabled;
    exe.addCSourceFiles(.{
        .files = &.{
            "lexbor/html/parse.c",
        },
        .flags = &lexbor_build.flags,
    });
    exe.addIncludePath(lexbor_dep.path(""));
    exe.linkLibrary(lexbor_dep.artifact("lexbor"));

    b.installArtifact(exe);
}
