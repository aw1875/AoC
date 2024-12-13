const std = @import("std");

const ClawMachine = @import("claw_machine.zig");

const Arcade = @This();

claw_machines: std.ArrayList(ClawMachine),

pub fn init(allocator: std.mem.Allocator, input: []const u8) !Arcade {
    var claw_machines = std.ArrayList(ClawMachine).init(allocator);

    var lines = std.mem.splitSequence(u8, input, "\n\n");
    while (lines.next()) |line| {
        const claw_machine = ClawMachine.init(line);
        try claw_machines.append(claw_machine);
    }

    return Arcade{ .claw_machines = claw_machines };
}

pub fn deinit(self: Arcade) void {
    self.claw_machines.deinit();
}
