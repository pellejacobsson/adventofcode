use std::fs::File;
use std::io::{BufReader, BufRead};
use regex::Regex;
use std::collections::HashMap;

fn main() {
    let filename = "../16_input.txt";
    let aunt1 = which_aunt(filename, 1).unwrap();
    let aunt2 = which_aunt(filename, 2).unwrap();
    println!("Part 1: {aunt1}");
    println!("Part 2: {aunt2}");
}

fn which_aunt(filename: &str, part: i32) -> Option<usize> {
    let (aunts, mfcsam) = read_input(filename);
    for (i, aunt) in aunts.iter().enumerate() {
        let mut m = true;
        for (k, v) in &mfcsam {
            if let Some(&am) = aunt.get(k) {
                if part == 2 && ["cats", "trees"].contains(&&k[..]) {
                    if am <= *v {
                        m = false;
                    }
                } else if part == 2 && ["pomeranians", "goldfish"].contains(&&k[..]) {
                    if am >= *v {
                        m = false;
                    }
                } else if am != *v {
                    m = false;
                }
            }
        }
        if m {
            return Some(i + 1);
        }
    }
    return None;
}

fn read_input(filename: &str) -> (Vec<HashMap<String, i32>>, HashMap<String, i32>) {
    let f = File::open(filename).expect("File not found");
    let f = BufReader::new(f);
    let re = Regex::new(r"^Sue (\d+?): (.*): (\d+?), (.*): (\d+?), (.*): (\d+?)*$").unwrap();
    let mut aunts: Vec<HashMap<String, i32>> = Vec::new();
    for line in f.lines() {
        let s = line.unwrap();
        let cap = re.captures(&s).unwrap();
        let mut h = HashMap::new();
        for i in (2..cap.len()-1).step_by(2) {
            h.insert(String::from(&cap[i]), String::from(&cap[i+1]).parse().unwrap());
        }
        aunts.push(h);
    }
    let mfcsam = HashMap::from([
        (String::from("children"), 3),
        (String::from("cats"), 7),
        (String::from("samoyeds"), 2),
        (String::from("pomeranians"), 3),
        (String::from("akitas"), 0),
        (String::from("vizslas"), 0),
        (String::from("goldfish"), 5),
        (String::from("trees"), 3),
        (String::from("cars"), 2),
        (String::from("perfumes"), 1)
    ]);
    (aunts, mfcsam)
}