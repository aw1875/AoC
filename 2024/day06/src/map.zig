const std = @import("std");
const utils = @import("utils.zig");

const direction = @import("direction.zig");
const Direction = direction.Direction;
const Coord = direction.Coord;

pub const Map = struct {
    allocator: std.mem.Allocator,

    grid: [][]u8,
    rows: usize,
    cols: usize,

    direction: Direction,
    starting_position: Coord,
    visited: std.AutoHashMap(Coord, void),

    pub fn init(allocator: std.mem.Allocator, input: []const u8) !Map {
        var obstructions = std.ArrayList([]u8).init(allocator);
        defer obstructions.deinit();

        var row: u8 = 0;
        var start_pos: Coord = undefined;

        var lines = std.mem.splitSequence(u8, input, "\n");
        while (lines.next()) |line| : (row += 1) {
            var col = try allocator.alloc(u8, line.len);
            @memcpy(col, line);

            if (std.mem.indexOf(u8, line, "^")) |start| {
                start_pos = .{ .x = @intCast(start), .y = @intCast(row) };
                col[start] = '.';
            }

            try obstructions.append(col);
        }

        const grid = try obstructions.toOwnedSlice();

        return .{
            .allocator = allocator,
            .grid = grid,
            .rows = row,
            .cols = grid[0].len,
            .direction = .Up,
            .starting_position = .{ .x = start_pos.x, .y = start_pos.y },
            .visited = std.AutoHashMap(Coord, void).init(allocator),
        };
    }

    pub fn deinit(self: *Map) void {
        for (self.grid) |item| {
            self.allocator.free(item);
        }

        self.allocator.free(self.grid);
        self.visited.deinit();
    }

    pub fn traverse(self: *Map, start: Coord, exclude: Coord) ![]Coord {
        var result = try self.allocator.alloc(Coord, 0);

        var stops = std.AutoHashMap(u64, void).init(self.allocator);
        defer stops.deinit();

        var pos = start;
        var dir = self.direction;

        while (true) {
            const new_pos = pos.add(dir.toCoord());

            if (new_pos.y < 0 or new_pos.y >= self.rows or new_pos.x < 0 or new_pos.x >= self.cols) {
                break;
            }

            if (new_pos.equals(exclude) or self.get(new_pos) == '#') {
                const stop_key = utils.hashedKey(pos, dir);
                if (stops.contains(stop_key)) return result;

                try stops.put(stop_key, {});
                dir = dir.rotate();
            } else {
                try self.visited.put(new_pos, {});
                pos = new_pos;
            }
        }

        result = try self.allocator.alloc(Coord, self.visited.count());

        var i: usize = 0;
        var iter = self.visited.keyIterator();
        while (iter.next()) |key| : (i += 1) {
            result[i] = key.*;
        }

        return result;
    }

    fn get(self: *Map, pos: Coord) u8 {
        return self.grid[@intCast(pos.y)][@intCast(pos.x)];
    }
};
