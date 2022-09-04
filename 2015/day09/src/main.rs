use std::fs::File;
use std::io::{BufReader, BufRead};
use regex::Regex;
use std::collections::{HashMap, HashSet};
use itertools::Itertools;
use std::usize;

fn main() {
    let (dist, all_cities) = read_input("../09_input.txt");
    let cities_perm = all_cities.iter().permutations(all_cities.len());
    let mut d_min = usize::max_value();
    let mut d_max = 0;
    for cities in cities_perm {
        let d = calc_route(&dist, cities);
        if d < d_min {
            d_min = d;
        }
        if d > d_max {
            d_max = d;
        }
    }
    println!("Part 1: {d_min}");
    println!("Part 2: {d_max}");
}

fn read_input(filename: &str) -> (HashMap<(String, String), usize>, HashSet<String>) {
    let re = Regex::new("([a-zA-Z]*) to ([a-zA-Z]*) = ([0-9]*)").unwrap();
    let f = File::open(filename).expect("Could not open file");
    let f = BufReader::new(f);
    let mut dist = HashMap::new();
    let mut cities = HashSet::new();
    for line in f.lines() {
        let s = line.unwrap();
        let cap = re.captures(&s).unwrap();
        dist.insert((cap[1].to_owned(), cap[2].to_owned()), cap.get(3).unwrap().as_str().parse().unwrap());
        dist.insert((cap[2].to_owned(), cap[1].to_owned()), cap.get(3).unwrap().as_str().parse().unwrap());
        cities.insert(cap[1].to_owned());
        cities.insert(cap[2].to_owned());
    }
    return (dist, cities);
}

fn calc_route(dist: &HashMap<(String, String), usize>, cities: Vec<&String>) -> usize {
    let mut d = 0;
    for (city1, city2) in cities.iter().zip(cities.iter().skip(1)) {
        d += dist.get(&(city1.to_string(), city2.to_string())).unwrap();
    }
    return d;
}