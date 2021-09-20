const std = @import("std");
const cwd = std.fs.cwd;
const page_allocator = std.heap.page_allocator;
const process = std.process;
const print = std.io.getStdOut().writer().print;

pub fn main() !void {
    // Get Arguments
    const args = try process.argsAlloc(page_allocator);
    defer process.argsFree(page_allocator, args);

    const dir = try cwd().openDir(if (args.len < 2) "." else args[1], .{ .iterate = true });
    var dir_iterator = dir.iterate();

    // Iterate Over the Path's
    while (try dir_iterator.next()) |path| {
        try print("{s}\n", .{path.name});
    }
}
