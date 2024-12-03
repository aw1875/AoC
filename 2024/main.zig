const std = @import("std");

// Days
const day01 = @import("day01/src/main.zig");
const day02 = @import("day02/src/main.zig");
const day03 = @import("day03/src/main.zig");

const Command = enum {
    run,
    @"test",
};

const Day = enum {
    day01,
    day02,
    day03,

    pub fn run(self: Day) !void {
        switch (self) {
            Day.day01 => try day01.main(),
            Day.day02 => try day02.main(),
            Day.day03 => try day03.main(),
        }
    }

    pub fn @"test"(self: Day, allocator: std.mem.Allocator) !void {
        switch (self) {
            Day.day01 => try day01.runTests(allocator),
            Day.day02 => try day02.runTests(allocator),
            Day.day03 => try day03.runTests(allocator),
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

    if (command == Command.run) {
        try day.?.run();
    } else if (command == Command.@"test") {
        try day.?.@"test"(allocator);
    }
}
