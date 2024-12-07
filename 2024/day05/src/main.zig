const std = @import("std");
const common = @import("../../common.zig");
const utils = @import("utils.zig");

const Manual = @import("manual.zig").Manual;

fn correctMiddlePages(allocator: std.mem.Allocator, ordering: []const u8, updates: []const u8) !u32 {
    var manual = try Manual.init(allocator, ordering, updates);
    defer manual.deinit();

    var total: u32 = 0;

    for (manual.original_sections, manual.sorted_sections) |os, ss| {
        total += if (std.mem.eql(u8, os, ss)) ss[ss.len / 2] else 0;
    }

    return total;
}

fn incorrectMiddlePages(allocator: std.mem.Allocator, ordering: []const u8, updates: []const u8) !u32 {
    var manual = try Manual.init(allocator, ordering, updates);
    defer manual.deinit();

    var total: u32 = 0;

    for (manual.original_sections, manual.sorted_sections) |os, ss| {
        total += if (std.mem.eql(u8, os, ss)) 0 else ss[ss.len / 2];
    }

    return total;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day05/inputs/input.txt", 16 * 1024);
    defer allocator.free(input);

    const ordering, const updates = utils.splitOnceBy(u8, input, "\n\n");

    const correct_pages = try correctMiddlePages(allocator, ordering, updates);
    const incorrect_pages = try incorrectMiddlePages(allocator, ordering, updates);

    std.debug.print("Correct middle pages: {d}\n", .{correct_pages});
    std.debug.print("Incorrect middle pages: {d}\n", .{incorrect_pages});
}

pub fn runTests(alloctor: std.mem.Allocator) !void {
    try testExample1(alloctor);
    try testExample2(alloctor);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day05/inputs/demo_1.txt", 256);
    defer allocator.free(input);

    const ordering, const updates = utils.splitOnceBy(u8, input, "\n\n");

    const middle_pages = try correctMiddlePages(allocator, ordering, updates);
    try std.testing.expectEqual(143, middle_pages);
}

fn testExample2(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day05/inputs/demo_2.txt", 256);
    defer allocator.free(input);

    const ordering, const updates = utils.splitOnceBy(u8, input, "\n\n");

    const middle_pages = try incorrectMiddlePages(allocator, ordering, updates);
    try std.testing.expectEqual(123, middle_pages);
}
