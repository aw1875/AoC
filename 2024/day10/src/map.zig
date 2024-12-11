const std = @import("std");
const common = @import("../../common.zig");

const utils = @import("utils.zig");

const Coord = common.Coord;
const Grid = common.Grid;

const Map = @This();

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
