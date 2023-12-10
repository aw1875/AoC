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
struct Race {
    time: u32,
    distance: u32,
}

fn part_1(lines: &Vec<String>) -> String {
    let mut races: Vec<Race> = Vec::new();
    let mut winning_combos: Vec<u8> = Vec::new();

    let pattern = Regex::new(r"\b\d+\b").unwrap();

    let times: Vec<&str> = pattern.find_iter(&lines[0]).map(|m| m.as_str()).collect();
    let distances: Vec<&str> = pattern.find_iter(&lines[1]).map(|m| m.as_str()).collect();

    for i in 0..distances.len() {
        races.push(Race {
            time: times[i].parse::<u32>().unwrap(),
            distance: distances[i].parse::<u32>().unwrap(),
        });
    }

    for race in races {
        let mut combos: u8 = 0;

        for i in 0..race.time {
            let distance = i * (race.time - i);

            if distance > race.distance {
                combos += 1;
            }
        }

        winning_combos.push(combos);
    }

    return format!(
        "{}",
        winning_combos.iter().map(|&x| x as u32).product::<u32>()
    );
}

fn part_2(lines: &Vec<String>) -> String {
    let mut winning_combos: u64 = 0;

    let pattern = Regex::new(r"\b\d+\b").unwrap();

    let time: u32 = pattern
        .find_iter(&lines[0])
        .map(|m| m.as_str())
        .collect::<String>()
        .parse::<u32>()
        .unwrap();
    let distance: u64 = pattern
        .find_iter(&lines[1])
        .map(|m| m.as_str())
        .collect::<String>()
        .parse::<u64>()
        .unwrap();

    for i in 0..time {
        let curr_distance: u64 = i as u64 * (time - i) as u64;

        if curr_distance > distance {
            winning_combos += 1;
        }
    }

    return format!("{}", winning_combos);
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
        assert_eq!(part_1(&input), "288");
    }

    #[test]
    fn test_part_2() {
        let input = read_lines("inputs/demo.txt");
        assert_eq!(part_2(&input), "71503");
    }
}
