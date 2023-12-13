use regex::Regex;
use std::collections::HashMap;

fn part_1(input: &str) -> String {
    let mut lookup_table: HashMap<String, Vec<String>> = HashMap::new();

    let re = Regex::new(r"\w+").unwrap();

    let directions = input.lines().nth(0).unwrap();

    for line in input.lines().skip(2) {
        let (key, values) = line.split_once(" = ").unwrap();

        // Given (BBB, CCC) use regex to extract to [BBB, CCC]
        let values: Vec<String> = re
            .find_iter(values)
            .map(|m| m.as_str().to_string())
            .collect();

        lookup_table.insert(key.to_string(), values);
    }

    let mut current_key = "AAA";
    let mut steps = 0;

    while current_key != "ZZZ" {
        let next_key = lookup_table.get(current_key);

        if directions.chars().nth(steps % directions.len()).unwrap() == 'L' {
            current_key = next_key.unwrap()[0].as_str();
        } else {
            current_key = next_key.unwrap()[1].as_str();
        }

        steps += 1;
    }

    return steps.to_string();
}

fn main() {
    let input = include_str!("../inputs/input.txt");
    println!("{}", part_1(&input));
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn test_part_1() {
        let input = include_str!("../inputs/demo.txt");
        assert_eq!(part_1(&input), "2");
    }

    #[test]
    fn test_part_1_2() {
        let input = include_str!("../inputs/demo1_2.txt");
        assert_eq!(part_1(&input), "6");
    }
}
