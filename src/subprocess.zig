const std = @import("std");

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = [_][]const u8{ "ls", "-al" };

    var process = std.ChildProcess.init(&args, allocator);

    std.debug.print("Running command: {s}\n", .{args});
    try process.spawn();

    const ret_val = try process.wait();
    try std.testing.expectEqual(ret_val, .{ .Exited = 0 });
}
