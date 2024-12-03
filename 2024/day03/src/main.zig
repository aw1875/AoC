const std = @import("std");
const common = @import("../../common.zig");

fn calculateProduct(input: []const u8) u32 {
    var total: u32 = 0;

    var parts = std.mem.splitSequence(u8, input, "mul(");
    while (parts.next()) |part| {
        var numbers = std.mem.splitScalar(u8, part, ',');

        // Get First Number
        const first_num_str = numbers.next() orelse continue;
        const first_num = std.fmt.parseInt(u32, first_num_str, 10) catch continue;

        // Check if we have closing parenthesis within characters 1-3
        const second_part = numbers.next() orelse continue;
        const index = std.mem.indexOfPos(u8, second_part, 1, ")") orelse continue;
        if (index > 3) continue;

        // Get Second Number
        const second_num_str = second_part[0..index];
        const second_num = std.fmt.parseInt(u32, second_num_str, 10) catch continue;

        if (first_num >= 0 and first_num <= 999 and second_num >= 0 and second_num <= 999) {
            total += first_num * second_num;
        }
    }

    return total;
}

fn calculateInstructionsProduct(input: []const u8) i32 {
    if (input.len == 0) return 0;
    var total: i32 = 0;

    var do_parts = std.mem.splitSequence(u8, input, "do(");
    while (do_parts.next()) |do_part| {
        // We only want the first part before the don't
        var dont_parts = std.mem.splitSequence(u8, do_part, "don't(");
        total += @intCast(calculateProduct(dont_parts.first()));
    }

    return total;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day03/inputs/input.txt", 18 * 1024);
    defer allocator.free(input);

    const product = calculateProduct(input);
    const instructionsProduct = calculateInstructionsProduct(input);

    std.debug.print("Product: {d}\n", .{product});
    std.debug.print("Instructions Product: {d}\n", .{instructionsProduct});
}

pub fn runTests(allocator: std.mem.Allocator) !void {
    try testExample1(allocator);
    try testExample2(allocator);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day03/inputs/demo_1.txt", 128);
    defer allocator.free(input);

    const product = calculateProduct(input);
    try std.testing.expectEqual(161, product);
}

fn testExample2(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day03/inputs/demo_2.txt", 128);
    defer allocator.free(input);

    const product = calculateInstructionsProduct(input);
    try std.testing.expectEqual(48, product);
}
