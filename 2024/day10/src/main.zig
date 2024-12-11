const std = @import("std");
const common = @import("../../common.zig");

const Map = @import("map.zig");

fn findTrailheads(allocator: std.mem.Allocator, input: []const u8) !struct { usize, usize } {
    var map = try Map.init(allocator, input);
    defer map.deinit();

    var seen = std.AutoHashMap(u64, void).init(allocator);
    defer seen.deinit();

    var unique_trailheads: usize = 0;
    var all_trailheads: usize = 0;
    for (map.trailheads) |trailhead| {
        unique_trailheads += try map.checkTrailhead(trailhead, &seen, false);
        all_trailheads += try map.checkTrailhead(trailhead, &seen, true);

        seen.clearRetainingCapacity();
    }

    return .{ unique_trailheads, all_trailheads };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day10/inputs/input.txt", 20 * 1024);
    defer allocator.free(input);

    const unique_trailheads, const all_trailheads = try findTrailheads(allocator, input);

    std.debug.print("Unique Trailheads: {}\n", .{unique_trailheads});
    std.debug.print("All Trailheads: {}\n", .{all_trailheads});
}

pub fn runTests(alloctor: std.mem.Allocator) !void {
    try testExample1(alloctor);
    try testExample2(alloctor);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day10/inputs/demo_1.txt", 256);
    defer allocator.free(input);

    const unique_trailheads, _ = try findTrailheads(allocator, input);
    try std.testing.expectEqual(36, unique_trailheads);
}

fn testExample2(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day10/inputs/demo_2.txt", 256);
    defer allocator.free(input);

    _, const all_trailheads = try findTrailheads(allocator, input);
    try std.testing.expectEqual(81, all_trailheads);
}
