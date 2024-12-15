const std = @import("std");
const common = @import("../../common.zig");

const utils = @import("utils.zig");

const Coord = common.Coord;
const Grid = common.Grid;

pub fn calculateSafetyFactor(allocator: std.mem.Allocator, input: []const u8, width: isize, height: isize) !usize {
    var robots = std.ArrayList(Coord).init(allocator);
    defer robots.deinit();

    var lines = std.mem.splitSequence(u8, input, "\n");
    while (lines.next()) |line| {
        const px, const py, const vx, const vy = utils.getNumbers(line);

        var pos = Coord{ .x = px, .y = py };
        const vel = Coord{ .x = vx, .y = vy };

        for (0..100) |_| {
            pos = Coord{
                .x = @mod((pos.x + vel.x + width), width),
                .y = @mod((pos.y + vel.y + height), height),
            };
        }

        try robots.append(pos);
    }

    var robotCountPerQuadrant = [_]usize{ 0, 0, 0, 0 };
    for (robots.items) |robot| {
        if (robot.x == @divTrunc(width, 2) or robot.y == @divTrunc(height, 2)) continue;
        if (robot.x < @divTrunc(width, 2) and robot.y < @divTrunc(height, 2)) {
            robotCountPerQuadrant[0] += 1;
        } else if (robot.x >= @divTrunc(width, 2) and robot.y < @divTrunc(height, 2)) {
            robotCountPerQuadrant[1] += 1;
        } else if (robot.x < @divTrunc(width, 2) and robot.y >= @divTrunc(height, 2)) {
            robotCountPerQuadrant[2] += 1;
        } else {
            robotCountPerQuadrant[3] += 1;
        }
    }

    return robotCountPerQuadrant[0] * robotCountPerQuadrant[1] * robotCountPerQuadrant[2] * robotCountPerQuadrant[3];
}

const Robot = struct {
    pos: Coord,
    vel: Coord,
};

pub fn calculateChristmasTree(allocator: std.mem.Allocator, input: []const u8, width: isize, height: isize) !usize {
    var robots = std.ArrayList(Robot).init(allocator);
    defer robots.deinit();

    var lines = std.mem.splitSequence(u8, input, "\n");
    while (lines.next()) |line| {
        const px, const py, const vx, const vy = utils.getNumbers(line);

        var pos = Coord{ .x = px, .y = py };
        const vel = Coord{ .x = vx, .y = vy };

        for (0..100) |_| {
            pos = Coord{
                .x = @mod((pos.x + vel.x + width), width),
                .y = @mod((pos.y + vel.y + height), height),
            };
        }

        try robots.append(Robot{ .pos = pos, .vel = vel });
    }

    for (0..@as(usize, @intCast(width * height))) |steps| {
        for (robots.items) |*robot| {
            robot.*.pos = Coord{
                .x = @mod((robot.*.pos.x + robot.*.vel.x + width), width),
                .y = @mod((robot.*.pos.y + robot.*.vel.y + height), height),
            };
        }

        var robotCountPerQuadrant = [_]usize{ 0, 0, 0, 0 };
        for (robots.items) |robot| {
            if (robot.pos.x == @divTrunc(width, 2) or robot.pos.y == @divTrunc(height, 2)) continue;
            if (robot.pos.x < @divTrunc(width, 2) and robot.pos.y < @divTrunc(height, 2)) {
                robotCountPerQuadrant[0] += 1;
            } else if (robot.pos.x >= @divTrunc(width, 2) and robot.pos.y < @divTrunc(height, 2)) {
                robotCountPerQuadrant[1] += 1;
            } else if (robot.pos.x < @divTrunc(width, 2) and robot.pos.y >= @divTrunc(height, 2)) {
                robotCountPerQuadrant[2] += 1;
            } else {
                robotCountPerQuadrant[3] += 1;
            }
        }

        // If more than half of the robots are in one quadrant, we can stop
        if (std.mem.max(usize, &robotCountPerQuadrant) > robots.items.len / 2) return steps;
    }

    return 0;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day14/inputs/input.txt", 21 * 1024);
    defer allocator.free(input);

    const safety_factor = try calculateSafetyFactor(allocator, input, 101, 103);
    const christmas_tree = try calculateChristmasTree(allocator, input, 101, 103);

    std.debug.print("Safety factor: {}\n", .{safety_factor});
    std.debug.print("Christmas tree: {}\n", .{christmas_tree});
}

pub fn runTests(alloctor: std.mem.Allocator) !void {
    try testExample1(alloctor);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day14/inputs/demo_1.txt", 256);
    defer allocator.free(input);

    const safety_factor = try calculateSafetyFactor(allocator, input, 11, 7);
    try std.testing.expectEqual(12, safety_factor);
}
