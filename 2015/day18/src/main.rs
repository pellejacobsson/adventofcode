use std::fs::File;
use std::io::{BufReader, BufRead};
use ndarray::prelude::*;

fn main() {
    let mut grid = read_input("../18_input.txt");
    for _ in 0..100 {
        step(&mut grid, false);
    }
    println!("{:?}", grid.sum());
    grid = read_input("../18_input.txt");
    grid[[1, 1]] = 1;
    grid[[1, 100]] = 1;
    grid[[100, 1]] = 1;
    grid[[100, 100]] = 1;
    for _ in 0..100 {
        step(&mut grid, true);
    }
    println!("{:?}", grid.sum());
}

fn step(grid: &mut Array2<i32>, part2: bool) {
    let ogrid = grid.clone();
    for i in 1..=100 {
        for j in 1..=100 {
            if part2 {
                if ((i, j) == (1, 1)) || ((i, j) == (1, 100)) || ((i, j) == (100, 1)) || ((i, j) == (100, 100))  {
                    continue;
                }
            }
            let n_neighbors = ogrid.slice(s![i-1..=i+1, j-1..=j+1]).sum() - ogrid[[i, j]];
            if grid[[i, j]] == 1 {
                grid[[i, j]] = if (n_neighbors == 2) || (n_neighbors == 3) { 1 } else { 0 }
            } else {
                grid[[i, j]] = if n_neighbors == 3 { 1 } else { 0 }
            }
        }
    }
}

fn read_input(filename: &str) -> Array2<i32> {
    let f = File::open(filename).expect("File not found");
    let f = BufReader::new(f);
    let mut grid = Array::zeros((102, 102));
    for (i, line) in f.lines().enumerate() {
        for (j, c) in line.unwrap().chars().enumerate() {
            grid[[i+1, j+1]] = if c == '#' { 1 } else { 0 };
        }
    }
    grid
}