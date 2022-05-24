# 4 - TCP Connection

[tcp-connection.zig](/code/tcp-connection.zig)

```zig
const std = @import("std");
const net = std.net;
const testing = std.testing;

const client_msg = "Hello";
const server_msg = "Good Bye";

const Server = struct {
    stream_server: net.StreamServer,

    pub fn init() !Server {
        const address = net.Address.initIp4([4]u8{ 127, 0, 0, 1 }, 8080);

        // more information about `reuse_address`: http://unixguide.net/network/socketfaq/4.5.shtml
        var server = net.StreamServer.init(.{ .reuse_address = true });

        // start listening at 127.0.0.1:8080
        try server.listen(address);

        return Server{ .stream_server = server };
    }

    pub fn deinit(self: *Server) void {
        self.stream_server.deinit();
    }

    pub fn accept(self: *Server) !void {
        // accepting incoming client connection
        const conn = try self.stream_server.accept();
        defer conn.stream.close();

        // initialize a buffer to keep the client message
        var buf: [1024]u8 = undefined;
        var msg_size = try conn.stream.read(buf[0..]);

        // assert client message is 'Hello'
        try testing.expectEqualSlices(u8, client_msg, buf[0..msg_size]);

        // send 'Good Bye' to client
        _ = try conn.stream.write(server_msg);
    }
};

fn sendMsgToServer(server_address: net.Address) !void {
    // connect to server
    const conn = try net.tcpConnectToAddress(server_address);
    defer conn.close();

    // send 'Hello' to client
    _ = try conn.write(client_msg);

    // initialize a buffer to keep the server response
    var buf: [1024]u8 = undefined;
    var resp_size = try conn.read(buf[0..]);

    // assert server response is 'Good Bye'
    try testing.expectEqualSlices(u8, server_msg, buf[0..resp_size]);
}

pub fn main() !void {
    var server = try Server.init();
    defer server.deinit();

    // spawn a new client therad to send `Hello`
    const client_thread = try std.Thread.spawn(.{}, sendMsgToServer, .{server.stream_server.listen_address});
    defer client_thread.join();

    // accept incoming connection
    try server.accept();
}

```
