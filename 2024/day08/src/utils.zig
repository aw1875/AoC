const std = @import("std");

const Coord = @import("coord.zig");

pub fn hashedKey(coord: Coord) u64 {
    var hasher = std.hash.XxHash3.init(0);
    hasher.update(&std.mem.toBytes(coord.x));
    hasher.update(&std.mem.toBytes(coord.y));

    return hasher.final();
}
