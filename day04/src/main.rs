use regex::Regex;
use std::fs::read_to_string;

fn read_lines(filename: &str) -> Vec<String> {
    read_to_string(filename)
        .unwrap()
        .lines()
        .map(String::from)
        .collect()
}

#[derive(Debug)]
struct Card {
    winning_numbers: Vec<String>,
}

impl Card {
    fn get_points(&self) -> u16 {
        if self.winning_numbers.len() == 0 {
            return 0;
        }

        return 2u16.pow((self.winning_numbers.len() - 1) as u32);
    }
}

fn part_1(lines: &Vec<String>) -> String {
    let mut winning_cards: Vec<Card> = Vec::new();

    let pattern = Regex::new(
        r"Card\s+(?P<card_num>\d+):\s+(?P<winning_numbers>[\d\s]+)\s*\|\s*(?P<card_numbers>[\d\s]+)",
    )
    .unwrap();

    for entry in lines {
        if let Some(captures) = pattern.captures(entry) {
            let winning_numbers: Vec<u16> = captures["winning_numbers"]
                .split_whitespace()
                .map(|x| x.parse().unwrap())
                .collect();
            let card_numbers: Vec<u16> = captures["card_numbers"]
                .split_whitespace()
                .map(|x| x.parse().unwrap())
                .collect();

            let matches = winning_numbers
                .iter()
                .filter(|&x| card_numbers.contains(x))
                .collect::<Vec<&u16>>();

            if matches.len() > 0 {
                winning_cards.push(Card {
                    winning_numbers: matches.iter().map(|x| x.to_string()).collect(),
                });
            }
        }
    }

    return format!(
        "{}",
        winning_cards.iter().map(|x| x.get_points()).sum::<u16>()
    );
}

fn part_2(lines: &Vec<String>) -> String {
    let pattern = Regex::new(
        r"Card\s+(?P<card_num>\d+):\s+(?P<winning_numbers>[\d\s]+)\s*\|\s*(?P<card_numbers>[\d\s]+)",
    )
    .unwrap();
    let mut cards: Vec<usize> = vec![1; lines.len()];

    for entry in lines {
        if let Some(captures) = pattern.captures(entry) {
            let card_number = captures["card_num"].parse::<usize>().unwrap();
            let winning_numbers: Vec<u16> = captures["winning_numbers"]
                .split_whitespace()
                .map(|x| x.parse().unwrap())
                .collect();
            let card_numbers: Vec<u16> = captures["card_numbers"]
                .split_whitespace()
                .map(|x| x.parse().unwrap())
                .collect();

            let matches = winning_numbers
                .iter()
                .filter(|&x| card_numbers.contains(x))
                .count();

            for idx in 0..matches {
                cards[card_number + idx] += cards[card_number - 1];
            }
        }
    }

    return format!("{}", cards.iter().sum::<usize>());
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
        assert_eq!(part_1(&input), "13");
    }

    #[test]
    fn test_part_2() {
        let input = read_lines("inputs/demo.txt");
        assert_eq!(part_2(&input), "30");
    }
}
