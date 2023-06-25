const std = @import("std");

const my_json =
    \\{
    \\    "vals": {
    \\        "testing": 1,
    \\        "production": 42
    \\    },
    \\    "uptime": 9999
    \\}
;

const Config = struct {
    vals: struct {
        testing: u8,
        production: u8,
    },
    uptime: u64,
};

test {
    const config = try std.json.parseFromSlice(Config, std.testing.allocator, my_json, .{});
    defer config.deinit();

    try std.testing.expectEqual(@as(u8, 1), config.value.vals.testing);
    try std.testing.expectEqual(@as(u8, 42), config.value.vals.production);
    try std.testing.expectEqual(@as(u64, 9_999), config.value.uptime);
}
