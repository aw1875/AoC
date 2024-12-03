const std = @import("std");

pub const Spots = struct {
    first_spots_array: []u32,
    second_spots_array: []u32,

    pub fn deinit(self: *Spots, allocator: std.mem.Allocator) void {
        allocator.free(self.first_spots_array);
        allocator.free(self.second_spots_array);
    }
};
