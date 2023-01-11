const std = @import("std");
const Blake3 = std.crypto.hash.Blake3;

test {
    const input = "hello";
    var output: [Blake3.digest_length]u8 = undefined;

    Blake3.hash(input, &output, .{});

    std.debug.print("{s}\n", .{std.fmt.fmtSliceHexLower(&output)});
}
