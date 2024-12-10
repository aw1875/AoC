pub fn calculateChecksum(items: []isize, is_part_2: bool) usize {
    var checksum: usize = 0;
    for (items, 0..) |file_id, i| {
        if (file_id == -1) if (is_part_2) continue else break;
        checksum += @as(usize, @intCast(file_id)) * i;
    }

    return checksum;
}
