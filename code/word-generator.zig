const std = @import("std");
const parseUnsigned = std.fmt.parseUnsigned;
const process = std.process;
const print = std.debug.print;
const DefaultPrng = std.rand.DefaultPrng;
const ArenaAllocator = std.heap.ArenaAllocator;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

fn generateWords(allocator: *Allocator, word_count: usize, letter_count: usize) !void {
    // Randomizer engine: generates a new random number
    var rand_engine = DefaultPrng.init(@intCast(u64, std.time.milliTimestamp())).random; // std.time.milliTimestamp() is the seed

    var list = ArrayList([]u8).init(allocator); // List of words
    defer list.deinit();

    var wc: usize = 0;
    while (wc < word_count) : (wc += 1) {
        var word = ArrayList(u8).init(allocator); // The word: list of letters
        defer word.deinit();

        var prev_letter: u8 = 0; // Previus letter

        var lc: usize = 0; // letters count
        while (lc < letter_count) {
            // Generate a random letter
            const letter = rand_engine.intRangeLessThanBiased(u7, 'a', 'z');

            // We dont want repeated characters
            if (prev_letter == letter)
                continue;

            try word.append(letter); // Append letter to word
            prev_letter = letter;
            lc += 1;
        }

        // Append word
        try list.append(word.toOwnedSlice());
        word.deinit();
    }

    for (list.items) |item| {
        print("{s}\n", .{item});
    }
}

pub fn main() anyerror!void {
    // Init allocator
    var arena = ArenaAllocator.init(page_allocator);
    const allocator = &arena.allocator;

    // Free memory
    defer {
        process.argsFree(allocator, args);
        arena.deinit();
    }

    // Set initial words and letters count
    var letter_count: usize = 5;
    var word_count: usize = 5;

    // Get arguments
    const args = try process.argsAlloc(allocator);
    defer allocator.free(args);

    // Check for arguments
    for (args) |arg, i| {
        if (i == 1) {
            letter_count = try parseUnsigned(usize, arg, 0);
        } else if (i == 2) {
            word_count = try parseUnsigned(usize, arg, 0);
        } else break;
    }

    try generateWords(allocator, word_count, letter_count);
}
