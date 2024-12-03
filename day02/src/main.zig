const std = @import("std");
const common = @import("../../common.zig");
const utils = @import("utils.zig");

const Report = @import("report.zig").Report;

fn getReports(allocator: std.mem.Allocator, input: []const u8) ![]Report {
    var data = std.ArrayList(Report).init(allocator);
    defer data.deinit();

    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        const report = try Report.init(allocator, line);

        try data.append(report);
    }

    const reports = try allocator.dupe(Report, data.items);

    return reports;
}

fn countSafe(allocator: std.mem.Allocator, reports: []Report, is_part_1: bool) !u32 {
    var safe_count: u32 = 0;

    for (reports) |report| {
        if (is_part_1) {
            safe_count += if (utils.isSafe(report.levels)) 1 else 0;
            continue;
        }

        safe_count += if (utils.canBeSafe(allocator, report)) 1 else 0;
    }

    return safe_count;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const input = try common.getInput(allocator, "day02/inputs/input.txt", 19 * 1024);
    defer allocator.free(input);

    const reports = try getReports(allocator, input);
    defer {
        for (reports) |report| {
            report.deinit(allocator);
        }

        allocator.free(reports);
    }

    const safe_count = try countSafe(allocator, reports, true);
    const safe_count_dampener = try countSafe(allocator, reports, false);
    std.debug.print("Safe Count: {d}\n", .{safe_count});
    std.debug.print("Safe Count Dampener: {d}\n", .{safe_count_dampener});
}

pub fn runTests(allocator: std.mem.Allocator) !void {
    try testExample1(allocator);
    try testExample2(allocator);
}

fn testExample1(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day02/inputs/demo_1.txt", 128);
    defer allocator.free(input);

    const reports = try getReports(allocator, input);
    defer {
        for (reports) |report| {
            report.deinit(allocator);
        }

        allocator.free(reports);
    }

    const safe_count = try countSafe(allocator, reports, true);
    try std.testing.expectEqual(2, safe_count);
}

fn testExample2(allocator: std.mem.Allocator) !void {
    const input = try common.getInput(allocator, "day02/inputs/demo_2.txt", 128);
    defer allocator.free(input);

    const reports = try getReports(allocator, input);
    defer {
        for (reports) |report| {
            report.deinit(allocator);
        }

        allocator.free(reports);
    }

    const safe_count = try countSafe(allocator, reports, false);
    try std.testing.expectEqual(4, safe_count);
}
