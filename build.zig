const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.build.Builder) !void {
    const cwd = std.fs.cwd();
    const mode = b.standardReleaseOptions();

    const test_step = b.step("test", "Test code exmaples");
    for (examples) |example| {
        if (builtin.os.tag == .windows and example.unix_only) continue;

        const contact_code_example = try std.mem.concat(b.allocator, u8, &.{ example.name, ".zig" });
        const code_path = try std.fs.path.join(b.allocator, &.{ "src/", contact_code_example });

        const example_test = if (example.build_only)
            b.addTestExe(example.name, code_path)
        else
            b.addTest(code_path);
        example_test.setBuildMode(mode);
        test_step.dependOn(&example_test.step);
    }

    inline for (examples) |example| {
        const output_path = example.name ++ ".md";
        const code_path = "src/" ++ example.name ++ ".zig";
        const template_path = "template/" ++ example.name ++ ".md";

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

const examples = &[_]Example{
    .{ .name = "atomic" },
    .{ .name = "command-line-arguments" },
    .{ .name = "directory-listing" },
    .{ .name = "hashing" },
    .{ .name = "http-client", .build_only = true, .unix_only = true }, // TODO
    .{ .name = "json" },
    .{ .name = "mutex" },
    .{ .name = "read-input", .build_only = true },
    .{ .name = "read-write-file" },
    .{ .name = "spawn-subprocess", .unix_only = true },
    .{ .name = "tcp-connection" },
};

const Example = struct {
    name: []const u8,
    build_only: bool = false,
    unix_only: bool = false,
};
