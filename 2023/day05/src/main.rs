use regex::Regex;

fn part_1(lines: &str) -> String {
    let mut cleaned_lines = lines.lines().skip(2);

    let re = Regex::new(r"\b\d+\b").unwrap();

    let maps: Vec<Vec<(std::ops::Range<u64>, u64)>> = (0..7)
        .map(|_| {
            (&mut cleaned_lines)
                .skip(1)
                .take_while(|line| !line.is_empty())
                .map(|line| {
                    let mut entry = re
                        .find_iter(line)
                        .map(|m| m.as_str().parse::<u64>().unwrap());

                    let el: [_; 3] = std::array::from_fn(|_| entry.next().unwrap());
                    (el[1]..el[1] + el[2], el[0])
                })
                .collect()
        })
        .collect();

    println!("{:?}", maps);

    return "0".to_string();
}

fn test() {
    let input = include_bytes!("../inputs/demo.txt");
    let lines = input[7..input.iter().position(|b| b == &b'n').unwrap()].split(|b| b == &b' ');
    println!("{:?}", lines);

    let input_2 = include_str!("../inputs/demo.txt");
    let re = Regex::new(r"\s+").unwrap();
    let lines_2 = re
        .find_iter(input_2)
        .map(|m| m.as_str())
        .collect::<Vec<_>>();
    println!("{:?}", lines_2);
}

fn main() {
    let input = include_str!("../inputs/input.txt");
    println!("{}", part_1(input));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_test() {
        test();
        assert_eq!("0", "1");
    }

    // #[test]
    // fn test_part_1() {
    //     let input = include_str!("../inputs/demo.txt");
    //     assert_eq!(part_1(input), "35");
    // }
}
