# 6 - Shell
In this program, we will create a Shell, that split the arguments and spawn a prcoess or run built-in commands (`clear` and `exit`).
you can also add some other shells features like history, autocomplete or git integration.

[shell.zig](code/shell.zig)
```zig
const std = @import("std");
const mem = std.mem;
const readUntilDelimiterOrEof = std.io.getStdIn().reader().readUntilDelimiterOrEof;
const stdout = std.io.getStdOut().writer();
const exit = std.process.exit;
const ChildProcess = std.ChildProcess;
const ArrayList = std.ArrayList;

const Error = error{
    ClearFailed,
    CommandFailed,
    UnkownCommand,
    EmptyCommand,
};

// split arguments by white space
fn get_args(cmd: []const u8) !?[]const []const u8 {
    if (cmd.len == 0) {
        return null;
    }

    // convert iterator to an array of strings
    var args = ArrayList([]const u8).init(std.heap.page_allocator);
    defer args.deinit();
    var splits = mem.split(u8, cmd, " ");
    while (splits.next()) |string| {
        try args.append(string);
    }
    return args.toOwnedSlice();
}

// evulate commands
fn evulate_cmd(args: []const []const u8) !void {
    if (args.len == 0) {
        return Error.EmptyCommand;
    }
    // `clear` and `exit` are builtin commands
    else if (mem.eql(u8, args[0], "clear")) {
        stdout.writeAll("\x1b[1;1H\x1b[2J") catch return Error.ClearFailed;
    } else if (mem.eql(u8, args[0], "exit")) {
        exit(0);
    } else {
        // execute command
        const res = ChildProcess.exec(.{ .allocator = std.heap.page_allocator, .argv = args }) catch |err| {
            switch (err) {
                ChildProcess.SpawnError.FileNotFound => return Error.UnkownCommand,
                else => {
                    try stdout.writeAll(@errorName(err));
                    return Error.CommandFailed;
                },
            }
        };
        // write output
        try stdout.writeAll(res.stdout);
    }
}

pub fn main() !void {
    var cmd_buf: [1024]u8 = undefined;
    while (true) {
        try stdout.writeAll("\x1b[92;1m$ \x1b[0m"); // $
        if (readUntilDelimiterOrEof(&cmd_buf, '\n') catch |err| {
            try stdout.print("Unable to parse command: {s}\n", .{@errorName(err)});
            continue;
        }) |line| {
            const actual_line = mem.trim(u8, line, "\r\n ");
            if (try get_args(actual_line)) |args| {
                evulate_cmd(args) catch |err| {
                    if (err == Error.UnkownCommand) {
                        stdout.print("Unkown Command `{s}`\n", .{actual_line}) catch {};
                    } else {
                        return err;
                    }
                };
            }
        }
    }
}
```
