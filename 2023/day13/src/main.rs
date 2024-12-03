use std::cmp::min;

fn check_col(lines: Vec<Vec<&str>>, col: usize) -> bool {
    let min_len = min(col, lines[0].len() - col);
    let start = col - min_len;
    let end = col + min_len;

    for row in lines {
        let reversed_slice: Vec<&str> = row[col..end].iter().rev().cloned().collect();
        if row[start..col] != reversed_slice {
            return false;
        }
    }

    return true;
}

fn find_horizontal_mirror(lines: Vec<Vec<&str>>) -> usize {
    todo!()
}

fn check_row(lines: Vec<Vec<&str>>, row: usize) -> bool {
    let min_len = min(row, lines.len() - row);

    todo!()
}

fn find_vertical_mirror(lines: Vec<Vec<&str>>) -> usize {
    todo!()
}

fn part_1(input: &str) -> String {
    todo!()
}

fn part_2(input: &str) -> String {
    return "".to_string();
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
        assert_eq!(part_1(&input), "405");
    }

    #[test]
    fn test_part_2() {
        let input = include_str!("../inputs/demo.txt");
        assert_eq!(part_2(&input), "525152");
    }
}
