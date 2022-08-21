const std = @import("std");

test {
    const args = try std.process.argsAlloc(std.testing.allocator);
    defer std.process.argsFree(std.testing.allocator, args);

    std.debug.print("Argumnets: {s}\n", .{args});
}
