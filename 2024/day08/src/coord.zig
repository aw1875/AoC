const Coord = @This();

x: isize,
y: isize,

pub fn init(x: usize, y: usize) Coord {
    return .{ .x = @intCast(x), .y = @intCast(y) };
}

pub fn add(self: Coord, other: Coord) Coord {
    return .{ .x = self.x + other.x, .y = self.y + other.y };
}

pub fn sub(self: Coord, other: Coord) Coord {
    return .{ .x = self.x - other.x, .y = self.y - other.y };
}

pub fn getDelta(self: Coord, other: Coord) Coord {
    return .{ .x = self.x - other.x, .y = self.y - other.y };
}

pub fn simplify(self: Coord, gcd: isize) Coord {
    return .{ .x = @divFloor(self.x, gcd), .y = @divFloor(self.y, gcd) };
}
