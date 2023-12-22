use std::cmp::max;
use std::collections::HashSet;

#[derive(Debug)]
enum Direction {
    Up,
    Down,
    Left,
    Right,
}
impl Direction {
    fn next(&self, x: i32, y: i32) -> (i32, i32) {
        match self {
            Direction::Up => (x - 1, y),
            Direction::Right => (x, y + 1),
            Direction::Down => (x + 1, y),
            Direction::Left => (x, y - 1),
        }
    }

    fn reflection(&self, c: char) -> Vec<Self> {
        match self {
            Direction::Up => match c {
                '.' => vec![Direction::Up],
                '|' => vec![Direction::Up],
                '/' => vec![Direction::Right],
                '\\' => vec![Direction::Left],
                '-' => vec![Direction::Left, Direction::Right],
                _ => panic!("Invalid char {}", c),
            },
            Direction::Right => match c {
                '.' => vec![Direction::Right],
                '|' => vec![Direction::Up, Direction::Down],
                '/' => vec![Direction::Up],
                '\\' => vec![Direction::Down],
                '-' => vec![Direction::Right],
                _ => panic!("Invalid char {}", c),
            },
            Direction::Down => match c {
                '.' => vec![Direction::Down],
                '|' => vec![Direction::Down],
                '/' => vec![Direction::Left],
                '\\' => vec![Direction::Right],
                '-' => vec![Direction::Left, Direction::Right],
                _ => panic!("Invalid char {}", c),
            },
            Direction::Left => match c {
                '.' => vec![Direction::Left],
                '|' => vec![Direction::Up, Direction::Down],
                '/' => vec![Direction::Down],
                '\\' => vec![Direction::Up],
                '-' => vec![Direction::Left],
                _ => panic!("Invalid char {}", c),
            },
        }
    }
}

#[derive(Debug)]
struct Grid {
    data: Vec<Vec<char>>,
    m: i32,
    n: i32,
}
impl Grid {
    fn new(input: &str) -> Self {
        let data = input
            .lines()
            .map(|line| line.chars().collect::<Vec<char>>())
            .collect::<Vec<Vec<char>>>();
        let m = data.len() as i32;
        let n = data[0].len() as i32;

        Grid { data, m, n }
    }

    fn count(&self, x: i32, y: i32, direction: Option<Direction>) -> i32 {
        let mut seen = HashSet::new();
        let mut visited = vec![vec![false; self.n as usize]; self.m as usize];

        let direction = direction.unwrap_or(Direction::Right);
        self.visit(direction, x, y, &mut seen, &mut visited);

        return visited.iter().flatten().filter(|&&x| x).count() as i32;
    }

    fn visit(
        &self,
        direction: Direction,
        x: i32,
        y: i32,
        seen: &mut HashSet<String>,
        visited: &mut Vec<Vec<bool>>,
    ) {
        if x < 0 || x >= self.m || y < 0 || y >= self.n {
            return;
        }

        let key = format!("{},{}-{:?}", x, y, direction);
        if seen.contains(&key) {
            return;
        }

        seen.insert(key);
        visited[x as usize][y as usize] = true;

        for mv in direction.reflection(self.data[x as usize][y as usize]) {
            let next = mv.next(x, y);
            self.visit(mv, next.0, next.1, seen, visited);
        }
    }
}

fn part_1(input: &str) -> String {
    let grid = Grid::new(input);
    return grid.count(0, 0, None).to_string();
}

fn part_2(input: &str) -> String {
    let grid = Grid::new(input);

    // Count all the directions
    let mut count = 0;

    for i in 0..grid.data[0].len() {
        let (t, b) = (
            grid.count(0, i as i32, Some(Direction::Down)),
            grid.count(grid.m as i32 - 1, i as i32, Some(Direction::Up)),
        );

        count = max(count, max(t, b));
    }

    for i in 0..grid.data.len() {
        let (l, r) = (
            grid.count(i as i32, 0, Some(Direction::Right)),
            grid.count(i as i32, grid.n as i32 - 2, Some(Direction::Left)),
        );
        count = max(count, max(l, r));
    }

    return count.to_string();
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
        assert_eq!(part_1(&input), "46");
    }

    #[test]
    fn test_part_2() {
        let input = include_str!("../inputs/demo.txt");
        assert_eq!(part_2(&input), "51");
    }
}
