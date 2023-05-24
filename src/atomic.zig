const std = @import("std");
const AtomicInt = std.atomic.Atomic(u32);

test {
    var threads: [50]std.Thread = undefined;
    var data = AtomicInt.init(0);

    for (&threads) |*thrd| {
        thrd.* = try std.Thread.spawn(.{}, updateData, .{&data});
    }

    for (threads) |thrd| {
        thrd.join();
    }

    try std.testing.expect(data.loadUnchecked() == 50_000);
}

fn updateData(data: *AtomicInt) void {
    var i: usize = 0;
    while (i < 1000) : (i += 1) {
        _ = data.fetchAdd(1, .Release);
    }
}
