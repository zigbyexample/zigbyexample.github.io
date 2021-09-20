const std = @import("std");
const parseUnsigned = std.fmt.parseUnsigned;
const process = std.process;
const print = std.io.getStdOut().writer().print;
const DefaultPrng = std.rand.DefaultPrng;
const ArenaAllocator = std.heap.ArenaAllocator;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

fn generateWords(allocator: *Allocator, word_count: usize, letter_count: usize) !void {
    // Randomizer engine: generates a new random number
    var rand_engine = DefaultPrng.init(@intCast(u64, std.time.milliTimestamp())).random; // std.time.milliTimestamp() is the seed

    var wc: usize = 0;
    while (wc < word_count) : (wc += 1) {
        var word = ArrayList(u8).init(allocator); // The word: list of letters
        defer word.deinit();

        var prev_letter: u8 = 0; // Previous letter

        var lc: usize = 0; // Letter count
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

        // Print the word
        try print("{s}\n", .{word.items});
        word.deinit();
    }
}

pub fn main() anyerror!void {
    // Init allocator
    var arena = ArenaAllocator.init(std.heap.page_allocator);
    const allocator = &arena.allocator;
    defer arena.deinit();

    // Set initial words and letters count
    var letter_count: usize = 5;
    var word_count: usize = 5;

    // Get arguments
    const args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);

    // Check for arguments
    for (args) |arg, i| {
        if (i == 1) {
            letter_count = try parseUnsigned(usize, arg, 0);
        } else if (i == 2) {
            word_count = try parseUnsigned(usize, arg, 0);
        }
    }

    try generateWords(allocator, word_count, letter_count);
}
