---
layout: default
title: Command-Line Arguments
nav_order: 1
permalink: /command_line_arguments
---

[command-line-arguments.zig](src/command-line-arguments.zig)

```zig
const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    std.debug.print("Arguments: {s}\n", .{args});
}

```
