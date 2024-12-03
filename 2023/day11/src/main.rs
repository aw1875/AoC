#[derive(Debug)]
struct SpaceGrid {
    grid: Vec<Vec<char>>,
}

impl SpaceGrid {
    fn new(lines: &str) -> Self {
        let size = lines.bytes().position(|b| b == b'\n').unwrap();
        let mut grid = vec![vec!['.'; size]; size];

        lines
            .bytes()
            .enumerate()
            .filter(|(_, b)| b == &b'#')
            .for_each(|(i, _)| {
                grid[i / (size + 1)][i % (size + 1)] = '#';
            });

        SpaceGrid { grid }
    }

    fn expand_universe(&mut self, multiplier: Option<usize>) {
        let multiplier = multiplier.unwrap_or(1);

        let mut _curr_row: usize = 0;
        let mut curr_col: usize = 0;

        let mut new_rows = Vec::new();
        let mut new_cols = Vec::new();

        // Iterate through the cols. If a col doesn't have a galaxy, add a col right of it
        for _ in 0..self.grid.len() {
            if !self.grid.iter().any(|row| row[curr_col] == '#') {
                new_cols.extend((1..=multiplier).map(|_| curr_col + 1));
            }
            curr_col += 1;
        }

        // Iterate through the rows. If a row doesn't have a galaxy, add below it
        for row in 0..self.grid.len() {
            if !self.grid[row].contains(&'#') {
                new_rows.extend((1..=multiplier).map(|_| row + 1));
            }
            _curr_row += 1;
        }

        // Insert new columns and skip over them
        for col in new_cols.into_iter().rev() {
            for row in &mut self.grid {
                row.insert(col, '.');
            }
        }

        // Insert new rows and skip over them
        for row in new_rows.into_iter().rev() {
            self.grid.insert(row, vec!['.'; self.grid[0].len()]);
        }
    }

    fn manhattan_distance(&self) -> usize {
        let mut sum = 0;

        // Collect the coordinates of galaxies
        let galaxies: Vec<(usize, usize)> = self
            .grid
            .iter()
            .enumerate()
            .flat_map(|(row, r)| {
                r.iter().enumerate().filter_map(
                    move |(col, &c)| {
                        if c == '#' {
                            Some((row, col))
                        } else {
                            None
                        }
                    },
                )
            })
            .collect();

        // Iterate over all pairs of galaxies
        for i in 0..galaxies.len() {
            for j in i + 1..galaxies.len() {
                let (row1, col1) = galaxies[i];
                let (row2, col2) = galaxies[j];

                // Manhattan distance coming in clutch
                let distance =
                    (row1 as isize - row2 as isize).abs() + (col1 as isize - col2 as isize).abs();
                sum += distance as usize;
            }
        }

        return sum;
    }
}

fn part_1(lines: &str) -> String {
    let mut space_grid = SpaceGrid::new(lines);
    space_grid.expand_universe(None);

    return format!("{}", space_grid.manhattan_distance());
}

fn part_2(lines: &str) -> String {
    let mut space_grid = SpaceGrid::new(lines);
    space_grid.expand_universe(Some(1_000_000));

    return format!("{}", space_grid.manhattan_distance());
}

fn main() {
    let input = include_str!("../inputs/input.txt");
    println!("{}", part_1(&input));
    println!("{}", part_2(&input)); // this probably won't finish with the current implementation
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn test_part_1() {
        let input = include_str!("../inputs/demo.txt");
        assert_eq!(part_1(&input), "374");
    }

    #[test]
    fn test_part_2() {
        let input = include_str!("../inputs/demo.txt");
        assert_eq!(part_2(&input), "1030");
    }
}
