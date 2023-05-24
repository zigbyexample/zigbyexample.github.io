const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.build.Builder) !void {
    const cwd = std.fs.cwd();
    const optimize = b.standardOptimizeOption(.{});

    for (examples) |example| {
        const contact_code_example = try std.mem.concat(b.allocator, u8, &.{ example, ".zig" });
        const code_path = try std.fs.path.join(b.allocator, &.{ "src/", contact_code_example });

        const example_test = b.addTest(.{
            .name = example,
            .root_source_file = .{ .path = code_path },
            .optimize = optimize,
        });
        b.getInstallStep().dependOn(&example_test.step);
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

const examples = &[_][]const u8{
    "atomic",
    "compressing-data",
    "command-line-arguments",
    "directory-listing",
    "hashing",
    "http-client",
    "json",
    "mutex",
    "read-input",
    "read-write-file",
    "spawn-subprocess",
    "tcp-connection",
};
