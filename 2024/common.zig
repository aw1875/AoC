const std = @import("std");

pub fn getInput(allocator: std.mem.Allocator, path: []const u8, buff_size: anytype) ![]const u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var buffer = try allocator.alloc(u8, buff_size);
    defer allocator.free(buffer);

    const len = try file.readAll(buffer);

    const input = try allocator.dupe(u8, std.mem.trim(u8, buffer[0..len], "\n"));
    return input;
}

pub const Coord = struct {
    x: isize,
    y: isize,

    pub fn init(x: usize, y: usize) Coord {
        return .{ .x = @intCast(x), .y = @intCast(y) };
    }

    pub fn add(self: Coord, other: Coord) Coord {
        return .{ .x = self.x + other.x, .y = self.y + other.y };
    }

    pub fn sub(self: Coord, other: Coord) Coord {
        return .{ .x = self.x - other.x, .y = self.y - other.y };
    }

    pub fn getDelta(self: Coord, other: Coord) Coord {
        return .{ .x = self.x - other.x, .y = self.y - other.y };
    }

    pub fn simplify(self: Coord, gcd: isize) Coord {
        return .{ .x = @divFloor(self.x, gcd), .y = @divFloor(self.y, gcd) };
    }
};

pub fn Grid(comptime T: type) type {
    return struct {
        const GridStruct = @This();

        allocator: std.mem.Allocator,
        rows: usize,
        cols: usize,
        cells: [][]T,

        pub fn init(allocator: std.mem.Allocator, input: []const u8) !GridStruct {
            var cells = std.ArrayList([]T).init(allocator);
            defer cells.deinit();

            var rows: usize = 0;
            var cols: usize = 0;

            var lines = std.mem.splitSequence(u8, input, "\n");
            while (lines.next()) |line| : (rows += 1) {
                cols = @max(cols, line.len);

                const col = try allocator.alloc(T, line.len);
                @memcpy(col, line);

                try cells.append(col);
            }

            return GridStruct{
                .allocator = allocator,
                .rows = rows,
                .cols = cols,
                .cells = try cells.toOwnedSlice(),
            };
        }

        pub fn deinit(self: *GridStruct) void {
            for (self.cells) |row| {
                self.allocator.free(row);
            }

            self.allocator.free(self.cells);
        }

        pub fn isInGrid(self: *GridStruct, coord: Coord) bool {
            return (coord.x < @as(isize, @intCast(self.cols)) and coord.x >= 0) and (coord.y < @as(isize, @intCast(self.rows)) and coord.y >= 0);
        }

        pub fn get(self: *GridStruct, coord: Coord) ?T {
            if (!self.isInGrid(coord)) return null;

            return self.cells[@intCast(coord.y)][@intCast(coord.x)];
        }
    };
}
