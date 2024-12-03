const std = @import("std");

pub fn getInput(allocator: std.mem.Allocator, path: []const u8, buff_size: anytype) ![]const u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var buffer = try allocator.alloc(u8, buff_size);
    defer allocator.free(buffer);

    const len = try file.readAll(buffer);

    const input = try allocator.dupe(u8, std.mem.trim(u8, buffer[0..len], "\n"));
    return input;
}
