const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdin = std.io.getStdIn();

    std.debug.print("input: ", .{});
    const input = try stdin.reader().readUntilDelimiterAlloc(allocator, '\n', 1024);
    defer allocator.free(input);

    std.debug.print("value: {s}\n", .{input});
}
