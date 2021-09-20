const std = @import("std");
const ChildProcess = std.ChildProcess;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator;
const tagName = std.meta.tagName;

pub fn main() anyerror!void {
  var gpa = GeneralPurposeAllocator(.{}){};
  var allocator = &gpa.allocator;
  defer _= gpa.deinit();

  const args = [_][]const u8{ "ls", "-al" };

  var process = try ChildProcess.init(&args, allocator);
  defer process.deinit();

  std.debug.print("Running command: {s}\n", .{args});
  try process.spawn();
  const ret_val = try process.wait();
  std.debug.print("The command returned: {s}\n", .{tagName(ret_val)});
}
