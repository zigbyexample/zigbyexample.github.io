# 3 - Hasher
We’ll build a **Hasher**, that Hash's input argument by the Blake3 algorithm.

[hasher.zig](code/hasher.zig)
```zig
const std = @import("std");
const fmtSliceHexLower = std.fmt.fmtSliceHexLower;
const process = std.process;
const stdout = std.io.getStdOut().writer();
const page_allocator = std.heap.page_allocator;
const Blake3 = std.crypto.hash.Blake3;

pub fn main() !void {
    // Get Arguments
    const args = try process.argsAlloc(page_allocator);
    defer process.argsFree(page_allocator, args);

    // Check for Arguments
    if (args.len < 2) {
        try stdout.writeAll("expected input argument\n");
        return;
    }

    var input = args[1]; // hash input from first argument
    var output: [Blake3.digest_length]u8 = undefined; // this will be hash result

    Blake3.hash(input, &output, .{});

    try stdout.print("{s}\n", .{fmtSliceHexLower(&output)});
}
```
