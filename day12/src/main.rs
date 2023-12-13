use memoize::memoize;

#[memoize]
fn count_arrangements(row: String, group: Vec<usize>) -> usize {
    if row == "" {
        return if group.len() == 0 { 1 } else { 0 };
    }

    if group.len() == 0 {
        return if row.contains('#') { 0 } else { 1 };
    }

    let mut arrangements = 0;

    if ".?".contains(row.chars().nth(0).unwrap()) {
        arrangements += count_arrangements(row[1..].to_owned(), group.to_owned());
    }

    if "#?".contains(row.chars().nth(0).unwrap()) {
        if group[0] <= row.len()
            && !row[..group[0]].contains('.')
            && (group[0] == row.len() || row.chars().nth(group[0]).unwrap() != '#')
        {
            if group[0] + 1 > row.len() {
                arrangements += count_arrangements("".to_owned(), group[1..].to_owned());
            } else {
                arrangements +=
                    count_arrangements(row[group[0] + 1..].to_owned(), group[1..].to_owned());
            }
        }
    }

    return arrangements;
}

fn unfold_record(row: String, group: Vec<usize>) -> (String, Vec<usize>) {
    let mut new_row = String::new();
    for _ in 0..4 {
        new_row.push_str(&row);
        new_row.push('?');
    }
    new_row.push_str(&row);

    let mut new_group = vec![];
    for _ in 0..5 {
        new_group.extend(group.to_owned());
    }
    return (new_row, new_group);
}

fn part_1(input: &str) -> String {
    let mut total = 0;

    for line in input.lines() {
        let (row, group) = line.split_once(' ').unwrap();
        let group: Vec<usize> = group
            .split(',')
            .map(|x| x.parse::<usize>().unwrap())
            .collect();

        total += count_arrangements(row.to_owned(), group);
    }

    return format!("{}", total);
}

fn part_2(input: &str) -> String {
    let mut total = 0;

    for line in input.lines() {
        let (row, group) = line.split_once(' ').unwrap();
        let group: Vec<usize> = group
            .split(',')
            .map(|x| x.parse::<usize>().unwrap())
            .collect();

        let (row, group) = unfold_record(row.to_owned(), group);
        total += count_arrangements(row.to_owned(), group);
    }

    return format!("{}", total);
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
        assert_eq!(part_1(&input), "21");
    }

    #[test]
    fn test_part_2() {
        let input = include_str!("../inputs/demo.txt");
        assert_eq!(part_2(&input), "525152");
    }
}
