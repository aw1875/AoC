use std::fs::read_to_string;

fn read_lines(filename: &str) -> Vec<String> {
    read_to_string(filename)
        .unwrap()
        .lines()
        .map(String::from)
        .collect()
}

#[derive(Debug, Eq, PartialEq, PartialOrd, Ord)]
enum HandCategory {
    HighCard,
    OnePair,
    TwoPair,
    ThreeOfAKind,
    FullHouse,
    FourOfAKind,
    FiveOfAKind,
}
impl HandCategory {
    fn from_cards(cards: &Vec<u32>, use_wilds: bool) -> Self {
        let mut counts: std::collections::HashMap<u32, u32> = std::collections::HashMap::new();

        let mut wild_count = 0;
        for card_val in cards {
            if use_wilds && *card_val == 1 {
                wild_count += 1;
            } else {
                counts.entry(*card_val).and_modify(|n| *n += 1).or_insert(1);
            }
        }

        let counts = counts.into_values().collect::<Vec<_>>();
        let max = counts.iter().max().unwrap_or(&0) + wild_count;
        match counts.len() {
            0 | 1 => Self::FiveOfAKind,
            2 if max == 4 => Self::FourOfAKind,
            2 => Self::FullHouse,
            3 if max == 3 => Self::ThreeOfAKind,
            3 => Self::TwoPair,
            4 => Self::OnePair,
            5 => Self::HighCard,
            _ => panic!("Invalid hand"),
        }
    }
}

#[derive(Debug, PartialEq, Eq)]
struct Hand {
    cards: Vec<u32>,
    bid: u32,
    kind: HandCategory,
}
impl Hand {
    fn card_as_value(card: char, using_joker: Option<bool>) -> u32 {
        let using_joker = using_joker.unwrap_or(false);

        match card {
            'A' => 14,
            'K' => 13,
            'Q' => 12,
            'J' => {
                if using_joker {
                    1
                } else {
                    11
                }
            }
            'T' => 10,
            '2'..='9' => card.to_digit(10).unwrap(),
            _ => panic!("Invalid card"),
        }
    }

    fn parse(cards: &str, bid: &str, use_wilds: Option<bool>) -> Self {
        let use_wilds = use_wilds.unwrap_or(false);

        let cards = cards
            .chars()
            .map(|c| Hand::card_as_value(c, Some(use_wilds)))
            .collect();
        let bid = bid.parse::<u32>().unwrap();
        let kind = HandCategory::from_cards(&cards, use_wilds);
        Hand { cards, bid, kind }
    }

    fn get_winnings(&self, rank: u32) -> u32 {
        return self.bid * rank;
    }
}
impl Ord for Hand {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        if self.kind != other.kind {
            self.kind.cmp(&other.kind)
        } else {
            self.cards.cmp(&other.cards)
        }
    }
}
impl PartialOrd for Hand {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

fn part_1(lines: &Vec<String>) -> String {
    let mut hands: Vec<Hand> = lines
        .iter()
        .map(|line| {
            let (cards, bid) = line.split_once(' ').unwrap();
            Hand::parse(cards, bid, None)
        })
        .collect();

    hands.sort();

    return format!(
        "{}",
        hands
            .iter()
            .enumerate()
            .map(|(i, hand)| hand.get_winnings((i + 1) as u32))
            .sum::<u32>()
    );
}

fn part_2(lines: &Vec<String>) -> String {
    let mut hands: Vec<Hand> = lines
        .iter()
        .map(|line| {
            let (cards, bid) = line.split_once(' ').unwrap();
            Hand::parse(cards, bid, Some(true))
        })
        .collect();

    hands.sort();

    return format!(
        "{}",
        hands
            .iter()
            .enumerate()
            .map(|(i, hand)| hand.get_winnings((i + 1) as u32))
            .sum::<u32>()
    );
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
        assert_eq!(part_1(&input), "6440");
    }

    #[test]
    fn test_part_2() {
        let input = read_lines("inputs/demo.txt");
        assert_eq!(part_2(&input), "5905");
    }
}
