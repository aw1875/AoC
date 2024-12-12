const std = @import("std");
const common = @import("../../common.zig");

const utils = @import("utils.zig");

const CacheEntry = struct { usize, usize };

fn performBlinks(allocator: std.mem.Allocator, stone: usize, blinks_remaining: usize, cache: *std.AutoHashMap(CacheEntry, usize)) !usize {
    if (cache.get(.{ stone, blinks_remaining })) |count| return count;
    if (blinks_remaining == 0) return 1;

    // If the stone is engraved with the number 0, it is replaced by a stone engraved with the number 1.
    if (stone == 0) return try performBlinks(allocator, 1, blinks_remaining - 1, cache);

    // If the stone is engraved with a number that has an even number of digits, it is replaced by two stones
    const length = utils.digitLength(stone);
    if (length % 2 == 0) {
        const left, const right = utils.splitNumber(stone, length);

        const count = try performBlinks(allocator, left, blinks_remaining - 1, cache) + try performBlinks(allocator, right, blinks_remaining - 1, cache);
        try cache.put(.{ stone, blinks_remaining }, count);

        return count;
    }

    // If none of the other rules apply, the stone is replaced by a new stone; the old stone's number multiplied by 2024 is engraved on the new stone
    return try performBlinks(allocator, stone * 2024, blinks_remaining - 1, cache);
}

fn countStones(allocator: std.mem.Allocator, input: []const u8, blinks: usize) !usize {
    var cache = std.AutoHashMap(CacheEntry, usize).init(allocator);
    defer cache.deinit();

    var total: usize = 0;

    var stones = std.mem.splitSequence(u8, input, " ");
    while (stones.next()) |stone| {
        total += try performBlinks(allocator, try std.fmt.parseInt(usize, stone, 10), blinks, &cache);
    }

    return total;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day11/inputs/input.txt", 1 * 1024);
    defer allocator.free(input);

    const total25 = try countStones(allocator, input, 25);
    const total75 = try countStones(allocator, input, 75);

    std.debug.print("Total after 25 blinks: {}\n", .{total25});
    std.debug.print("Total after 75 blinks: {}\n", .{total75});
}

pub fn runTests(alloctor: std.mem.Allocator) !void {
    try testExample1(alloctor);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day11/inputs/demo_1.txt", 256);
    defer allocator.free(input);

    const total25 = try countStones(allocator, input, 25);
    try std.testing.expectEqual(55312, total25);
}
