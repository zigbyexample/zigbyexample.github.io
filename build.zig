const std = @import("std");
const cwd = std.fs.cwd();

pub fn build(b: *std.build.Builder) !void {
    const mode = b.standardReleaseOptions();

    const test_step = b.step("test", "Test code exmaples");
    inline for (examples) |example| {
        const example_test = b.addTest("src/" ++ example ++ ".zig");
        example_test.setBuildMode(mode);
        test_step.dependOn(&example_test.step);
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
    "read-write-file",
    "directory-listing",
    "spawn-subprocess",
    "hashing",
    "tcp-connection",
    "atomic",
};
