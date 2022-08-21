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
const hash = std.crypto.hash;

test {
    const input = "hello";
    var output: [hash.Blake3.digest_length]u8 = undefined;

    hash.Blake3.hash(input, &output, .{});

    std.debug.print("{s}\n", .{std.fmt.fmtSliceHexLower(&output)});
}

```
