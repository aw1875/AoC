const std = @import("std");

pub fn splitOnceBy(comptime T: type, input: []const T, delimeter: []const T) struct { []const T, []const T } {
    var iter = std.mem.splitSequence(T, input, delimeter);

    return .{ iter.first(), iter.rest() };
}
