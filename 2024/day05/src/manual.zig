const std = @import("std");
const utils = @import("utils.zig");

pub const Manual = struct {
    allocator: std.mem.Allocator,
    original_sections: [][]u8,
    sorted_sections: [][]u8,

    pub fn init(allocator: std.mem.Allocator, ordering_rules: []const u8, page_numbers: []const u8) !Manual {
        var order = std.ArrayList([2]u8).init(allocator);
        defer order.deinit();

        var lines = std.mem.splitSequence(u8, ordering_rules, "\n");
        while (lines.next()) |line| {
            const first_page, const second_page = utils.splitOnceBy(u8, line, "|");
            try order.append(.{ try std.fmt.parseInt(u8, first_page, 10), try std.fmt.parseInt(u8, second_page, 10) });
        }

        var original_sections = std.ArrayList([]u8).init(allocator);
        defer original_sections.deinit();

        var sorted_sections = std.ArrayList([]u8).init(allocator);
        defer sorted_sections.deinit();

        lines = std.mem.splitSequence(u8, page_numbers, "\n");
        while (lines.next()) |line| {
            var line_pages = std.mem.splitSequence(u8, line, ",");

            var original_pages = std.ArrayList(u8).init(allocator);
            defer original_pages.deinit();

            var pages = std.ArrayList(u8).init(allocator);
            defer pages.deinit();

            while (line_pages.next()) |line_page| {
                const page = try std.fmt.parseInt(u8, line_page, 10);
                try original_pages.append(page);
                try pages.append(page);
            }

            try original_sections.append(try original_pages.toOwnedSlice());
            try sorted_sections.append(try pages.toOwnedSlice());
        }

        for (sorted_sections.items) |*pages| {
            std.mem.sort(u8, pages.*, order.items, comparator);
        }

        return Manual{
            .allocator = allocator,
            .original_sections = try original_sections.toOwnedSlice(),
            .sorted_sections = try sorted_sections.toOwnedSlice(),
        };
    }

    pub fn deinit(self: *Manual) void {
        for (self.original_sections, self.sorted_sections) |os, ss| {
            self.allocator.free(os);
            self.allocator.free(ss);
        }

        self.allocator.free(self.original_sections);
        self.allocator.free(self.sorted_sections);
    }

    fn comparator(context: []const [2]u8, a: u8, b: u8) bool {
        for (context, 0..) |ordering, i| {
            if ((ordering[0] == a and ordering[1] == b) or (ordering[0] == b and ordering[1] == a)) {
                return context[i][0] == a;
            }
        }

        return false;
    }
};
