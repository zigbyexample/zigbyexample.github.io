# 2 - Subprocess

In this program, we will create a subprocess (known as `ChildProcess` in Zig) and using it, execute a native application.  
For simplicity reasons, the application run is `ls -al`.

[subprocess.zig](code/subprocess.zig)
```zig
const std = @import("std");

pub fn main() anyerror!void {
    const args = [_][]const u8{ "ls", "-al" }; // equals to : ls -al

    // Initialize process
    var process = try std.ChildProcess.init(&args, std.testing.allocator);
    defer process.deinit();

    std.debug.print("Running command: {s}\n", .{args});
    try process.spawn();

    const ret_val = try process.wait();
    try std.testing.expectEqual(ret_val, .{ .Exited = 0 });
}
```
