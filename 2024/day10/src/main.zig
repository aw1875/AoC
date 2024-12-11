const std = @import("std");
const common = @import("../../common.zig");

const Map = @import("map.zig");

fn findUniqueTrailheads(allocator: std.mem.Allocator, input: []const u8) !usize {
    var map = try Map.init(allocator, input);
    defer map.deinit();

    var seen = std.AutoHashMap(u64, void).init(allocator);
    defer seen.deinit();

    var trailheads: usize = 0;
    for (map.trailheads) |trailhead| {
        trailheads += try map.checkTrailhead(trailhead, &seen, false);
        seen.clearRetainingCapacity();
    }

    return trailheads;
}

fn findAllTrailheads(allocator: std.mem.Allocator, input: []const u8) !usize {
    var map = try Map.init(allocator, input);
    defer map.deinit();

    var seen = std.AutoHashMap(u64, void).init(allocator);
    defer seen.deinit();

    var trailheads: usize = 0;
    for (map.trailheads) |trailhead| {
        trailheads += try map.checkTrailhead(trailhead, &seen, true);
        seen.clearRetainingCapacity();
    }

    return trailheads;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day10/inputs/input.txt", 20 * 1024);
    defer allocator.free(input);

    const uniqueTrailheads = try findUniqueTrailheads(allocator, input);
    const allTrailheads = try findAllTrailheads(allocator, input);

    std.debug.print("Unique Trailheads: {}\n", .{uniqueTrailheads});
    std.debug.print("All Trailheads: {}\n", .{allTrailheads});
}

pub fn runTests(alloctor: std.mem.Allocator) !void {
    try testExample1(alloctor);
    try testExample2(alloctor);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day10/inputs/demo_1.txt", 256);
    defer allocator.free(input);

    const uniqueTrailheads = try findUniqueTrailheads(allocator, input);
    try std.testing.expectEqual(36, uniqueTrailheads);
}

fn testExample2(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day10/inputs/demo_2.txt", 256);
    defer allocator.free(input);

    const allTrailheads = try findAllTrailheads(allocator, input);
    try std.testing.expectEqual(81, allTrailheads);
}
