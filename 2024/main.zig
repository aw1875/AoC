const std = @import("std");

// Days
const day01 = @import("day01/src/main.zig");
const day02 = @import("day02/src/main.zig");
const day03 = @import("day03/src/main.zig");
const day04 = @import("day04/src/main.zig");
const day05 = @import("day05/src/main.zig");
const day06 = @import("day06/src/main.zig");
const day07 = @import("day07/src/main.zig");
const day08 = @import("day08/src/main.zig");

const Command = enum {
    run,
    @"test",
};

const Day = enum {
    day01,
    day02,
    day03,
    day04,
    day05,
    day06,
    day07,
    day08,

    pub fn run(self: Day) !void {
        switch (self) {
            .day01 => try day01.main(),
            .day02 => try day02.main(),
            .day03 => try day03.main(),
            .day04 => try day04.main(),
            .day05 => try day05.main(),
            .day06 => try day06.main(),
            .day07 => try day07.main(),
            .day08 => try day08.main(),
        }
    }

    pub fn @"test"(self: Day, allocator: std.mem.Allocator) !void {
        switch (self) {
            .day01 => try day01.runTests(allocator),
            .day02 => try day02.runTests(allocator),
            .day03 => try day03.runTests(allocator),
            .day04 => try day04.runTests(allocator),
            .day05 => try day05.runTests(allocator),
            .day06 => try day06.runTests(allocator),
            .day07 => try day07.runTests(allocator),
            .day08 => try day08.runTests(allocator),
        }

        std.debug.print("All tests passed\n", .{});
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);

    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 3) {
        std.debug.print("Usage: {s} <run|test> <day number>\nExample: {s} run day01\n", .{ args[0], args[0] });
        std.process.exit(1);
    }

    const command = std.meta.stringToEnum(Command, args[1]) orelse null;
    const day = std.meta.stringToEnum(Day, args[2]);

    if (command == null or day == null) {
        std.debug.print("Invalid command or day number\n", .{});
        std.process.exit(1);
    }

    if (command == .run) {
        try day.?.run();
    } else if (command == .@"test") {
        try day.?.@"test"(allocator);
    }
}
