const std = @import("std");
const common = @import("../../common.zig");
const utils = @import("utils.zig");

const Spots = @import("spots.zig").Spots;

fn calculateDistance(first_spots_array: []u32, second_spots_array: []u32) !u32 {
    std.mem.sort(u32, first_spots_array, {}, comptime std.sort.asc(u32));
    std.mem.sort(u32, second_spots_array, {}, comptime std.sort.asc(u32));

    var total_distance: u32 = 0;

    for (first_spots_array, second_spots_array) |first_spot, second_spot| {
        total_distance = if (first_spot > second_spot) total_distance + (first_spot - second_spot) else total_distance + (second_spot - first_spot);
    }

    return total_distance;
}

fn calculateSimilarityScore(allocator: std.mem.Allocator, spots: Spots) !u32 {
    var second_spots_hash = std.AutoHashMap(u32, u32).init(allocator);
    defer second_spots_hash.deinit();

    for (spots.second_spots_array) |spot| {
        if (second_spots_hash.get(spot)) |count| {
            try second_spots_hash.put(spot, count + 1);
        } else {
            try second_spots_hash.put(spot, 1);
        }
    }

    var similarity_score: u32 = 0;

    for (spots.first_spots_array) |spot| {
        if (second_spots_hash.get(spot)) |count| {
            similarity_score += spot * count;
        }
    }

    return similarity_score;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day01/inputs/input.txt", 16 * 1024);
    defer allocator.free(input);

    var spots = try utils.getSpots(allocator, input);
    defer spots.deinit(allocator);

    const total_distance = try calculateDistance(spots.first_spots_array, spots.second_spots_array);
    const simularity_score = try calculateSimilarityScore(allocator, spots);

    std.debug.print("Total distance: {d}\n", .{total_distance});
    std.debug.print("Similarity score: {d}\n", .{simularity_score});
}

pub fn runTests(alloctor: std.mem.Allocator) !void {
    try testExample1(alloctor);
    try testExample2(alloctor);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day01/inputs/demo_1.txt", 64);
    defer allocator.free(input);

    var spots = try utils.getSpots(allocator, input);
    defer spots.deinit(allocator);

    const total_distance = try calculateDistance(spots.first_spots_array, spots.second_spots_array);

    try std.testing.expectEqual(11, total_distance);
}

fn testExample2(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day01/inputs/demo_2.txt", 64);
    defer allocator.free(input);

    var spots = try utils.getSpots(allocator, input);
    defer spots.deinit(allocator);

    const simularity_score = try calculateSimilarityScore(allocator, spots);

    try std.testing.expectEqual(31, simularity_score);
}
