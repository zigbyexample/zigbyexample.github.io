---
layout: default
title: Hashing
nav_order: 6
permalink: /hashing
---

hash `hello` with Blake 3 algorithm.

[hashing.zig](src/hashing.zig)

```zig
const std = @import("std");
const Blake3 = std.crypto.hash.Blake3;

test {
    const input = "hello";
    var output: [Blake3.digest_length]u8 = undefined;

    Blake3.hash(input, &output, .{});

    std.debug.print("{s}\n", .{std.fmt.fmtSliceHexLower(&output)});
}

```
