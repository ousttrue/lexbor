const std = @import("std");
const lexbor_build = @import("lexbor");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lexbor_dep = b.dependency("lexbor", .{
        .target = target,
        .optimize = optimize,
    });

    for (examples) |example| {
        const exe = b.addExecutable(.{
            .target = target,
            .optimize = optimize,
            .name = example.name,
            .link_libc = true,
        });
        exe.entry = .disabled;
        exe.addCSourceFiles(.{
            .files = example.files,
            .flags = &lexbor_build.flags,
        });
        exe.addIncludePath(lexbor_dep.path(""));
        exe.linkLibrary(lexbor_dep.artifact("lexbor"));

        b.installArtifact(exe);
    }
}

pub const Example = struct {
    name: []const u8,
    files: []const []const u8,
};

pub const examples = [_]Example{
    .{
        .name = "html_parse",
        .files = &.{
            "lexbor/html/parse.c",
        },
    },
};
