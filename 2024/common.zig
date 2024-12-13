const std = @import("std");

pub fn getInput(allocator: std.mem.Allocator, path: []const u8, buff_size: anytype) ![]const u8 {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var buffer = try allocator.alloc(u8, buff_size);
    defer allocator.free(buffer);

    const len = try file.readAll(buffer);

    const input = try allocator.dupe(u8, std.mem.trim(u8, buffer[0..len], "\n"));
    return input;
}

pub const Coord = struct {
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
};

pub fn Grid(comptime T: type) type {
    return struct {
        const GridStruct = @This();

        allocator: std.mem.Allocator,
        rows: usize,
        cols: usize,
        cells: [][]T,

        pub fn init(allocator: std.mem.Allocator, input: []const u8) !GridStruct {
            var cells = std.ArrayList([]T).init(allocator);
            defer cells.deinit();

            var rows: usize = 0;
            var cols: usize = 0;

            var lines = std.mem.splitSequence(u8, input, "\n");
            while (lines.next()) |line| : (rows += 1) {
                cols = @max(cols, line.len);

                const col = try allocator.alloc(T, line.len);
                @memcpy(col, line);

                try cells.append(col);
            }

            return GridStruct{
                .allocator = allocator,
                .rows = rows,
                .cols = cols,
                .cells = try cells.toOwnedSlice(),
            };
        }

        pub fn deinit(self: *GridStruct) void {
            for (self.cells) |row| {
                self.allocator.free(row);
            }

            self.allocator.free(self.cells);
        }

        pub fn isInGrid(self: *GridStruct, coord: Coord) bool {
            return (coord.x < @as(isize, @intCast(self.cols)) and coord.x >= 0) and (coord.y < @as(isize, @intCast(self.rows)) and coord.y >= 0);
        }

        pub fn get(self: *GridStruct, coord: Coord) ?T {
            if (!self.isInGrid(coord)) return null;

            return self.cells[@intCast(coord.y)][@intCast(coord.x)];
        }
    };
}

pub fn Graph(comptime T: type) type {
    return struct {
        const GraphStruct = @This();
        const Edge = struct { coord: Coord, direction: u8 };

        allocator: std.mem.Allocator,
        rows: usize,
        cols: usize,
        grid: std.AutoHashMap(Coord, T),

        pub fn init(allocator: std.mem.Allocator, input: []const u8) !GraphStruct {
            var grid = std.AutoHashMap(Coord, T).init(allocator);

            var rows: usize = 0;
            var cols: usize = 0;

            var lines = std.mem.splitSequence(u8, input, "\n");
            while (lines.next()) |line| : (rows += 1) {
                cols = @max(cols, line.len);

                for (line, 0..) |c, i| {
                    try grid.put(Coord.init(i, rows), c);
                }
            }

            return GraphStruct{
                .allocator = allocator,
                .rows = rows,
                .cols = cols,
                .grid = grid,
            };
        }

        pub fn deinit(self: *GraphStruct) void {
            self.grid.deinit();
        }

        pub fn exploreRegion(self: *GraphStruct, start: Coord, region: T, scanned: *std.AutoHashMap(Coord, void)) !struct { usize, usize, usize } {
            var queue = std.ArrayList(Coord).init(self.allocator);
            defer queue.deinit();

            var edges = std.ArrayList(Edge).init(self.allocator);
            defer edges.deinit();

            try queue.append(start);
            var area: usize = 0;
            var perimeter: usize = 0;

            while (queue.items.len > 0) {
                const edge_count = edges.items.len;
                area += try self.exploreNext(region, &queue, &edges, scanned);
                perimeter += edges.items.len - edge_count;
            }

            return .{ area, perimeter, try self.checkEdges(&edges) };
        }

        fn exploreNext(
            self: *GraphStruct,
            region: u8,
            queue: *std.ArrayList(Coord),
            edges: *std.ArrayList(Edge),
            scanned: *std.AutoHashMap(Coord, void),
        ) !usize {
            const coord = queue.popOrNull() orelse return 0;
            if (scanned.contains(coord)) return 0;

            try scanned.put(coord, {});

            try self.checkNeighbor(region, coord, 1, 0, queue, edges, '>', scanned);
            try self.checkNeighbor(region, coord, -1, 0, queue, edges, '<', scanned);
            try self.checkNeighbor(region, coord, 0, 1, queue, edges, 'v', scanned);
            try self.checkNeighbor(region, coord, 0, -1, queue, edges, '^', scanned);

            return 1;
        }

        fn checkNeighbor(
            self: *GraphStruct,
            region: u8,
            coord: Coord,
            dx: isize,
            dy: isize,
            queue: *std.ArrayList(Coord),
            edges: *std.ArrayList(Edge),
            direction: u8,
            scanned: *std.AutoHashMap(Coord, void),
        ) !void {
            const neighbor_coord = Coord{ .x = coord.x + dx, .y = coord.y + dy };

            const neighbor = self.grid.get(neighbor_coord) orelse {
                try edges.append(Edge{ .coord = coord, .direction = direction });
                return;
            };

            if (neighbor != region) {
                try edges.append(Edge{ .coord = coord, .direction = direction });
                return;
            }

            if (!scanned.contains(neighbor_coord)) try queue.append(neighbor_coord);
        }

        fn checkEdges(self: *GraphStruct, edges: *std.ArrayList(Edge)) !usize {
            var sides = std.AutoHashMap(Edge, void).init(self.allocator);
            defer sides.deinit();

            for (edges.items) |edge| {
                try sides.put(edge, {});
            }

            for (edges.items) |edge| {
                if (!sides.contains(edge)) continue;

                if (edge.direction == '^' or edge.direction == 'v') {
                    self.pruneEdges(edge, -1, 0, &sides);
                    self.pruneEdges(edge, 1, 0, &sides);
                } else {
                    self.pruneEdges(edge, 0, -1, &sides);
                    self.pruneEdges(edge, 0, 1, &sides);
                }
            }

            return sides.count();
        }

        fn pruneEdges(_: *GraphStruct, edge: Edge, dx: isize, dy: isize, sides: *std.AutoHashMap(Edge, void)) void {
            var x = edge.coord.x + dx;
            var y = edge.coord.y + dy;
            var current = Edge{ .coord = Coord{ .x = x, .y = y }, .direction = edge.direction };

            while (sides.contains(current)) {
                _ = sides.remove(current);
                x += dx;
                y += dy;
                current = Edge{ .coord = Coord{ .x = x, .y = y }, .direction = edge.direction };
            }
        }
    };
}
