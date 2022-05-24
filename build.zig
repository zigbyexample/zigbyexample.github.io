const std = @import("std");
const cwd = std.fs.cwd();

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    inline for (examples) |example| {
        const code_path = "src/" ++ example ++ ".zig";

        const exe = b.addExecutable(example, code_path);
        exe.setTarget(target);
        exe.setBuildMode(mode);
        exe.install();

        const run_cmd = exe.run();
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        const run_step = b.step("run-" ++ example, "Run the app");
        run_step.dependOn(&run_cmd.step);
    }

    for (examples) |example| {
        const code_name = try std.mem.concat(b.allocator, u8, &.{ example, ".zig" });
        const template_in_name = try std.mem.concat(b.allocator, u8, &.{ example, ".md.in" });
        const output_path = try std.mem.concat(b.allocator, u8, &.{ example, ".md" });
        const code_path = try std.fs.path.join(b.allocator, &.{ "src", code_name });
        const template_path = try std.fs.path.join(b.allocator, &.{ "template", template_in_name });

        try cwd.copyFile(template_path, cwd, output_path, .{});

        var output_file = try cwd.openFile(output_path, .{ .mode = .write_only });
        var code_file = try cwd.openFile(code_path, .{ .mode = .read_only });
        const code_content = try code_file.readToEndAlloc(b.allocator, 1024 * 1024);
        defer {
            output_file.close();
            code_file.close();
            b.allocator.free(code_content);
            b.allocator.free(code_name);
            b.allocator.free(template_in_name);
            b.allocator.free(output_path);
            b.allocator.free(code_path);
            b.allocator.free(template_path);
        }

        try output_file.seekFromEnd(0);
        try output_file.writer().print(
            \\
            \\```zig
            \\{s}
            \\```
            \\
        , .{code_content});
    }
}

const examples = [_][]const u8{
    "hasher",
    "list-directory",
    "shell",
    "subprocess",
    "tcp-connection",
    "word-generator",
};
