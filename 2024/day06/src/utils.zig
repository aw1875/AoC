const std = @import("std");

const direction = @import("direction.zig");
const Direction = direction.Direction;
const Coord = direction.Coord;

pub fn hashedKey(pos: Coord, dir: Direction) u64 {
    var hasher = std.hash.XxHash3.init(0);
    hasher.update(&std.mem.toBytes(pos.x));
    hasher.update(&std.mem.toBytes(pos.y));
    hasher.update(&std.mem.toBytes(dir));

    return hasher.final();
}
