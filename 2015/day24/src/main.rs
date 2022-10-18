use std::fs::File;
use std::io::{BufReader, BufRead};
use itertools::Itertools;
use std::collections::HashSet;

fn main() {
    let w = read_input("../24_input.txt");
    let part1 = calc_entanglement1(w);
    println!("Part 1: {part1}");
    let w = read_input("../24_input.txt");
    let part2 = calc_entanglement2(w);
    println!("Part 2: {part2}");
}

fn calc_entanglement1(w: Vec<usize>) -> usize {
    let mut e_min: usize = 113;
    e_min = e_min.pow(6);
    for (i, j, k) in [(6, 6, 16), (6, 8, 14), (6, 10, 12), (8, 8, 12), (8, 10, 10)].iter().copied() {
        for p1 in w.iter().copied().combinations(i) {
            if p1.iter().copied().sum::<usize>() == 516 && p1.iter().product::<usize>() < e_min {
                let ws: HashSet<usize> = w.iter().copied().collect();
                let p1s: HashSet<usize> = p1.iter().copied().collect();
                for p2 in ws.difference(&p1s).copied().combinations(j) {
                    if p2.iter().sum::<usize>() == 516 {
                        let p2s: HashSet<usize> = p2.into_iter().collect();
                        let p3s = ws.difference(&p1s).collect::<Vec<&usize>>();
                        let p3s: HashSet<usize> = p3s.into_iter().copied().collect();
                        let p3s = p3s.difference(&p2s).collect::<Vec<&usize>>();
                        //.difference(&p2s);
                        if p3s.into_iter().sum::<usize>() == 516 {
                            e_min = p1.iter().product();
                        }
                    }
                }
            }
        }
    }
    e_min
}

fn calc_entanglement2(w: Vec<usize>) -> usize {
    let mut e_min: usize = 113;
    e_min = e_min.pow(5);
    let mut ss = HashSet::new();
    for i in [5, 7] {
        for j in (i..(28 - 3 * i + 1)).step_by(2) {
            for k in (j..(28 - 2 * i - j + 1)).step_by(2) {
                let l = 28 - i - j - k;
                let mut sss = [i, j, k, l];
                sss.sort();
                let sss: (usize, usize, usize, usize) = (sss[0], sss[1], sss[2], sss[3]);
                ss.insert(sss);
            }
        }
    }
    //let s = ss.iter().copied().collect::<Vec<(usize, usize, usize, usize)>>();
    for (i, j, k, l) in ss.iter().copied() {
        for p1 in w.iter().copied().combinations(i) {
            if p1.iter().copied().sum::<usize>() == 387 && p1.iter().product::<usize>() < e_min {
                let ws: HashSet<usize> = w.iter().copied().collect();
                let p1s: HashSet<usize> = p1.iter().copied().collect();
                for p2 in ws.difference(&p1s).copied().combinations(j) {
                    if p2.iter().sum::<usize>() == 387 {
                        let p2s: HashSet<usize> = p2.into_iter().collect();
                        let p3s = ws.difference(&p1s).collect::<Vec<&usize>>();
                        let p3s: HashSet<usize> = p3s.into_iter().copied().collect();
                        let p3s = p3s.difference(&p2s).collect::<Vec<&usize>>();
                        let p3s: HashSet<usize> = p3s.into_iter().copied().collect();
                        for p3 in p3s.iter().copied().combinations(k) {
                            let p4s: HashSet<usize> = p3.into_iter().collect();
                            let p5s = p3s.difference(&p4s).collect::<Vec<&usize>>();
                            if p5s.into_iter().sum::<usize>() == 387 {
                                e_min = p1.iter().product();
                            }
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