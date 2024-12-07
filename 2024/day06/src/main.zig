const std = @import("std");
const common = @import("../../common.zig");
const utils = @import("utils.zig");

const Map = @import("map.zig").Map;

fn findPaths(allocator: std.mem.Allocator, input: []const u8) !struct { usize, usize } {
    var map = try Map.init(allocator, input);
    defer map.deinit();

    var total_distinct_positions: usize = undefined;
    var total_obstruction_positions: usize = undefined;

    const distinct_positions = try map.traverse(map.starting_position, .{ .x = -1, .y = -1 });
    defer allocator.free(distinct_positions);

    total_distinct_positions = distinct_positions.len;
    total_obstruction_positions = 0;

    for (distinct_positions) |p| {
        const obstruction_positions = try map.traverse(map.starting_position, p);
        defer allocator.free(obstruction_positions);

        total_obstruction_positions += if (obstruction_positions.len == 0) 1 else 0;
    }

    return .{ total_distinct_positions, total_obstruction_positions };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day06/inputs/input.txt", 17 * 1024);
    defer allocator.free(input);

    const total_distinct_positions, const total_obstruction_positions = try findPaths(allocator, input);

    std.debug.print("Total distinct positions: {d}\n", .{total_distinct_positions});
    std.debug.print("Total obstruction positions: {d}\n", .{total_obstruction_positions});
}

pub fn runTests(alloctor: std.mem.Allocator) !void {
    try testExample1(alloctor);
    try testExample2(alloctor);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day06/inputs/demo_1.txt", 128);
    defer allocator.free(input);

    const p1, _ = try findPaths(allocator, input);

    try std.testing.expectEqual(41, p1);
}

fn testExample2(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day06/inputs/demo_2.txt", 128);
    defer allocator.free(input);

    _, const p2 = try findPaths(allocator, input);

    try std.testing.expectEqual(6, p2);
}
