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

    try std.testing.expect(config.value.vals.testing == 1);
    try std.testing.expect(config.value.vals.production == 42);
    try std.testing.expect(config.value.uptime == 9999);
}
