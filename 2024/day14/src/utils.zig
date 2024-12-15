const std = @import("std");

const Coord = @import("../../common.zig").Coord;

pub fn getNumbers(input: []const u8) struct { isize, isize, isize, isize } {
    var parts = std.mem.splitSequence(u8, input, " ");
    var position = std.mem.splitSequence(u8, parts.first()[2..], ",");
    var velocity = std.mem.splitSequence(u8, parts.rest()[2..], ",");

    return .{
        std.fmt.parseInt(isize, position.first(), 10) catch 0,
        std.fmt.parseInt(isize, position.rest(), 10) catch 0,
        std.fmt.parseInt(isize, velocity.first(), 10) catch 0,
        std.fmt.parseInt(isize, velocity.rest(), 10) catch 0,
    };
}
