
use std::fs::File;
use std::io::BufReader;
use std::io::prelude::*;

fn main() {
    let filename = String::from("../02_input.txt");
    let input = read_input(filename);
    let mut s: u64 = 0;
    let mut l: u64 = 0;
    for line in input {
        s += calc_area(&line);
        l += calc_ribbon(&line);
    }
    println!("Part 1: {s}");
    println!("Part 2: {l}");
}

fn calc_area(package: &str) -> u64 {
    let sides: Vec<&str> = package.split('x').collect();
    let mut sides: Vec<u64> = sides.iter().map(|s| s.parse().unwrap()).collect();
    sides.sort();
    let s: u64 = 3 * sides[0] * sides[1] + 2 * sides[0] * sides[2] + 2 * sides[1] * sides[2];
    return s;
}

fn calc_ribbon(package: &str) -> u64 {
    let sides: Vec<&str> = package.split('x').collect();
    let mut sides: Vec<u64> = sides.iter().map(|s| s.parse().unwrap()).collect();
    sides.sort();
    let l: u64 = 2 * sides[0] + 2 * sides[1] + sides[0] * sides[1] * sides[2];
    return l;
}

fn read_input(filename: String) -> Vec<String> {
    let mut res: Vec<String> = Vec::new();
    let f = File::open(&filename).expect("Can't open file");
    let f = BufReader::new(f);
    for line in f.lines() {
        res.push(line.unwrap());
    }
    return res;
}