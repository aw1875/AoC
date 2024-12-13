const std = @import("std");

const utils = @import("utils.zig");

const ClawMachine = @This();

a: [2]isize,
b: [2]isize,
target: [2]isize,

pub fn init(input: []const u8) ClawMachine {
    var a: [2]isize = undefined;
    var b: [2]isize = undefined;
    var target: [2]isize = undefined;

    var i: isize = 0;

    var lines = std.mem.splitSequence(u8, input, "\n");
    while (lines.next()) |line| : (i += 1) {
        const n1, const n2 = utils.getNumbers(line);

        if (i == 0) {
            a = [_]isize{ n1, n2 };
        } else if (i == 1) {
            b = [_]isize{ n1, n2 };
        } else if (i == 2) {
            target = [_]isize{ n1, n2 };
        }
    }

    return ClawMachine{ .a = a, .b = b, .target = target };
}

pub fn getCostToWin(self: *ClawMachine, offset: isize) isize {
    const ax, const ay = self.a;
    const bx, const by = self.b;
    var target_x, var target_y = self.target;

    target_x += offset;
    target_y += offset;

    const product_b = @divFloor((target_x * ay - target_y * ax), (bx * ay - ax * by));
    const product_a = @divFloor((target_x - product_b * bx), ax);

    return if (product_a * ax + product_b * bx == target_x and product_a * ay + product_b * by == target_y) (product_a * 3) + product_b else 0;
}
