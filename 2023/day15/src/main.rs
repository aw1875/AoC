use std::collections::HashMap;

fn hash(input: &str) -> usize {
    let mut hash = 0;

    for c in input.chars() {
        let ascii = c as usize;
        hash += ascii;
        hash *= 17;
        hash %= 256;
    }

    return hash;
}

fn part_1(input: &str) -> String {
    let mut sum = 0;

    for sub in input.split(",") {
        sum += hash(sub.trim());
    }

    return sum.to_string();
}

fn split_helper(sub: &str) -> (String, char, usize) {
    if sub.contains('-') {
        let split: Vec<&str> = sub.split('-').collect();
        return (split[0].to_string(), '-', 0);
    }

    let split: Vec<&str> = sub.split('=').collect();
    return (
        split[0].to_string(),
        '=',
        split[1].parse::<usize>().unwrap(),
    );
}

#[derive(Debug)]
struct Lens {
    name: String,
    focal_length: usize,
}

fn part_2(input: &str) -> String {
    let mut boxes: HashMap<usize, Vec<Lens>> = HashMap::new();

    for sub in input.replace('\n', "").split(",") {
        let (key, action, value) = split_helper(sub.trim());
        let hash = hash(&key);
        let lens = Lens {
            name: key.to_owned(),
            focal_length: value,
        };

        if boxes.get(&hash).is_none() {
            boxes.insert(hash, vec![]);
        }

        if action == '-' {
            boxes.get_mut(&hash).unwrap().retain(|x| x.name != key);
        } else {
            if boxes.get(&hash).unwrap().iter().any(|x| x.name == key) {
                boxes
                    .get_mut(&hash)
                    .unwrap()
                    .iter_mut()
                    .find(|x| x.name == key)
                    .unwrap()
                    .focal_length = value;
            } else {
                boxes.get_mut(&hash).unwrap().push(lens);
            }
        }
    }

    let mut focus_power = 0;
    for (hash, box_list) in boxes.iter() {
        if box_list.len() == 0 {
            continue;
        }

        focus_power += (hash + 1)
            * box_list
                .iter()
                .enumerate()
                .fold(0, |acc, (i, x)| acc + (i + 1) * x.focal_length);
    }

    return focus_power.to_string();
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
        assert_eq!(part_1(&input), "1320");
    }

    #[test]
    fn test_part_2() {
        let input = include_str!("../inputs/demo.txt");
        assert_eq!(part_2(&input), "145");
    }
}
