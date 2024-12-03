const std = @import("std");

pub const Report = struct {
    levels: []u32,

    pub fn init(allocator: std.mem.Allocator, lines_str: []const u8) !Report {
        var levels_array = std.ArrayList(u32).init(allocator);
        defer levels_array.deinit();

        var lines = std.mem.splitScalar(u8, lines_str, '\n');
        while (lines.next()) |line| {
            var levels = std.mem.splitScalar(u8, line, ' ');

            while (levels.next()) |level| {
                const level_int = try std.fmt.parseInt(u32, level, 10);
                try levels_array.append(level_int);
            }
        }

        const levels = try allocator.dupe(u32, levels_array.items);

        return Report{ .levels = levels };
    }

    pub fn deinit(self: Report, allocator: std.mem.Allocator) void {
        allocator.free(self.levels);
    }
};
