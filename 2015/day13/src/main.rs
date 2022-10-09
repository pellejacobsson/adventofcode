use std::fs::File;
use std::io::{BufReader, BufRead};
use regex::Regex;
use std::collections::{HashMap, HashSet};
use itertools::Itertools;

fn main() {
    let (mut scores, mut names) = read_input("../13_input.txt");
    let max_score1 = calc_max_happiness(&mut scores, &mut names, 1);
    println!("Part 1: {max_score1}");
    let max_score2 = calc_max_happiness(&mut scores, &mut names, 2);
    println!("Part 2: {max_score2}");
}

fn calc_max_happiness(scores: &mut HashMap<(String, String), i32>, names: &mut Vec<String>, part: usize) -> i32 {
    if part == 2 {
        for name in names.iter() {
            scores.insert(("Pelle".to_owned(), name.to_owned()), 0);
            scores.insert((name.to_owned(), "Pelle".to_owned()), 0);
        }
        names.push("Pelle".to_owned());
    }
    let mut max_score = i32::min_value();
    let n_names = names.len();
    for order in names.iter().permutations(n_names) {
        let score = calculate_happiness(&scores, &order);
        if score > max_score {
            max_score = score;
        }
    }
    max_score
}

fn read_input(filename: &str) -> (HashMap<(String, String), i32>, Vec<String>) {
    let re = Regex::new("(.*) would (lose|gain) ([0-9]*) happiness units by sitting next to (.*).").unwrap();
    let f = File::open(filename).expect("Could not open file");
    let f = BufReader::new(f);
    let mut scores = HashMap::new();
    let mut names = HashSet::new();
    for line in f.lines() {
        let s = line.unwrap();
        let cap = re.captures(&s).unwrap();
        let name1 = cap[1].to_owned();
        let name2 = cap[4].to_owned();
        let gain = &cap[2] == "gain";
        let mut val: i32 = cap.get(3).unwrap().as_str().parse().unwrap();
        if !gain {
            val = -val;
        }
        scores.insert((name1, name2), val);
        names.insert(cap[1].to_owned());
        names.insert(cap[4].to_owned());
    }
    return (scores, names.into_iter().collect());
}

fn calculate_happiness(scores: &HashMap<(String, String), i32>, order: &Vec<&String>) -> i32 {
    let mut score = 0;
    for i in 0..order.len() {
        let j = if i == order.len() - 1 { 0 } else { i + 1 };
        score += scores.get(&(order[i].to_string(), order[j].to_string())).unwrap() + 
            scores.get(&(order[j].to_string(), order[i].to_string())).unwrap();
    }
    score
}