const std = @import("std");
const common = @import("../../common.zig");

const utils = @import("utils.zig");

const Coord = common.Coord;
const Grid = common.Grid;

fn getTotalAntinodes(allocator: std.mem.Allocator, grid: *Grid(u8), is_part_2: bool) !usize {
    var antennas = std.AutoHashMap(u8, std.ArrayList(Coord)).init(allocator);
    defer antennas.deinit();

    for (grid.cells, 0..) |row, r| {
        for (0..row.len) |c| {
            const char = grid.cells[r][c];
            if (char == '.') continue;

            const result = try antennas.getOrPut(char);
            if (!result.found_existing) {
                result.value_ptr.* = std.ArrayList(Coord).init(allocator);
            }

            try result.value_ptr.*.append(Coord.init(c, r));
        }
    }

    var antinodes = std.AutoHashMap(u64, void).init(allocator);
    defer antinodes.deinit();

    var iter = antennas.iterator();
    while (iter.next()) |antenna| {
        for (0..antenna.value_ptr.*.items.len) |i| {
            for (i + 1..antenna.value_ptr.*.items.len) |j| {
                const coord1 = antenna.value_ptr.*.items[i];
                const coord2 = antenna.value_ptr.*.items[j];

                const delta = coord2.getDelta(coord1);
                const gcd: isize = @intCast(std.math.gcd(@abs(delta.x), @abs(delta.y)));
                const simplified = delta.simplify(gcd);

                var a1 = if (!is_part_2) Coord{ .x = coord1.x - delta.x, .y = coord1.y - delta.y } else Coord{ .x = coord1.x + delta.x, .y = coord1.y + delta.y };
                var a2 = if (!is_part_2) Coord{ .x = coord2.x + delta.x, .y = coord2.y + delta.y } else Coord{ .x = coord2.x - delta.x, .y = coord2.y - delta.y };

                if (!is_part_2) {
                    if (grid.isInGrid(a1)) try antinodes.put(utils.hashedKey(a1), {});
                    if (grid.isInGrid(a2)) try antinodes.put(utils.hashedKey(a2), {});
                } else {
                    while (grid.isInGrid(a1)) {
                        try antinodes.put(utils.hashedKey(a1), {});
                        a1 = a1.add(simplified);
                    }

                    while (grid.isInGrid(a2)) {
                        try antinodes.put(utils.hashedKey(a2), {});
                        a2 = a2.sub(simplified);
                    }
                }
            }
        }

        antenna.value_ptr.*.deinit();
    }

    return antinodes.count();
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day08/inputs/input.txt", 3 * 1024);
    defer allocator.free(input);

    var grid = try Grid(u8).init(allocator, input);
    defer grid.deinit();

    const antinodes = try getTotalAntinodes(allocator, &grid, false);
    const antinodes2 = try getTotalAntinodes(allocator, &grid, true);

    std.debug.print("Unique antinodes: {d}\n", .{antinodes});
    std.debug.print("Unique antinodes updated: {d}\n", .{antinodes2});
}

pub fn runTests(alloctor: std.mem.Allocator) !void {
    try testExample1(alloctor);
    try testExample2(alloctor);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day08/inputs/demo_1.txt", 256);
    defer allocator.free(input);

    var grid = try Grid(u8).init(allocator, input);
    defer grid.deinit();

    const antinodes = try getTotalAntinodes(allocator, &grid, false);
    try std.testing.expectEqual(14, antinodes);
}

fn testExample2(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day08/inputs/demo_2.txt", 256);
    defer allocator.free(input);

    var grid = try Grid(u8).init(allocator, input);
    defer grid.deinit();

    const antinodes = try getTotalAntinodes(allocator, &grid, true);
    try std.testing.expectEqual(34, antinodes);
}
