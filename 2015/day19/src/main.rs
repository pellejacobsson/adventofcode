use std::fs::File;
use std::io::{BufReader, BufRead};
use std::collections::{HashMap, HashSet};
use regex::Regex;

fn main() {
    let (recipes, mut molecule) = read_input("../19_input.txt");
    let n1 = part1(&recipes, &molecule);
    let n2 = part2(&recipes, &mut molecule);
    println!("Part 1: {n1}");
    println!("Part 2: {n2}");
}

fn part1(recipes: &HashMap<String, Vec<String>>, molecule: &str) -> usize {
    let mut molecules = HashSet::new();
    for (orig, replacements) in recipes {
        for replacement in replacements {
            let new_molecules = sub(&molecule, &orig, &replacement);
            molecules.extend(new_molecules);
        }
    }
    molecules.len()
}

fn part2(recipes: &HashMap<String, Vec<String>>, molecule: &mut String) -> usize {
    let mut recipes_rev = HashMap::new();
    for (orig, replacements) in recipes {
        for replacement in replacements {
            recipes_rev.insert(replacement.to_string(), orig.to_string());
        }
    }
    let mut n = 0;
    while molecule != "e" {
        for (orig, reduced) in &recipes_rev {
            if molecule.contains(orig) {
                *molecule = molecule.replacen(orig, &reduced, 1);
                n += 1;
            }
        }
    }
    n
}

fn sub(string: &str, orig: &str, replacement: &str) -> HashSet<String> {
    let mut new_strings = HashSet::new();
    for pos in Regex::new(orig).unwrap().find_iter(string) {
        let start = pos.start();
        let end = pos.end();
        let mut new_string = string.clone().to_string();
        new_string.replace_range(start..end, replacement);
        new_strings.insert(new_string);
    }
    new_strings
}

fn read_input(filename: &str) -> (HashMap<String, Vec<String>>, String) {
    let f = File::open(filename).expect("File not found");
    let f = BufReader::new(f);
    let mut d = HashMap::new();
    let lines: Vec<String> = f.lines().map(|x| x.unwrap().to_string()).collect();
    for line in &lines[0..lines.len()-2] {
        let s: Vec<String> = line.split(" => ").map(|x| x.to_string()).collect();
        let key = s[0].to_string();
        let val = s[1].to_string();
        d.entry(key).or_insert(Vec::new()).push(val);
    }
    let m = &lines[lines.len()-1];
    (d, m.to_string())
}