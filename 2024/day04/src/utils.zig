const std = @import("std");

pub fn hashedKey(y: isize, x: isize) u64 {
    var hasher = std.hash.XxHash3.init(0);
    hasher.update(&std.mem.toBytes(x));
    hasher.update(&std.mem.toBytes(y));

    return hasher.final();
}
