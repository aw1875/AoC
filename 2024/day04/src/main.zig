const std = @import("std");
const common = @import("../../common.zig");
const utils = @import("utils.zig");

const Direction = @import("direction.zig").Direction;
const Grid = @import("grid.zig").Grid;

fn countXMAS(grid: Grid) u16 {
    var count: u16 = 0;
    for (0..grid.rows) |row| {
        const y = @as(isize, @intCast(row));

        for (0..grid.cols) |col| {
            const x = @as(isize, @intCast(col));
            if (grid.cells.get(utils.hashedKey(y, x)) != 'X') continue;

            inline for (@typeInfo(Direction).Enum.fields) |d| {
                const direction: Direction = @enumFromInt(d.value);

                if (direction.toCordsVec()) |coord| {
                    if (grid.cells.get(utils.hashedKey(y + coord[0].x, x + coord[0].y)) == 'M' and
                        grid.cells.get(utils.hashedKey(y + coord[1].x, x + coord[1].y)) == 'A' and
                        grid.cells.get(utils.hashedKey(y + coord[2].x, x + coord[2].y)) == 'S')
                    {
                        count += 1;
                    }
                }
            }
        }
    }

    return count;
}

fn coundMAS(grid: Grid) u16 {
    var count: u16 = 0;
    for (0..grid.rows) |row| {
        const y = @as(isize, @intCast(row));

        for (0..grid.cols) |col| {
            const x = @as(isize, @intCast(col));
            if (grid.cells.get(utils.hashedKey(y, x)) != 'A') continue;

            inline for (@typeInfo(Direction).Enum.fields) |d| {
                const direction: Direction = @enumFromInt(d.value);

                if (direction.toCordsQuad()) |coord| {
                    if (grid.cells.get(utils.hashedKey(y + coord[0].x, x + coord[0].y)) == 'M' and
                        grid.cells.get(utils.hashedKey(y + coord[1].x, x + coord[1].y)) == 'S' and
                        grid.cells.get(utils.hashedKey(y + coord[2].x, x + coord[2].y)) == 'M' and
                        grid.cells.get(utils.hashedKey(y + coord[3].x, x + coord[3].y)) == 'S')
                    {
                        count += 1;
                        break;
                    }
                }
            }
        }
    }
    return count;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day04/inputs/input.txt", 20 * 1024);
    defer allocator.free(input);

    var grid = try Grid.init(allocator, input);
    defer grid.deinit();

    const xmas_words = countXMAS(grid);
    const mas_words = coundMAS(grid);

    std.debug.print("XMAS count: {d}\n", .{xmas_words});
    std.debug.print("MAS count: {d}\n", .{mas_words});
}

pub fn runTests(alloctor: std.mem.Allocator) !void {
    try testExample1(alloctor);
    try testExample2(alloctor);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day04/inputs/demo_1.txt", 128);
    defer allocator.free(input);

    var grid = try Grid.init(allocator, input);
    defer grid.deinit();

    const xmas_words = countXMAS(grid);
    try std.testing.expectEqual(18, xmas_words);
}

fn testExample2(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day04/inputs/demo_2.txt", 128);
    defer allocator.free(input);

    var grid = try Grid.init(allocator, input);
    defer grid.deinit();

    const mas_words = coundMAS(grid);
    try std.testing.expectEqual(9, mas_words);
}
