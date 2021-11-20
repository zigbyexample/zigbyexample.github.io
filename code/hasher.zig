const std = @import("std");
const stdout = std.io.getStdOut().writer();
const hash = std.crypto.hash;

pub fn main() !void {
    // Get Arguments
    const args = try std.process.argsAlloc(std.testing.allocator);
    defer std.process.argsFree(std.testing.allocator, args);

    // Check for Arguments
    if (args.len < 2) {
        try stdout.writeAll("expected input argument\n");
        return;
    }

    var input = args[1]; // hash input from first argument
    var output: [hash.Blake3.digest_length]u8 = undefined; // this will be hash result

    hash.Blake3.hash(input, &output, .{});

    try stdout.print("{s}\n", .{std.fmt.fmtSliceHexLower(&output)});
}