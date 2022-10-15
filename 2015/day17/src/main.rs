use std::fs::File;
use std::io::{BufReader, BufRead};
use itertools::Itertools;

fn main() {
    let containers = read_input("../17_input.txt");
    let mut fits = Vec::new();
    for n in 1..=containers.len() {
        for c in containers.iter().copied().combinations(n) {
            if c.iter().copied().sum::<i32>() == 150 {
                fits.push(c);
            }
        }
    }
    let n_containers: Vec<usize> = fits.iter().map(|c| c.len()).collect();
    let min_containers = n_containers.iter().min().unwrap();
    let n_min_containers = n_containers.iter().filter(|&l| l == min_containers).count();
    println!("Part 1: {}", fits.len());
    println!("Part 2: {n_min_containers}");
}

fn read_input(filename: &str) -> Vec<i32> {
    let f = File::open(filename).expect("File not found");
    let f = BufReader::new(f);
    f.lines().map(|l| l.unwrap().parse().unwrap()).collect()
}