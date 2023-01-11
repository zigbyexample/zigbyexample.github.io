const std = @import("std");

const client_msg = "Hello";
const server_msg = "Good Bye";

const Server = struct {
    stream_server: std.net.StreamServer,

    pub fn init() !Server {
        const address = std.net.Address.initIp4([4]u8{ 127, 0, 0, 1 }, 8080);

        var server = std.net.StreamServer.init(.{ .reuse_address = true });
        try server.listen(address);

        return Server{ .stream_server = server };
    }

    pub fn deinit(self: *Server) void {
        self.stream_server.deinit();
    }

    pub fn accept(self: *Server) !void {
        const conn = try self.stream_server.accept();
        defer conn.stream.close();

        var buf: [1024]u8 = undefined;
        const msg_size = try conn.stream.read(buf[0..]);

        try std.testing.expectEqualStrings(client_msg, buf[0..msg_size]);

        _ = try conn.stream.write(server_msg);
    }
};

fn sendMsgToServer(server_address: std.net.Address) !void {
    const conn = try std.net.tcpConnectToAddress(server_address);
    defer conn.close();

    _ = try conn.write(client_msg);

    var buf: [1024]u8 = undefined;
    const resp_size = try conn.read(buf[0..]);

    try std.testing.expectEqualStrings(server_msg, buf[0..resp_size]);
}

test {
    var server = try Server.init();
    defer server.deinit();

    const client_thread = try std.Thread.spawn(.{}, sendMsgToServer, .{server.stream_server.listen_address});
    defer client_thread.join();

    try server.accept();
}
