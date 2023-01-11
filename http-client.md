---
layout: default
title: HTTP Client
nav_order: 9
permalink: /http-client
---

[http-client.zig](src/http-client.zig)

```zig
const std = @import("std");

const uri = std.Uri.parse("https://ziglang.org") catch unreachable;

test {
    var client = std.http.Client{ .allocator = std.testing.allocator };
    defer client.deinit(std.testing.allocator);

    var req = try client.request(uri, .{}, .{});
    defer req.deinit();

    try std.testing.expect(req.response.headers.status == .ok);
}

```
