---
layout: default
title: Reading input
nav_order: 2
permalink: /read_input
---

[read-input.zig](src/coread-input.zig)

```zig
const std = @import("std");

test {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdin = std.io.getStdIn();

    std.debug.print("input: ", .{});
    const input = try stdin.reader().readUntilDelimiterAlloc(allocator, '\n', 1024);
    defer allocator.free(input);

    std.debug.print("value: {s}\n", .{input});
}

```
