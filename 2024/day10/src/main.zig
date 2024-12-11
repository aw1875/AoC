const std = @import("std");
const common = @import("../../common.zig");

const utils = @import("utils.zig");

const Coord = common.Coord;
const Grid = common.Grid;

const Map = struct {
    allocator: std.mem.Allocator,
    grid: Grid(u8),
    trailheads: []Coord,

    pub fn init(allocator: std.mem.Allocator, input: []const u8) !Map {
        const grid = try Grid(u8).init(allocator, input);

        var trailheads = std.ArrayList(Coord).init(allocator);
        defer trailheads.deinit();

        for (grid.cells, 0..) |cell, i| {
            for (cell, 0..) |char, j| {
                if (char == '0') {
                    try trailheads.append(Coord.init(j, i));
                }
            }
        }

        return Map{ .allocator = allocator, .grid = grid, .trailheads = try trailheads.toOwnedSlice() };
    }

    pub fn deinit(self: *Map) void {
        self.grid.deinit();
        self.allocator.free(self.trailheads);
    }

    pub fn checkTrailhead(self: *Map, coord: Coord, seen: *std.AutoHashMap(u64, void), get_all: bool) !usize {
        if (self.grid.get(coord) == '9') {
            const hashed_key = utils.hashedKey(coord);

            var unique: usize = 0;
            if (!seen.contains(hashed_key)) {
                try seen.put(hashed_key, {});
                unique = 1;
            }

            return if (get_all) 1 else unique;
        }

        var paths: usize = 0;

        const next_step = self.grid.get(coord).? + 1;
        if (self.grid.get(Coord{ .x = coord.x, .y = coord.y - 1 }) == next_step) {
            paths += try self.checkTrailhead(Coord{ .x = coord.x, .y = coord.y - 1 }, seen, get_all);
        }
        if (self.grid.get(Coord{ .x = coord.x, .y = coord.y + 1 }) == next_step) {
            paths += try self.checkTrailhead(Coord{ .x = coord.x, .y = coord.y + 1 }, seen, get_all);
        }
        if (self.grid.get(Coord{ .x = coord.x - 1, .y = coord.y }) == next_step) {
            paths += try self.checkTrailhead(Coord{ .x = coord.x - 1, .y = coord.y }, seen, get_all);
        }
        if (self.grid.get(Coord{ .x = coord.x + 1, .y = coord.y }) == next_step) {
            paths += try self.checkTrailhead(Coord{ .x = coord.x + 1, .y = coord.y }, seen, get_all);
        }

        return paths;
    }
};

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
