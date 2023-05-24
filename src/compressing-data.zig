const std = @import("std");

test {
    const file = try std.fs.cwd().openFile("file.gzip", .{});
    defer file.close();

    var gzip_stream = try std.compress.gzip.decompress(std.testing.allocator, file.reader());
    defer gzip_stream.deinit();

    const result = try gzip_stream.reader().readAllAlloc(std.testing.allocator, std.math.maxInt(usize));
    defer std.testing.allocator.free(result);

    try std.testing.expectEqualStrings("zig is cool!", result);
}
