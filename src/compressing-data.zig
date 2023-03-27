const std = @import("std");

test {
    const data = "�!drandom+J�K��UHI,IT(-NMQ��S��LWH�TH�H�-�I�e��#";
    var fbs = std.io.fixedBufferStream(data);

    var gzip_stream = try std.gzip.decompress(std.testing.allocator, fbs.reader());
    defer gzip_stream.deinit();

    const result = try gzip_stream.reader().readAllAlloc(std.testing.allocator, std.math.maxInt(usize));
    defer std.testing.allocator.free(result);

    std.testing.expectEqualStrings("some random data used in zig by example!", result);
}
