use regex::Regex;

fn find_sequence(numbers: &Vec<i32>) -> i32 {
    let mut sequence: Vec<i32> = Vec::new();

    for i in 1..numbers.len() {
        let diff = numbers[i] - numbers[i - 1];
        sequence.push(diff);
    }

    if sequence.iter().all(|&x| x == 0) {
        return numbers[numbers.len() - 1] - sequence[sequence.len() - 1];
    }

    return numbers[numbers.len() - 1] + find_sequence(&sequence);
}

fn part_1(lines: &str) -> String {
    let mut differences: Vec<i32> = Vec::new();
    let pattern = Regex::new(r"-?\d+").unwrap();

    for line in lines.lines() {
        let numbers = pattern
            .find_iter(line)
            .map(|x| x.as_str().parse::<i32>().unwrap())
            .collect::<Vec<i32>>();

        let result = find_sequence(&numbers);
        differences.push(result);
    }

    return format!("{}", differences.iter().sum::<i32>());
}

fn part_2(lines: &str) -> String {
    let mut differences: Vec<i32> = Vec::new();
    let pattern = Regex::new(r"-?\d+").unwrap();

    for line in lines.lines() {
        let mut numbers = pattern
            .find_iter(line)
            .map(|x| x.as_str().parse::<i32>().unwrap())
            .collect::<Vec<i32>>();

        numbers.reverse();
        let result = find_sequence(&numbers);
        differences.push(result);
    }

    return format!("{}", differences.iter().sum::<i32>());
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
        assert_eq!(part_1(&input), "114");
    }

    #[test]
    fn test_part_2() {
        let input = include_str!("../inputs/demo.txt");
        assert_eq!(part_2(&input), "2");
    }
}
