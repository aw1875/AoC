const std = @import("std");

fn getInput(allocator: std.mem.Allocator, path: []const u8) ![]const u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var buffer: [16 * 1024]u8 = undefined;
    const len = try file.readAll(&buffer);

    const input = try allocator.dupe(u8, std.mem.trim(u8, buffer[0..len], "\n"));
    return input;
}

const Spots = struct {
    first_spots_array: []u32,
    second_spots_array: []u32,

    fn deinit(self: *Spots, allocator: std.mem.Allocator) void {
        allocator.free(self.first_spots_array);
        allocator.free(self.second_spots_array);
    }
};

fn getSpots(allocator: std.mem.Allocator, input: []const u8) !Spots {
    // Keep track of arrays for each spot
    var first_spots_array = std.ArrayList(u32).init(allocator);
    defer first_spots_array.deinit();

    var second_spots_array = std.ArrayList(u32).init(allocator);
    defer second_spots_array.deinit();

    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        var pieces = std.mem.splitScalar(u8, line, ' ');

        const first_spot = try std.fmt.parseInt(u32, pieces.first(), 10);
        const second_spot = try std.fmt.parseInt(u32, std.mem.trim(u8, pieces.rest(), " "), 10);

        try first_spots_array.append(first_spot);
        try second_spots_array.append(second_spot);
    }

    const first_spots = try allocator.dupe(u32, first_spots_array.items);
    const second_spots = try allocator.dupe(u32, second_spots_array.items);

    return Spots{ .first_spots_array = first_spots, .second_spots_array = second_spots };
}

fn calculateDistance(first_spots_array: []u32, second_spots_array: []u32) !u32 {
    // Sort the spots
    std.mem.sort(u32, first_spots_array, {}, comptime std.sort.asc(u32));
    std.mem.sort(u32, second_spots_array, {}, comptime std.sort.asc(u32));

    var total_distance: u32 = 0;

    for (first_spots_array, 0..) |first_spot, i| {
        const second_spot = second_spots_array[i];
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

    const input = try getInput(allocator, "inputs/input.txt");
    defer allocator.free(input);

    var spots = try getSpots(allocator, input);
    defer spots.deinit(allocator);

    const total_distance = try calculateDistance(spots.first_spots_array, spots.second_spots_array);
    const simularity_score = try calculateSimilarityScore(allocator, spots);

    std.debug.print("Total distance: {d}\n", .{total_distance});
    std.debug.print("Similarity score: {d}\n", .{simularity_score});
}

test "Example Input 1" {
    const allocator = std.testing.allocator;

    const input = try getInput(allocator, "inputs/demo_1.txt");
    defer allocator.free(input);

    var spots = try getSpots(allocator, input);
    defer spots.deinit(allocator);

    const total_distance = try calculateDistance(spots.first_spots_array, spots.second_spots_array);

    try std.testing.expectEqual(11, total_distance);
}

test "Example Input 2" {
    const allocator = std.testing.allocator;

    const input = try getInput(allocator, "inputs/demo_2.txt");
    defer allocator.free(input);

    var spots = try getSpots(allocator, input);
    defer spots.deinit(allocator);

    const simularity_score = try calculateSimilarityScore(allocator, spots);

    try std.testing.expectEqual(31, simularity_score);
}
