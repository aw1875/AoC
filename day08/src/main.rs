use num::integer::lcm;
use regex::Regex;

use std::collections::HashMap;
use std::iter::Cycle;
use std::slice::Iter;

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

struct Map<'a> {
    map: &'a HashMap<String, Vec<String>>,
    path: Cycle<Iter<'a, u8>>,
    node: &'a str,
}
impl<'a> Map<'a> {
    fn new(map: &'a HashMap<String, Vec<String>>, path: &'a [u8]) -> Self {
        Self {
            map,
            path: path.iter().cycle(),
            node: "AAA",
        }
    }

    fn start_at(mut self, node: &'a str) -> Self {
        self.node = node;
        self
    }
}
impl Iterator for Map<'_> {
    type Item = String;
    fn next(&mut self) -> Option<Self::Item> {
        if self.node == "ZZZ" {
            return None;
        }
        let temp = self.map.get(self.node)?;

        if self.path.next().unwrap() == &b'L' {
            self.node = temp[0].as_str();
        } else {
            self.node = temp[1].as_str();
        }

        Some(self.node.to_string())
    }
}

fn part_2(input: &str) -> String {
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

    let mut cycles = vec![];

    for start in lookup_table.keys().filter_map(|node| {
        if node.ends_with('A') {
            Some(node.to_string())
        } else {
            None
        }
    }) {
        let mut steps = 0;

        for node in Map::new(&lookup_table, directions.as_bytes()).start_at(&start) {
            steps += 1;
            if node.ends_with('Z') {
                cycles.push(steps);
                break;
            }
        }
    }

    return format!("{}", cycles.iter().fold(1u64, |acc, &x| lcm(acc, x)));
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
        assert_eq!(part_1(&input), "2");
    }

    #[test]
    fn test_part_1_2() {
        let input = include_str!("../inputs/demo1_2.txt");
        assert_eq!(part_1(&input), "6");
    }

    #[test]
    fn test_part_2() {
        let input = include_str!("../inputs/demo2.txt");
        assert_eq!(part_2(&input), "6");
    }
}
