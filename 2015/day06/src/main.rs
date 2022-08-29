use std::fs::File;
use std::io::{BufRead, BufReader};
use regex::Regex;
use std::cmp;

fn main() {
    let filename = "../06_input.txt";
    let instructions = read_input(filename);
    let re = Regex::new(r"([a-z\s]*)([0-9]*),([0-9]*) through ([0-9]*),([0-9]*)").unwrap();
    let mut grid = [[0; 1000]; 1000];
    for instruction in instructions {
        action(&mut grid, &instruction, &re, 1);
    }
    let lights: i32 = grid.iter().flatten().sum();
    println!("Part 1: {lights}");
    let instructions = read_input(filename);
    let mut grid = [[0; 1000]; 1000];
    for instruction in instructions {
        action(&mut grid, &instruction, &re, 2);
    }
    let lights: i32 = grid.iter().flatten().sum();
    println!("Part 2: {lights}");
}

fn read_input(filename: &str) -> Vec<String> {
    let mut res: Vec<String> = Vec::new();
    let f = File::open(&filename).expect("Could not open file");
    let f = BufReader::new(f);
    for line in f.lines() {
        res.push(line.unwrap());
    }
    return res;
}

fn action(grid: &mut [[i32; 1000]; 1000], instruction: &str, re: &Regex, part: usize) {
    let cap = re.captures(instruction).unwrap();
    let a = &cap[1];
    let x1: usize = cap.get(2).unwrap().as_str().parse().unwrap();
    let y1: usize = cap.get(3).unwrap().as_str().parse().unwrap();
    let x2: usize = cap.get(4).unwrap().as_str().parse().unwrap();
    let y2: usize = cap.get(5).unwrap().as_str().parse().unwrap();
    match a {
        "turn on " => {
            for x in x1..=x2 {
                for y in y1..=y2 {
                    if part == 1 {
                        grid[x][y] = 1;
                    } else {
                        grid[x][y] += 1;
                    }
                }
            }
        }
        "turn off " => {
            for x in x1..=x2 {
                for y in y1..=y2 {
                    if part == 1 {
                        grid[x][y] = 0;
                    } else {
                        grid[x][y] = cmp::max(grid[x][y] - 1, 0);
                    }
                }
            }
        }
        "toggle " => {
            for x in x1..=x2 {
                for y in y1..=y2 {
                    if part == 1 {
                        grid[x][y] = if grid[x][y] == 0 { 1 } else { 0 };
                    } else {
                        grid[x][y] += 2;
                    }
                }
            }
        }
        _ => (),
    }
}