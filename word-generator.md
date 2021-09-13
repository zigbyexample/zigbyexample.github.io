# 1 - Word Generator
We’ll build a **Word Generator**, that generates random words based on entered number of letter count and word count by command line arguments.
```php
$ ./wg 5 4 # <letters count> <words count>
lazob
ejaya
qeuom
fated
```

[word-generator.zig](/code/word-generator.zig):
```zig
const std = @import("std");
const parseUnsigned = std.fmt.parseUnsigned;
const process = std.process;
const print = std.debug.print;
const page_allocator = std.heap.page_allocator;
const DefaultPrng = std.rand.DefaultPrng;
const ArenaAllocator = std.heap.ArenaAllocator;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

// we use `u7` because our range number (a-z) is less than 128
const alpha_start: u7 = 97; // = ASCII `a`
const alpha_end: u7 = 123; // = ASCII `}` (after `z`)

const WordGenerator = struct {
    allocator: *Allocator, // accept an *Allocator as a parameter allow you to decide what allocator to use.
    word_count: usize,
    letter_count: usize,

    pub fn init(allocator: *Allocator, word_count: usize, letter_count: usize) WordGenerator {
        return WordGenerator{ .allocator = allocator, .word_count = word_count, .letter_count = letter_count };
    }

    // check if "letter" is one of {`a`, `e`, `i`, `o`} or no
    fn is_regular_letter(letter: u8) bool {
        if (letter == 97 or letter == 101 or letter == 105 or letter == 111) {
            return false;
        }
        return true;
    }

    pub fn generate(self: *WordGenerator) ?[][]u8 {

        // randomizer engine. generates a new random number millisecond
        var rand_engine = DefaultPrng.init(@intCast(u64, std.time.milliTimestamp())).random;

        var list = ArrayList([]u8).init(self.allocator); // init list
        defer list.deinit(); // deinit

        while (self.word_count > 0) : (self.word_count -= 1) {
            var lc: usize = 0; // letters count
            var prev_letter: u8 = 0; // previus letter to check is_regular_letter
            var word = ArrayList(u8).init(self.allocator);
            defer word.deinit(); // deinit
            while (lc < self.letter_count) {
                // generate a random letter
                const letter = rand_engine.intRangeLessThanBiased(u7, alpha_start, alpha_end);

                // continue if equals to previus letter
                if (is_regular_letter(prev_letter) == is_regular_letter(letter) and lc != 0)
                    continue;

                word.append(letter) catch return null; // append letter to word
                prev_letter = letter;
                lc += 1;
            }

            // append word
            list.append(word.toOwnedSlice()) catch return null;
        }
        return list.toOwnedSlice();
    }
};

pub fn main() anyerror!void {
    // init allocator
    var arena = ArenaAllocator.init(page_allocator);
    const allocator = &arena.allocator;

    // get arguments
    const args = try process.argsAlloc(allocator);

    // free memory
    defer {
        process.argsFree(allocator, args);
        arena.deinit();
    }

    // init words and letters count
    var letter_count: usize = 5;
    var word_count: usize = 5;

    // modify if there's argument
    for (args) |arg, i| {
        if (i == 1) {
            letter_count = try parseUnsigned(usize, arg, 0);
        } else if (i == 2) {
            word_count = try parseUnsigned(usize, arg, 0);
        }
    }

    var wd = WordGenerator.init(allocator, word_count, letter_count); // init WordGenerator
    const words = wd.generate(); // generate words

    // check is't null
    if (words != null) {
        // print words
        for (words.?) |word| {
            print("{s}\n", .{word});
        }
    }
}
```
