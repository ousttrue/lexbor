const std = @import("std");
const examples_build = @import("examples");
const zcc = @import("compile_commands");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const examples_dep = b.dependency("examples", .{
        .target = target,
        .optimize = optimize,
    });

    var targets = std.ArrayList(*std.Build.Step.Compile).init(b.allocator);

    for (examples_build.examples) |example| {
        const artifact = examples_dep.artifact(example.name);
        const install = b.addInstallArtifact(artifact, .{});
        b.getInstallStep().dependOn(&install.step);

        const run = b.addRunArtifact(artifact);
        run.step.dependOn(&install.step);
        b.step(
            b.fmt("run-{s}", .{example.name}),
            b.fmt("Run {s}", .{example.name}),
        ).dependOn(&run.step);

        targets.append(artifact) catch @panic("OOM");
    }

    // add a step called "zcc" (Compile commands DataBase) for making
    // compile_commands.json. could be named anything. cdb is just quick to type
    zcc.createStep(b, "zcc", .{ .targets = targets.toOwnedSlice() catch @panic("OOM") });
}
