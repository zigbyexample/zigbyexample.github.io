---
layout: default
title: Atomics
nav_order: 9
permalink: /atomics
---

[atomic.zig](src/atomic.zig)

```zig
const std = @import("std");

var num = std.atomic.Atomic(u32).init(0);

test {
    var i: usize = 0;
    while (i < 50) : (i += 1) {
        const thread = try std.Thread.spawn(.{}, updateNum, .{});
        thread.join();
    }

    try std.testing.expect(num.loadUnchecked() == 50000);
}

fn updateNum() void {
    var i: usize = 0;
    while (i < 1000) : (i += 1) {
        _ = num.fetchAdd(1, .Acquire);
    }
}

```
