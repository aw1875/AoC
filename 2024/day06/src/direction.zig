pub const Coord = struct {
    x: isize,
    y: isize,

    pub fn add(self: Coord, other: Coord) Coord {
        return .{ .x = self.x + other.x, .y = self.y + other.y };
    }

    pub fn equals(self: Coord, other: Coord) bool {
        return self.x == other.x and self.y == other.y;
    }
};

pub const Direction = enum {
    Up,
    Down,
    Left,
    Right,

    pub fn toCoord(self: Direction) Coord {
        switch (self) {
            .Up => return .{ .x = 0, .y = -1 },
            .Down => return .{ .x = 0, .y = 1 },
            .Left => return .{ .x = -1, .y = 0 },
            .Right => return .{ .x = 1, .y = 0 },
        }
    }

    pub fn rotate(self: Direction) Direction {
        switch (self) {
            .Up => return .Right,
            .Right => return .Down,
            .Down => return .Left,
            .Left => return .Up,
        }
    }
};
