const std = @import("std");
const allocator = std.testing.allocator;
const uri = std.Uri.parse("https://ziglang.org/") catch unreachable;

test {
    var client: std.http.Client = .{ .allocator = allocator };
    defer client.deinit();

    var req = try client.request(.GET, uri, .{ .allocator = allocator }, .{});
    defer req.deinit();
    try req.start();
    try req.wait();

    try std.testing.expect(req.response.status == .ok);
}
