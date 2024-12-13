const std = @import("std");
const common = @import("../../common.zig");

const Arcade = @import("arcade.zig");

pub fn getFewestTokens(allocator: std.mem.Allocator, input: []const u8) !struct { isize, isize } {
    var arcade = try Arcade.init(allocator, input);
    defer arcade.deinit();

    var p1: isize = 0;
    var p2: isize = 0;
    for (arcade.claw_machines.items) |*claw_machine| {
        p1 += claw_machine.getCostToWin(0);
        p2 += claw_machine.getCostToWin(10000000000000);
    }

    return .{ p1, p2 };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day13/inputs/input.txt", 21 * 1024);
    defer allocator.free(input);

    const fewestTokens, const fewestTokensWithOffset = try getFewestTokens(allocator, input);

    std.debug.print("Fewest tokens: {}\n", .{fewestTokens});
    std.debug.print("Fewest tokens with offset: {}\n", .{fewestTokensWithOffset});
}

pub fn runTests(alloctor: std.mem.Allocator) !void {
    try testExample1(alloctor);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day13/inputs/demo_1.txt", 512);
    defer allocator.free(input);

    const part1, _ = try getFewestTokens(allocator, input);
    try std.testing.expectEqual(480, part1);
}
