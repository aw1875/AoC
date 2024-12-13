const std = @import("std");

pub fn getNumbers(input: []const u8) struct { isize, isize } {
    var parts = std.mem.splitSequence(u8, input, ": ");
    _ = parts.first();

    var numbers = std.mem.splitSequence(u8, parts.rest(), ", ");

    return .{
        std.fmt.parseInt(isize, numbers.first()[2..], 10) catch 0,
        std.fmt.parseInt(isize, numbers.rest()[2..], 10) catch 0,
    };
}
