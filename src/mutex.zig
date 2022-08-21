const std = @import("std");
const Thread = std.Thread;

const ThreadSafeCounter = struct {
    lock: Thread.Mutex,
    count: usize,

    pub fn increase(self: *ThreadSafeCounter) void {
        self.lock.lock();
        defer self.lock.unlock();

        self.count += 1;
    }
};

test {
    var counter = ThreadSafeCounter{
        .lock = .{},
        .count = 0,
    };

    var i: usize = 0;
    while (i < 50) : (i += 1) {
        const thread = try std.Thread.spawn(.{}, ThreadSafeCounter.increase, .{&counter});
        thread.join();
    }

    try std.testing.expect(counter.count == 50);
}
