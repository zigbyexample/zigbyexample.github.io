const std = @import("std");
const mem = std.mem;
const stdin = std.io.getStdIn().reader();
const stderr = std.io.getStdOut().writer();
const exit = std.process.exit;
const childProcess = std.ChildProcess;
const FileNotFound = childProcess.SpawnError.FileNotFound;
const ArrayList = std.ArrayList;

const Error = error{
    ClearFailed,
    CommandFailed,
    UnkownCommand,
    EmptyCommand,
};

fn get_args(cmd: []const u8) !?[]const []const u8 {
    if (cmd.len == 0) {
        return null;
    }
    var args = ArrayList([]const u8).init(std.heap.page_allocator);
    defer args.deinit();
    var splits = mem.split(u8, cmd, " ");
    while (splits.next()) |string| {
        try args.append(string);
    }
    return args.toOwnedSlice();
}

fn evulate_cmd(args: []const []const u8) Error!void {
    if (args.len == 0) {
        return Error.EmptyCommand;
    } else if (mem.eql(u8, args[0], "clear")) {
        stderr.writeAll("\x1b[1;1H\x1b[2J") catch return Error.ClearFailed;
    } else if (mem.eql(u8, args[0], "exit")) {
        exit(0);
    } else {
        const res = childProcess.exec(.{ .allocator = std.heap.page_allocator, .argv = args }) catch |err| {
            switch (err) {
                FileNotFound => return Error.UnkownCommand,
                else => {
                    stderr.writeAll(@errorName(err)) catch {};
                    return Error.CommandFailed;
                },
            }
        };
        stderr.writeAll(res.stdout) catch {};
    }
}

pub fn main() !void {
    var repl_buf: [1024]u8 = undefined;
    while (true) {
        try stderr.writeAll("\x1b[92;1m$ \x1b[0m");
        if (stdin.readUntilDelimiterOrEof(&repl_buf, '\n') catch |err| {
            try stderr.print("\nUnable to parse command: {s}\n", .{@errorName(err)});
            continue;
        }) |line| {
            const actual_line = mem.trimRight(u8, line, "\r\n ");
            if (try get_args(actual_line)) |args| {
                evulate_cmd(args) catch |err| {
                    if (err == Error.UnkownCommand) {
                        stderr.print("Unkown Command `{s}`\n", .{actual_line}) catch {};
                    } else {
                        return err;
                    }
                };
            }
        }
    }
}
