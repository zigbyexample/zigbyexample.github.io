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
    var tok_stream = std.json.TokenStream.init(my_json);
    const res = try std.json.parse(Config, &tok_stream, .{});

    try std.testing.expect(res.vals.testing == 1);
    try std.testing.expect(res.vals.production == 42);
    try std.testing.expect(res.uptime == 9999);
}
