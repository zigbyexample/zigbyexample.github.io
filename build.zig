const std = @import("std");
const cwd = std.fs.cwd();

pub fn build(b: *std.build.Builder) !void {
    const mode = b.standardReleaseOptions();
    const target = b.standardTargetOptions(.{});

    const test_step = b.step("test", "Test code exmaples");
    var code_buf: [2048]u8 = undefined;
    for (examples) |example| {
        if (std.mem.eql(u8, example, "read-input")) continue;

        const contact_code_example = try std.mem.concat(b.allocator, u8, &.{ example, ".zig" });
        const code_path = try std.fs.path.join(b.allocator, &.{ "src/", contact_code_example });
        std.debug.print("{s}\n", .{code_path});
        const example_file = try cwd.openFile(code_path, .{ .mode = .read_only });
        const read = try example_file.readAll(&code_buf);
        const is_executable = std.mem.containsAtLeast(u8, code_buf[0..read], 1, "pub fn main");

        if (is_executable) {
            const example_exe = b.addExecutable(example, code_path);
            example_exe.setBuildMode(mode);
            example_exe.setTarget(target);
            const run_cmd = example_exe.run();
            test_step.dependOn(&run_cmd.step);
        } else {
            const example_test = b.addTest(code_path);
            example_test.setBuildMode(mode);
            test_step.dependOn(&example_test.step);
        }
    }

    inline for (examples) |example| {
        const output_path = example ++ ".md";
        const code_path = "src/" ++ example ++ ".zig";
        const template_path = "template/" ++ example ++ ".md";

        try cwd.copyFile(template_path, cwd, output_path, .{});

        var output_file = try cwd.openFile(output_path, .{ .mode = .write_only });
        var code_file = try cwd.openFile(code_path, .{ .mode = .read_only });
        defer output_file.close();
        defer code_file.close();

        const code_content = try code_file.readToEndAlloc(b.allocator, 1024 * 1024);

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
    "command-line-arguments",
    "read-input",
    "read-write-file",
    "directory-listing",
    "spawn-subprocess",
    "hashing",
    "tcp-connection",
    "mutex",
    "atomic",
};
