const std = @import("std");

pub fn digitLength(n: usize) usize {
    return @as(usize, @intFromFloat(@floor(@log10(@as(f64, @floatFromInt(n)))))) + 1;
}

pub fn splitNumber(n: usize, length: usize) struct { usize, usize } {
    const factor = std.math.pow(usize, 10, length / 2);

    return .{ n / factor, n % factor };
}
