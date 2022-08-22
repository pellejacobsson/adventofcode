use std::fs;
use std::collections::HashMap;

fn main() {
    let filename = String::from("../03_input.txt");
    let directions = read_input(filename);
    let presents1 = part1(&directions);
    let presents2 = part2(&directions);
    println!("Part 1: {presents1}");
    println!("Part 2: {presents2}");
}

fn read_input(filename: String) -> String {
    let input = fs::read_to_string(filename)
    .expect("Error reading file!");
    return input;
}

fn part1(directions: &str) -> usize {
    let mut visited = HashMap::new();
    let mut pos = (0, 0);
    visited.insert(pos, 1);
    for dir in directions.chars() {
        if dir == '^' {
            pos.1 += 1
        } else if dir == '>' {
            pos.0 += 1
        } else if dir == 'v' {
            pos.1 -= 1
        } else if dir == '<' {
            pos.0 -= 1
        }
        let count = visited.entry(pos).or_insert(0);
        *count += 1;
    }
    return visited.len();
}

fn part2(directions: &str) -> usize {
    let mut visited = HashMap::new();
    let mut pos1 = (0, 0);
    let mut pos2 = (0, 0);
    visited.insert(pos1, 1);
    for (i, dir) in directions.chars().enumerate() {
        let mut dx = 0;
        let mut dy = 0;
        if dir == '^' {
            dy = 1;
        } else if dir == '>' {
            dx = 1;
        } else if dir == 'v' {
            dy = -1;
        } else if dir == '<' {
            dx = -1;
        }
        if i % 2 == 0{
            pos1.0 += dx;
            pos1.1 += dy;
            let count = visited.entry(pos1).or_insert(0);
            *count += 1;
        } else {
            pos2.0 += dx;
            pos2.1 += dy;
            let count = visited.entry(pos2).or_insert(0);
            *count += 1;
        }
    }
    return visited.len();
}