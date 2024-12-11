const std = @import("std");

const Coord = @import("../../common.zig").Coord;

pub fn hashedKey(pos: Coord) u64 {
    var hasher = std.hash.XxHash3.init(0);
    hasher.update(&std.mem.toBytes(pos.x));
    hasher.update(&std.mem.toBytes(pos.y));

    return hasher.final();
}
