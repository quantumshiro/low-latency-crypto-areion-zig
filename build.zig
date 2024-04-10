const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "areion",
        .target = target,
        .optimize = optimize,
    });

    exe.addIncludePath(.{ .path = "include/" });
    exe.addCSourceFiles(.{
        .files = &.{
            "ref/opp-256.c",
            "ref/opp-512.c",
            "ref/areion.c",
            "test/areion-test.c",
        },
    });
    exe.linkLibC();
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
