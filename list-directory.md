# 1 - List Directory

List all the files and folders present in the current directory or the given path in arguments.

[ls.zig](code/ls.zig)
```zig
const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    const args = try std.process.argsAlloc(std.testing.allocator);
    defer std.process.argsFree(std.testing.allocator, args);
    const dir = try std.fs.cwd().openDir(if (args.len < 2) "." else args[1], .{ .iterate = true });
    var dir_iterator = dir.iterate();

    // Iterate Over the Path's
    while (try dir_iterator.next()) |path| {
        try stdout.print("{s}\n", .{path.name});
    }
}
```
