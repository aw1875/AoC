use std::{collections::HashMap, fs::read_to_string};

fn read_lines(filename: &str) -> Vec<String> {
    read_to_string(filename)
        .unwrap()
        .lines()
        .map(String::from)
        .collect()
}

fn part_1(lines: &Vec<String>) -> String {
    let max: HashMap<&str, u8> = HashMap::from([("red", 12), ("green", 13), ("blue", 14)]);

    let mut possible_games: Vec<u8> = Vec::new();

    for line in lines {
        let mut current_game: HashMap<&str, u8> = HashMap::new();

        let game: Vec<&str> = line.split(':').collect();
        let id: u8 = game[0].split(' ').collect::<Vec<&str>>()[1]
            .parse()
            .unwrap();
        let details: &str = game[1].trim();
        if id == 0 {
            continue;
        }

        let curr: Vec<&str> = details.split(';').map(|x| x.trim()).collect();
        for sub in curr {
            let cubes: Vec<&str> = sub.split(',').map(|x| x.trim()).collect();

            for cube in cubes {
                let cube: Vec<&str> = cube.split(' ').map(|x| x.trim()).collect();
                let color: &str = cube[1];
                let value: u8 = cube[0].parse().unwrap();

                current_game.insert(color, value);
            }

            let mut valid: bool = true;
            for (color, value) in &current_game {
                if let Some(max_value) = max.get(color) {
                    if value > max_value {
                        valid = false;
                    }
                }
            }

            if !valid {
                current_game.clear();
                break;
            }
        }

        if !current_game.is_empty() {
            possible_games.push(id);
        }
    }

    let sum: u32 = possible_games.iter().map(|x| *x as u32).sum();
    return format!("{}", sum);
}

fn part_2(lines: &Vec<String>) -> String {
    let mut power_of_sets: Vec<u16> = Vec::new();

    for line in lines {
        let mut current_game: HashMap<&str, u8> = HashMap::new();

        let game: Vec<&str> = line.split(':').collect();
        let id: u8 = game[0].split(' ').collect::<Vec<&str>>()[1]
            .parse()
            .unwrap();
        let details: &str = game[1].trim();

        if id == 0 {
            continue;
        }

        let curr: Vec<&str> = details.split(';').map(|x| x.trim()).collect();
        for sub in curr {
            let cubes: Vec<&str> = sub.split(',').map(|x| x.trim()).collect();
            for cube in cubes {
                let cube: Vec<&str> = cube.split(' ').map(|x| x.trim()).collect();
                let color: &str = cube[1];
                let value: u8 = cube[0].parse().unwrap();

                current_game
                    .entry(color)
                    .and_modify(|current_value| {
                        if value > *current_value {
                            *current_value = value;
                        }
                    })
                    .or_insert(value);
            }
        }

        // Multiply all values together (and map to u16 since the value is more that u8 can hold)
        power_of_sets.push(current_game.values().copied().map(u16::from).product());
    }

    let sum: u32 = power_of_sets.iter().map(|x| *x as u32).sum();
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
        assert_eq!(part_1(&input), "8");
    }

    #[test]
    fn test_part_2() {
        let input = read_lines("inputs/demo.txt");
        assert_eq!(part_2(&input), "2286");
    }
}
