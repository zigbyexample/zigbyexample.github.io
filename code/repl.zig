const std = @import("std");
const mem = std.mem;
const stdin = std.io.getStdIn().reader();
const stderr = std.io.getStdErr().writer();

const HELP_OUTPUT = 
    \\commands :
    \\  hello -> prints a hello message
    \\  help  -> commands list
    \\  exit  -> exits program
    \\
    ;

const ReplCmd = enum {
    hello,
    help,
    exit,
};

const ReplError = error{
    UnkownCommand,
    EmptyCommand,
};

fn get_command(cmd: []const u8) ReplError!ReplCmd {
    if (mem.eql(u8, cmd, "hello")) {
        return .hello;
    } else if (mem.eql(u8, cmd, "help")) {
        return .help;
    } else if (mem.eql(u8, cmd, "exit")) {
        return .exit;
    } else if (cmd.len == 0) {
        return ReplError.EmptyCommand;
    } else {
        return ReplError.UnkownCommand;
    }
}

pub fn main() !void {
    var repl_buf: [1024]u8 = undefined;
    while (true) {
        try stderr.print("\x1b[92;1m$ \x1b[0m", .{});
        if (stdin.readUntilDelimiterOrEof(&repl_buf, '\n') catch |err| {
            try stderr.print("\nUnable to parse command: {s}\n", .{@errorName(err)});
            continue;
        }) |line| {
            const actual_line = mem.trimRight(u8, line, "\r\n ");
            const cmd: ReplCmd = get_command(actual_line) catch |err| {
                if (err == ReplError.EmptyCommand) {
                    continue;
                } else if (err == ReplError.UnkownCommand) {
                    try stderr.print("Unknown Command: {s}\n", .{actual_line});
                    continue;
                }
                return;
            };
            switch (cmd) {
                .hello => {
                    try stderr.print("Hello!\n", .{});
                },
                .help => {
                    try stderr.print(HELP_OUTPUT, .{});
                },
                .exit => {
                    return;
                },
            }
        }
    }
}