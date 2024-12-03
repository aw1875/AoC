const std = @import("std");

const Spots = @import("spots.zig").Spots;

pub fn getSpots(allocator: std.mem.Allocator, input: []const u8) !Spots {
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
