const std = @import("std");
const common = @import("../../common.zig");
const utils = @import("utils.zig");

fn twoOpsCalculations(allocator: std.mem.Allocator, input: []const u8) !usize {
    var total: usize = 0;

    var lines = std.mem.splitSequence(u8, input, "\n");
    while (lines.next()) |line| {
        const target_str, const inputs_str = utils.splitOnceBy(u8, line, ":");

        const target = try std.fmt.parseInt(usize, target_str, 10);
        const numbers = try utils.collectNumbers(allocator, std.mem.trim(u8, inputs_str, " "));
        defer allocator.free(numbers);

        if (utils.isValid2Ops(target, numbers[0], numbers[1..])) {
            total += target;
        }
    }

    return total;
}

fn threeOpsCalculations(allocator: std.mem.Allocator, input: []const u8) !usize {
    var total: usize = 0;

    var lines = std.mem.splitSequence(u8, input, "\n");
    while (lines.next()) |line| {
        const target_str, const inputs_str = utils.splitOnceBy(u8, line, ":");

        const target = try std.fmt.parseInt(usize, target_str, 10);
        const numbers = try utils.collectNumbers(allocator, std.mem.trim(u8, inputs_str, " "));
        defer allocator.free(numbers);

        if (utils.isValid3Ops(target, numbers[0], numbers[1..])) {
            total += target;
        }
    }

    return total;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day07/inputs/input.txt", 25 * 1024);
    defer allocator.free(input);

    const twoOps = try twoOpsCalculations(allocator, input);
    const threeOps = try threeOpsCalculations(allocator, input);

    std.debug.print("Total Two Operator Calculations: {d}\n", .{twoOps});
    std.debug.print("Total Three Operator Calculations: {d}\n", .{threeOps});
}

pub fn runTests(alloctor: std.mem.Allocator) !void {
    try testExample1(alloctor);
    try testExample2(alloctor);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day07/inputs/demo_1.txt", 128);
    defer allocator.free(input);

    const twoOps = try twoOpsCalculations(allocator, input);
    try std.testing.expectEqual(3749, twoOps);
}

fn testExample2(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day07/inputs/demo_2.txt", 128);
    defer allocator.free(input);

    const threeOps = try threeOpsCalculations(allocator, input);
    try std.testing.expectEqual(11387, threeOps);
}
