# Directory Listing

List all files and directories present in the current directory or the given path.

[ls.zig](code/ls.zig)

```zig
const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    const dir = try std.fs.cwd().openIterableDir(if (args.len < 2) "." else args[1], .{});
    var dir_iterator = dir.iterate();

    // Iterate Over the Path's
    while (try dir_iterator.next()) |path| {
        try stdout.print("{s}\n", .{path.name});
    }
}

```
