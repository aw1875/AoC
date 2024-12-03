use pcre2::bytes::Regex;
use std::fs::read_to_string;

fn read_lines(filename: &str) -> Vec<String> {
    read_to_string(filename)
        .unwrap()
        .lines()
        .map(String::from)
        .collect()
}

#[derive(Debug)]
struct Symbol {
    index: usize,
    value: char,
}

#[derive(Debug)]
struct Number {
    number: u16,
    start: usize,
    end: usize,
}

fn check_for_adjecent_symbol(
    number: &str,
    row: usize,
    col: usize,
    symbols_map: &Vec<Vec<Symbol>>,
) -> bool {
    let number_length = number.len();

    // Check above
    if let Some(above_row) = symbols_map.get(row.wrapping_sub(1)) {
        for symbol in above_row {
            if symbol.index >= col && symbol.index <= col + number_length - 1 {
                return true;
            } else if symbol.index == col.wrapping_sub(1) || symbol.index == col + number_length {
                return true;
            }
        }
    }

    // Check below
    if let Some(below_row) = symbols_map.get(row + 1) {
        for symbol in below_row {
            if symbol.index >= col && symbol.index <= col + number_length - 1 {
                return true;
            } else if symbol.index == col.wrapping_sub(1) || symbol.index == col + number_length {
                return true;
            }
        }
    }

    // Check left and right
    if let Some(current_row) = symbols_map.get(row) {
        for symbol in current_row {
            if symbol.index == col.wrapping_sub(1) || symbol.index == col + number_length {
                return true;
            }
        }
    }

    return false;
}

fn part_1(lines: &Vec<String>) -> String {
    let mut symbols_map: Vec<Vec<Symbol>> = Vec::new();

    let numbers_regex = Regex::new(r"(?P<number>\d+)").unwrap();
    let symbols_regex = Regex::new(r"(?P<symbol>[^0-9.]+)").unwrap();
    let mut part_numbers: Vec<u16> = Vec::new();

    for i in 0..lines.len() {
        let line = &lines[i];
        if line.is_empty() {
            continue;
        }

        symbols_map.push(Vec::new());
        for symbol_match in symbols_regex.captures_iter(line.as_bytes()) {
            let result = &symbol_match.unwrap();
            let symbol = String::from_utf8(result["symbol"].to_vec()).unwrap();
            let index = result.get(0).unwrap().start();

            symbols_map[i].push(Symbol {
                value: symbol.chars().nth(0).unwrap(),
                index,
            });
        }
    }

    for i in 0..lines.len() {
        let line = &lines[i];
        if line.is_empty() {
            continue;
        }

        for number_match in numbers_regex.captures_iter(line.as_bytes()) {
            let result = &number_match.unwrap();
            let number = String::from_utf8(result["number"].to_vec()).unwrap();

            if !number.is_empty() {
                if check_for_adjecent_symbol(
                    &number,
                    i,
                    result.get(0).unwrap().start(),
                    &symbols_map,
                ) {
                    part_numbers.push(number.parse::<u16>().unwrap());
                }
            }
        }
    }

    let sum: u32 = part_numbers.iter().map(|x| *x as u32).sum();
    return format!("{}", sum);
}

fn check_for_adjacent_numbers(row: usize, col: usize, numbers_map: &Vec<Vec<Number>>) -> Vec<u16> {
    let mut adjacent_numbers: Vec<u16> = Vec::new();

    // Check above
    if let Some(above_row) = numbers_map.get(row.wrapping_sub(1)) {
        for number in above_row {
            if col >= number.start && col <= number.end {
                adjacent_numbers.push(number.number);
            } else if col == number.start.wrapping_sub(1) || col == number.end + 1 {
                adjacent_numbers.push(number.number);
            } else if col == number.end + 1 || col == number.start.wrapping_sub(1) {
                adjacent_numbers.push(number.number);
            }
        }
    }

    // Check below
    if let Some(below_row) = numbers_map.get(row + 1) {
        for number in below_row {
            if col >= number.start && col <= number.end {
                adjacent_numbers.push(number.number);
            } else if col == number.start.wrapping_sub(1) || col == number.end + 1 {
                adjacent_numbers.push(number.number);
            } else if col == number.end + 1 || col == number.start.wrapping_sub(1) {
                adjacent_numbers.push(number.number);
            }
        }
    }

    // Check in between two numbers on the same line
    if let Some(current_row) = numbers_map.get(row) {
        for number in current_row {
            if col == number.start.wrapping_sub(1) || col == number.end + 1 {
                adjacent_numbers.push(number.number);
            }
        }
    }

    return adjacent_numbers;
}

fn part_2(lines: &Vec<String>) -> String {
    let mut numbers_map: Vec<Vec<Number>> = Vec::new();

    let numbers_regex = Regex::new(r"(?P<number>\d+)").unwrap();
    let gear_regex = Regex::new(r"(?P<gear>\*)").unwrap();
    let mut gear_ratios: Vec<u64> = Vec::new();

    for i in 0..lines.len() {
        let line = &lines[i];
        if line.is_empty() {
            continue;
        }

        numbers_map.push(Vec::new());
        for number_match in numbers_regex.captures_iter(line.as_bytes()) {
            let result = &number_match.unwrap();
            let number = String::from_utf8(result["number"].to_vec()).unwrap();
            if !number.is_empty() {
                numbers_map[i].push(Number {
                    number: number.parse::<u16>().unwrap(),
                    start: result.get(0).unwrap().start(),
                    end: result.get(0).unwrap().end() - 1,
                });
            }
        }
    }

    for i in 0..lines.len() {
        let line = &lines[i];
        if line.is_empty() {
            continue;
        }

        for gear_match in gear_regex.captures_iter(line.as_bytes()) {
            let result = &gear_match.unwrap();
            let gear = String::from_utf8(result["gear"].to_vec()).unwrap();
            if !gear.is_empty() {
                let adjecent_numbers =
                    check_for_adjacent_numbers(i, result.get(0).unwrap().start(), &numbers_map);

                if adjecent_numbers.len() == 2 {
                    gear_ratios.push(adjecent_numbers[0] as u64 * adjecent_numbers[1] as u64);
                }
            }
        }
    }

    let sum: u32 = gear_ratios.iter().map(|x| *x as u32).sum();
    return format!("{}", sum);
}

fn main() {
    let input = read_lines("inputs/input.txt");
    println!("{}", part_1(&input));
    println!("{}", part_2(&input));
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn test_part_1() {
        let input = read_lines("inputs/demo.txt");
        assert_eq!(part_1(&input), "4361");
    }

    #[test]
    fn test_part_2() {
        let input = read_lines("inputs/demo.txt");
        assert_eq!(part_2(&input), "467835");
    }
}
