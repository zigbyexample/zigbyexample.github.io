const std = @import("std");

const uri = std.Uri.parse("https://ziglang.org/") catch unreachable;

test {
    var client: std.http.Client = .{ .allocator = std.testing.allocator };

    var req = try client.request(uri, .{}, .{});
    defer req.deinit();

    try std.testing.expect(req.response.headers.status == .ok);
}
