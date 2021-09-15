const std = @import("std");
const fmtSliceHexLower = std.fmt.fmtSliceHexLower;
const process = std.process;
const print = std.debug.print;
const Md5 = std.crypto.hash.Md5;
const ArenaAllocator = std.heap.ArenaAllocator;

pub fn main() !void {
    var input: []u8 = undefined;
    var output: [Md5.digest_length]u8 = undefined;
    // Init allocator
    var arena = ArenaAllocator.init(std.heap.page_allocator);
    const allocator = &arena.allocator;
    defer arena.deinit();
    // Get arguments
    const args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);

    // Check for arguments
    if (args.len < 2) {
        print("expected input argument\n", .{});
        return;
    }

    input = args[1];

    // hash
    Md5.hash(input, &output, .{});

    // print
    print("{s}\n", .{fmtSliceHexLower(&output)});
}
