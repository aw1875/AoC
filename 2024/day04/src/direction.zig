const Coord = struct { x: i8, y: i8 };
pub const Direction = enum {
    // Straights
    Up,
    Down,
    Left,
    Right,

    // Diagonals
    UpLeft,
    UpRight,
    DownLeft,
    DownRight,

    // X Permutations
    XPermutation1,
    XPermutation2,
    XPermutation3,
    XPermutation4,

    pub fn toCordsVec(self: Direction) ?*const [3]Coord {
        switch (self) {
            .Up => return &[_]Coord{ .{ .x = 0, .y = 1 }, .{ .x = 0, .y = 2 }, .{ .x = 0, .y = 3 } },
            .Down => return &[_]Coord{ .{ .x = 0, .y = -1 }, .{ .x = 0, .y = -2 }, .{ .x = 0, .y = -3 } },
            .Left => return &[_]Coord{ .{ .x = -1, .y = 0 }, .{ .x = -2, .y = 0 }, .{ .x = -3, .y = 0 } },
            .Right => return &[_]Coord{ .{ .x = 1, .y = 0 }, .{ .x = 2, .y = 0 }, .{ .x = 3, .y = 0 } },
            .UpLeft => return &[_]Coord{ .{ .x = -1, .y = 1 }, .{ .x = -2, .y = 2 }, .{ .x = -3, .y = 3 } },
            .UpRight => return &[_]Coord{ .{ .x = 1, .y = 1 }, .{ .x = 2, .y = 2 }, .{ .x = 3, .y = 3 } },
            .DownLeft => return &[_]Coord{ .{ .x = -1, .y = -1 }, .{ .x = -2, .y = -2 }, .{ .x = -3, .y = -3 } },
            .DownRight => return &[_]Coord{ .{ .x = 1, .y = -1 }, .{ .x = 2, .y = -2 }, .{ .x = 3, .y = -3 } },
            else => return null,
        }
    }

    pub fn toCordsQuad(self: Direction) ?*const [4]Coord {
        switch (self) {
            .XPermutation1 => return &[_]Coord{ .{ .x = -1, .y = -1 }, .{ .x = 1, .y = 1 }, .{ .x = -1, .y = 1 }, .{ .x = 1, .y = -1 } },
            .XPermutation2 => return &[_]Coord{ .{ .x = -1, .y = -1 }, .{ .x = 1, .y = 1 }, .{ .x = 1, .y = -1 }, .{ .x = -1, .y = 1 } },
            .XPermutation3 => return &[_]Coord{ .{ .x = 1, .y = 1 }, .{ .x = -1, .y = -1 }, .{ .x = -1, .y = 1 }, .{ .x = 1, .y = -1 } },
            .XPermutation4 => return &[_]Coord{ .{ .x = 1, .y = 1 }, .{ .x = -1, .y = -1 }, .{ .x = 1, .y = -1 }, .{ .x = -1, .y = 1 } },
            else => return null,
        }
    }
};
