const std = @import("std");
const utils = @import("utils.zig");

pub const Grid = struct {
    allocator: std.mem.Allocator,
    rows: usize,
    cols: usize,
    cells: std.AutoHashMap(u64, u8),

    pub fn init(allocator: std.mem.Allocator, input: []const u8) !Grid {
        var grid = std.AutoHashMap(u64, u8).init(allocator);

        var rows: usize = 0;
        var cols: usize = 0;

        var lines = std.mem.splitSequence(u8, input, "\n");
        while (lines.next()) |line| : (rows += 1) {
            if (line.len == 0) break;
            cols = @max(cols, line.len);

            for (line, 0..) |cell, i| {
                try grid.put(utils.hashedKey(@intCast(rows), @intCast(i)), cell);
            }
        }

        return Grid{ .allocator = allocator, .rows = rows, .cols = cols, .cells = grid };
    }

    pub fn deinit(self: *Grid) void {
        self.cells.deinit();
    }
};
