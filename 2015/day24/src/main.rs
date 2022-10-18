use std::fs::File;
use std::io::{BufReader, BufRead};
use itertools::Itertools;
use std::collections::HashSet;

fn main() {
    let w = read_input("../24_input.txt");
    let e_min: usize = 113;
    let e_min = e_min.pow(6);
    for (i, j, k) in [(6, 6, 16), (6, 8, 14), (6, 10, 12), (8, 8, 12), (8, 10, 10)].iter().copied() {
        for p1 in w.iter().copied().combinations(i) {
            if p1.iter().sum::<usize>() == 516 && p1.iter().product::<usize>() < e_min {
                let ws: HashSet<usize> = w.iter().copied().collect();
                let p1s: HashSet<usize> = p1.into_iter().collect();
                for p2 in ws.difference(&p1s).copied().combinations(j) {
                    if p2.iter().sum() == 516 {
                        let p2s: HashSet<usize> = p2.into_iter().collect();
                        let p3s = ws.difference(&p1s).iter().difference(&p2s);
                        if p3s.sum() == 516 {
                            e_min = p1.product();
                        }
                    }
                }
            }
        }
    }
    e_min
}

fn read_input(filename: &str) -> Vec<usize> {
    let f = File::open(filename).expect("File not found");
    let f = BufReader::new(f);
    let w = f.lines().map(|l| l.unwrap().parse().unwrap()).collect();
    w
}