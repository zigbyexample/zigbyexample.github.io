const std = @import("std");
const cwd = std.fs.cwd;
const print = std.io.getStdOut().writer().print;

pub fn main() !void {
    const dir = try cwd().openDir(if (args.len < 2) "." else args[1], .{ .iterate = true });
    var dir_iterator = dir.iterate();

    // Iterate Over the Path's
    while (try dir_iterator.next()) |path| {
        try print("{s}\n", .{path.name});
    }
}
