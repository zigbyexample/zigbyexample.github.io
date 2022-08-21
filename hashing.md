# Hashing

hash `hello` it with Blake 3 algorithm.

[hasher.zig](src/hasher.zig)

```zig
const std = @import("std");
const hash = std.crypto.hash;

pub fn main() !void {
    const input = "hello";
    var output: [hash.Blake3.digest_length]u8 = undefined;

    hash.Blake3.hash(input, &output, .{});

    std.debug.print("{s}\n", .{std.fmt.fmtSliceHexLower(&output)});
}

```
