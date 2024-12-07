const std = @import("std");

pub fn splitOnceBy(comptime T: type, input: []const T, delimeter: []const T) struct { []const T, []const T } {
    var iter = std.mem.splitSequence(T, input, delimeter);

    return .{ iter.first(), iter.rest() };
}

pub fn collectNumbers(allocator: std.mem.Allocator, input: []const u8) ![]usize {
    var numbers = std.ArrayList(usize).init(allocator);
    defer numbers.deinit();

    var iter = std.mem.splitSequence(u8, input, " ");
    while (iter.next()) |item| {
        const number = try std.fmt.parseInt(usize, std.mem.trim(u8, item, " "), 10);
        try numbers.append(number);
    }

    return try numbers.toOwnedSlice();
}

pub fn isValid2Ops(target: usize, current: usize, numbers: []usize) bool {
    if (current > target) return false;
    if (numbers.len == 0) return current == target;

    return isValid2Ops(target, current + numbers[0], numbers[1..]) or isValid2Ops(target, current * numbers[0], numbers[1..]);
}

// using string concats and then parsing them back took insanely long
fn concat(a: usize, b: usize) usize {
    return a * std.math.pow(usize, 10, if (b == 0) 1 else std.math.log10_int(b) + 1) + b;
}

pub fn isValid3Ops(target: usize, current: usize, numbers: []usize) bool {
    if (current > target) return false;
    if (numbers.len == 0) return current == target;

    return isValid3Ops(target, current + numbers[0], numbers[1..]) or
        isValid3Ops(target, current * numbers[0], numbers[1..]) or
        isValid3Ops(target, concat(current, numbers[0]), numbers[1..]);
}
