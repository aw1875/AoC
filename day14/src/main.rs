#[derive(Debug)]
struct Platform {
    grid: Vec<Vec<char>>,
}
impl Platform {
    fn parse(input: &str) -> Platform {
        let mut grid = vec![vec!['.'; input.lines().count()]; input.lines().nth(0).unwrap().len()];
        for (x, line) in input.lines().enumerate() {
            for (y, c) in line.chars().enumerate() {
                grid[y][x] = c;
            }
        }

        return Platform { grid };
    }

    fn tilt(&mut self) {
        for x in 0..self.grid.len() {
            for y in 0..self.grid[0].len() {
                if self.grid[x][y] == 'O' {
                    let mut new_y = y;
                    while new_y > 0 && self.grid[x][new_y - 1] == '.' {
                        new_y -= 1;
                    }
                    self.grid[x][y] = '.';
                    self.grid[x][new_y] = 'O';
                }
            }
        }
    }

    fn cycle(&mut self, cycles: usize) {
        let mut cycle = 0;

        while cycle < cycles {
            // North
            for x in 0..self.grid.len() {
                for y in 0..self.grid[0].len() {
                    if self.grid[x][y] == 'O' {
                        let mut new_y = y;
                        while new_y > 0 && self.grid[x][new_y - 1] == '.' {
                            new_y -= 1;
                        }
                        self.grid[x][y] = '.';
                        self.grid[x][new_y] = 'O';
                    }
                }
            }

            // West
            for x in 0..self.grid.len() {
                for y in 0..self.grid[0].len() {
                    if self.grid[x][y] == 'O' {
                        let mut new_x = x;
                        while new_x > 0 && self.grid[new_x - 1][y] == '.' {
                            new_x -= 1;
                        }
                        self.grid[x][y] = '.';
                        self.grid[new_x][y] = 'O';
                    }
                }
            }

            // South
            for x in (0..self.grid.len()).rev() {
                for y in (0..self.grid[0].len()).rev() {
                    if self.grid[x][y] == 'O' {
                        let mut new_y = y;
                        while new_y < self.grid[0].len() - 1 && self.grid[x][new_y + 1] == '.' {
                            new_y += 1;
                        }
                        self.grid[x][y] = '.';
                        self.grid[x][new_y] = 'O';
                    }
                }
            }

            // East
            for x in (0..self.grid.len()).rev() {
                for y in (0..self.grid[0].len()).rev() {
                    if self.grid[x][y] == 'O' {
                        let mut new_x = x;
                        while new_x < self.grid.len() - 1 && self.grid[new_x + 1][y] == '.' {
                            new_x += 1;
                        }
                        self.grid[x][y] = '.';
                        self.grid[new_x][y] = 'O';
                    }
                }
            }

            cycle += 1;
        }
    }

    fn calculate_load(&self) -> usize {
        let mut load = 0;

        for x in 0..self.grid.len() {
            for y in (0..self.grid[0].len()).rev() {
                if self.grid[x][y] == 'O' {
                    load += self.grid[0].len() - y;
                }
            }
        }

        return load;
    }
}

fn part_1(input: &str) -> String {
    let mut grid = Platform::parse(input);
    grid.tilt();
    let load = grid.calculate_load();

    return load.to_string();
}

fn part_2(input: &str) -> String {
    let mut grid = Platform::parse(input);
    grid.cycle(1000);
    let load = grid.calculate_load();

    return load.to_string();
}

fn main() {
    let input = include_str!("../inputs/input.txt");
    println!("{}", part_1(&input));
    println!("{}", part_2(&input));
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn test_part_1() {
        let input = include_str!("../inputs/demo.txt");
        assert_eq!(part_1(&input), "136");
    }

    #[test]
    fn test_part_2() {
        let input = include_str!("../inputs/demo.txt");
        assert_eq!(part_2(&input), "64");
    }
}

