const std = @import("std");

const ThreadSafeCounter = struct {
    lock: std.Thread.Mutex,
    count: usize,

    pub fn increase(self: *ThreadSafeCounter, n: u32) void {
        var i: u32 = 0;
        while (i < n) : (i += 1) {
            self.lock.lock();
            defer self.lock.unlock();

            self.count += 1;
        }
    }
};

test {
    var threads: [3]std.Thread = undefined;
    var counter = ThreadSafeCounter{
        .lock = .{},
        .count = 0,
    };

    for (&threads) |*thrd| {
        thrd.* = try std.Thread.spawn(.{}, ThreadSafeCounter.increase, .{ &counter, 1000 });
    }

    for (threads) |thrd| {
        thrd.join();
    }

    try std.testing.expect(counter.count == 3_000);
}
