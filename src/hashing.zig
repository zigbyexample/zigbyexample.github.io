const std = @import("std");
const hash = std.crypto.hash;

test {
    const input = "hello";
    var output: [hash.Blake3.digest_length]u8 = undefined;

    hash.Blake3.hash(input, &output, .{});

    std.debug.print("{s}\n", .{std.fmt.fmtSliceHexLower(&output)});
}
