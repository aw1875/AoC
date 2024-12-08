const std = @import("std");

const Coord = @import("coord.zig");

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
    };
}
