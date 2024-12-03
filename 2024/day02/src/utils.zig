const std = @import("std");
const Report = @import("report.zig").Report;

pub fn isIncreasing(levels: []u32) bool {
    for (1..levels.len) |i| {
        if (levels[i - 1] >= levels[i]) {
            return false;
        }
    }

    return true;
}

pub fn isDecreasing(levels: []u32) bool {
    for (1..levels.len) |i| {
        if (levels[i - 1] <= levels[i]) {
            return false;
        }
    }

    return true;
}

pub fn isInRange(_a: u32, _b: u32, inc: bool) bool {
    const a: i32 = @intCast(_a);
    const b: i32 = @intCast(_b);

    if (inc) {
        return b >= a + 1 and b <= a + 3;
    } else {
        return b >= a - 3 and b <= a - 1;
    }
}

pub fn isSafe(levels: []u32) bool {
    var is_safe: bool = true;
    if (isIncreasing(levels)) {
        for (1..levels.len) |i| {
            if (!isInRange(levels[i - 1], levels[i], true)) {
                is_safe = false;
                break;
            }
        }
    } else if (isDecreasing(levels)) {
        for (1..levels.len) |i| {
            if (!isInRange(levels[i - 1], levels[i], false)) {
                is_safe = false;
                break;
            }
        }
    } else {
        return false;
    }

    return is_safe;
}

// Check if we can make it safe by removing a single element
pub fn canBeSafe(allocator: std.mem.Allocator, report: Report) bool {
    if (isSafe(report.levels)) return true;

    for (report.levels, 0..) |_, i| {
        var new_levels = std.ArrayList(u32).init(allocator);
        defer new_levels.deinit();

        new_levels.appendSlice(report.levels[0..i]) catch unreachable;
        new_levels.appendSlice(report.levels[i + 1 ..]) catch unreachable;

        if (isSafe(new_levels.items)) return true;
    }

    return false;
}
