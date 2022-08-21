---
layout: default
title: Read/Write File
nav_order: 1
permalink: /read_write_file
---

[read_write_file.zig](src/read_write_file.zig)

```zig
const std = @import("std");
const cwd = std.fs.cwd();

test {
    const value = "hello";

    var my_file = try cwd.createFile("my_file.txt", .{ .read = true });
    defer my_file.close();

    _ = try my_file.write(value);

    var buf: [value.len]u8 = undefined;
    try my_file.seekTo(0);
    const read = try my_file.read(&buf);

    try std.testing.expectEqualStrings(value, buf[0..read]);
}

```
