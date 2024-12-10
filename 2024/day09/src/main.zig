const std = @import("std");
const common = @import("../../common.zig");

const utils = @import("utils.zig");

fn fragmentChecksum(allocator: std.mem.Allocator, input: []const u8) !usize {
    var disk = std.ArrayList(isize).init(allocator);
    defer disk.deinit();

    for (input, 0..) |char, i| {
        const file_id: isize = @intCast(@divFloor(i, 2));
        try disk.appendNTimes(if (i % 2 == 0) file_id else -1, char - '0');
    }

    var head = std.mem.indexOfScalar(isize, disk.items, -1).?;
    var tail = std.mem.lastIndexOfNone(isize, disk.items, &.{-1}).?;

    while (head < tail) {
        std.mem.swap(isize, &disk.items[head], &disk.items[tail]);

        head = std.mem.indexOfScalar(isize, disk.items, -1) orelse break;
        tail = std.mem.lastIndexOfNone(isize, disk.items, &.{-1}) orelse break;
    }

    return utils.calculateChecksum(disk.items, false);
}

fn compactChecksum(allocator: std.mem.Allocator, input: []const u8) !usize {
    var disk = std.ArrayList(isize).init(allocator);
    defer disk.deinit();

    for (input, 0..) |char, i| {
        const file_id: isize = @intCast(@divFloor(i, 2));
        try disk.appendNTimes(if (i % 2 == 0) file_id else -1, char - '0');
    }

    var file_end: usize = disk.items.len;
    while (file_end > 0) {
        file_end = std.mem.lastIndexOfNone(isize, disk.items[0..file_end], &.{-1}) orelse break;

        const file_start = std.mem.lastIndexOfNone(isize, disk.items[0..file_end], &.{disk.items[file_end]}) orelse break;
        var file = disk.items[file_start + 1 .. file_end + 1];

        file_end = file_start + 1;

        const empty_space_start = std.mem.indexOf(isize, disk.items[0..file_end], (&[_]isize{-1} ** 10)[0..file.len]) orelse continue;
        const empty_space = disk.items[empty_space_start .. empty_space_start + file.len];

        var swap_index: usize = 0;
        while (swap_index < file.len) : (swap_index += 1) {
            std.mem.swap(isize, &file[swap_index], &empty_space[swap_index]);
        }
    }

    return utils.calculateChecksum(disk.items, true);
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day09/inputs/input.txt", 20 * 1024);
    defer allocator.free(input);

    const fragment_checksum = try fragmentChecksum(allocator, input);
    const compact_checksum = try compactChecksum(allocator, input);

    std.debug.print("Fragment Checksum: {}\n", .{fragment_checksum});
    std.debug.print("Compact Checksum: {}\n", .{compact_checksum});
}

pub fn runTests(alloctor: std.mem.Allocator) !void {
    try testExample1(alloctor);
    try testExample2(alloctor);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day09/inputs/demo_1.txt", 256);
    defer allocator.free(input);

    const checksum = try fragmentChecksum(allocator, input);
    try std.testing.expectEqual(1928, checksum);
}

fn testExample2(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day09/inputs/demo_2.txt", 256);
    defer allocator.free(input);

    const checksum = try compactChecksum(allocator, input);
    try std.testing.expectEqual(2858, checksum);
}
