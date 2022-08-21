---
layout: default
title: Command-Line Arguments
nav_order: 1
permalink: /command_line_arguments
---

[command-line-arguments.zig](src/command-line-arguments.zig)

```zig
const std = @import("std");

test {
    const args = try std.process.argsAlloc(std.testing.allocator);
    defer std.process.argsFree(std.testing.allocator, args);

    std.debug.print("Argumnets: {s}\n", .{args});
}

```
