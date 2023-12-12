use pcre2::bytes;
use regex::Regex;
use std::{collections::HashMap, fs::read_to_string};

fn read_lines(filename: &str) -> Vec<String> {
    read_to_string(filename)
        .unwrap()
        .lines()
        .map(String::from)
        .collect()
}

fn part_1(lines: &Vec<String>) -> String {
    let regex = Regex::new(r"[1-9]").unwrap();
    let mut calibrations: Vec<u8> = Vec::new();

    for line in lines {
        let results = regex.captures_iter(line);

        let mut digits: Vec<String> = Vec::new();
        for r in results {
            let d = r.get(0).unwrap().as_str().to_string();
            digits.push(d);
        }

        if digits.len() == 0 {
            continue;
        }

        if digits.len() == 1 {
            let d = format!("{}{}", digits[0], digits[0]);
            calibrations.push(d.parse::<u8>().unwrap());
        } else {
            let d = format!("{}{}", digits[0], digits[digits.len() - 1]);
            calibrations.push(d.parse::<u8>().unwrap());
        }
    }

    let sum: u32 = calibrations.iter().map(|x| *x as u32).sum();
    return format!("{}", sum);
}

fn part_2(lines: &Vec<String>) -> String {
    let valid_numbers: HashMap<&str, u8> = HashMap::from([
        ("one", 1),
        ("two", 2),
        ("three", 3),
        ("four", 4),
        ("five", 5),
        ("six", 6),
        ("seven", 7),
        ("eight", 8),
        ("nine", 9),
    ]);

    let number_regex = Regex::new(r"[1-9]").unwrap();
    let number_as_words_regex =
        bytes::Regex::new(r"(?=(one|two|three|four|five|six|seven|eight|nine))").unwrap();
    let mut calibrations: Vec<u8> = Vec::new();

    for line in lines {
        let mut matches: Vec<(String, usize)> = Vec::new();

        let numbers_result = number_regex.captures_iter(line);
        let number_as_words_result = number_as_words_regex.captures_iter(line.as_bytes());

        for r in numbers_result {
            let d = r.get(0).unwrap().as_str().to_string();
            matches.push((d, r.get(0).unwrap().start()));
        }

        for r in number_as_words_result {
            let r_unwrapped = r.unwrap();
            let d = String::from_utf8(r_unwrapped.get(1).unwrap().as_bytes().to_vec()).unwrap();
            matches.push((d, r_unwrapped.get(0).unwrap().start()));
        }

        // Sort the matches by position ascending
        matches.sort_by(|a, b| a.1.cmp(&b.1));

        if matches.len() == 0 {
            continue;
        }

        let mut current: Vec<u8> = Vec::new();

        // Check the first match
        if valid_numbers.contains_key(matches[0].0.as_str()) {
            current.push(*valid_numbers.get(matches[0].0.as_str()).unwrap());
        } else {
            current.push(matches[0].0.parse::<u8>().unwrap());
        }

        // Check the last match
        if valid_numbers.contains_key(matches[matches.len() - 1].0.as_str()) {
            current.push(
                *valid_numbers
                    .get(matches[matches.len() - 1].0.as_str())
                    .unwrap(),
            );
        } else {
            current.push(matches[matches.len() - 1].0.parse::<u8>().unwrap());
        }

        let d = format!("{}{}", current[0], current[1]);
        calibrations.push(d.parse::<u8>().unwrap());
    }

    let sum: u32 = calibrations.iter().map(|x| *x as u32).sum();
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
        let input = read_lines("inputs/demo_1.txt");
        assert_eq!(part_1(&input), "142");
    }
    #[test]
    fn test_part_2() {
        let input = read_lines("inputs/demo_2.txt");
        assert_eq!(part_2(&input), "281");
    }
}
