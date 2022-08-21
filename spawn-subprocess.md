---
layout: default
title: Spawning Subprocess
nav_order: 5
permalink: /spawn_subprocess
---

[spawn-subprocess.zig](src/spawn-subprocess.zig)

```zig
const std = @import("std");

test {
    const args = [_][]const u8{ "ls", "-al" };

    var process = std.ChildProcess.init(&args, std.testing.allocator);
    std.debug.print("Running command: {s}\n", .{args});
    try process.spawn();

    const ret_val = try process.wait();
    try std.testing.expectEqual(ret_val, .{ .Exited = 0 });
}

```
