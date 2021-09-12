const std = @import("std");
const StreamServer = std.net.StreamServer;
const Options = StreamServer.Options;
const Address = std.net.Address;

pub fn main() anyerror!void {
    // init local IP address
    // you can also change port number or use IPv6
    const address = Address.initIp4([4]u8{ 127, 0, 0, 1 }, 8080);

    // init server
    // if `reuse_address` not modifyed to `true` you should wait after running program
    // for more information read http://unixguide.net/network/socketfaq/4.5.shtml
    var server = StreamServer.init(Options{ .reuse_address = true });

    defer server.deinit();

    try server.listen(address); // start listening server

    // accepting connections
    while (true) {
        const conn = try stream.accept();
        defer conn.stream.close();

        var buf : [4096]u8 = undefined;
        _ = try conn.stream.read(buf[0..]);
        
        const message = "HTTP/1.1 200 OK\n\nHello world!";
        _ = try conn.stream.write(message);
    }
}