const std = @import("std");

test {
    const dir = try std.fs.cwd().openIterableDir(".", .{});
    var iterator = dir.iterate();

    while (try iterator.next()) |path| {
        std.debug.print("{s}\n", .{path.name});
    }
}
