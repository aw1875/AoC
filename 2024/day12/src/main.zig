const std = @import("std");
const common = @import("../../common.zig");

const Coord = common.Coord;
const Graph = common.Graph;

pub fn getTotalPrice(allocator: std.mem.Allocator, input: []const u8) !struct { usize, usize } {
    var graph = try Graph(u8).init(allocator, input);
    defer graph.deinit();

    var scanned = std.AutoHashMap(Coord, void).init(graph.allocator);
    defer scanned.deinit();

    var p1: usize = 0;
    var p2: usize = 0;

    for (0..graph.rows) |r| {
        for (0..graph.cols) |c| {
            const coord = Coord.init(c, r);
            if (scanned.contains(coord)) continue;

            if (graph.grid.get(coord)) |region| {
                const area, const perimeter, const sides = try graph.exploreRegion(coord, region, &scanned);

                p1 += area * perimeter;
                p2 += area * sides;
            }
        }
    }

    return .{ p1, p2 };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day12/inputs/input.txt", 20 * 1024);
    defer allocator.free(input);

    const part1, const part2 = try getTotalPrice(allocator, input);

    std.debug.print("Total price (a * p): {}\n", .{part1});
    std.debug.print("Total price (a * s): {}\n", .{part2});
}

pub fn runTests(alloctor: std.mem.Allocator) !void {
    try testExample1(alloctor);
    try testExample2(alloctor);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day12/inputs/demo_1.txt", 256);
    defer allocator.free(input);

    const part1, _ = try getTotalPrice(allocator, input);
    try std.testing.expectEqual(1930, part1);
}

fn testExample2(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day12/inputs/demo_2.txt", 256);
    defer allocator.free(input);

    _, const part2 = try getTotalPrice(allocator, input);
    try std.testing.expectEqual(1206, part2);
}
