use std::fs::File;
use std::io::{BufReader, BufRead};
use regex::Regex;
use std::iter::zip;

struct Ingredient {
    capacity: i32,
    durability: i32,
    flavor: i32,
    texture: i32,
    calories: i32
}

impl Ingredient {
    fn new(capacity: i32, durability: i32, flavor: i32, texture: i32, calories: i32) -> Ingredient {
        Ingredient {
            capacity,
            durability,
            flavor,
            texture,
            calories
        }
    }
}

fn main() {
    let ing = read_input("../15_input.txt");
    let max_score1 = calc_score(&ing, 1);
    let max_score2 = calc_score(&ing, 2);
    println!("Part 1: {max_score1}");
    println!("Part 2: {max_score2}");
}

fn calc_score(ing: &Vec<Ingredient>, part: i32) -> i32 {
    let mut max_score = 0;
    for i1 in 0..=100 {
        for i2 in 0..=100-i1 {
            for i3 in 0..=100-i2 {
                let mut score = 0;
                let i4 = 100 - i1 - i2 - i3;
                let amounts = [i1, i2, i3, i4];
                let a: i32 = zip(ing.iter(), amounts).map(|(x, y)| x.capacity * y).sum();
                let b: i32 = zip(ing.iter(), amounts).map(|(x, y)| x.durability * y).sum();
                let c: i32 = zip(ing.iter(), amounts).map(|(x, y)| x.flavor * y).sum();
                let d: i32 = zip(ing.iter(), amounts).map(|(x, y)| x.texture * y).sum();
                if part == 2 {
                    let e: i32 = zip(ing.iter(), amounts).map(|(x, y)| x.calories * y).sum();
                    if e != 500 {
                        continue;
                    }
                }
                if a > 0 && b > 0 && c > 0 && d > 0 {
                    score = a * b * c * d;
                }
                if score > max_score {
                    max_score = score;
                }
            }
        }
    }
    max_score
}

fn read_input(filename: &str) -> Vec<Ingredient> {
    let f = File::open(filename).expect("File not found");
    let f = BufReader::new(f);
    let re = Regex::new(r"(.*): capacity (.*), durability (.*), flavor (.*), texture (.*), calories (.*)").unwrap();
    let mut ing: Vec<Ingredient> = Vec::new();
    for line in f.lines() {
        let s = line.unwrap();
        let cap = re.captures(&s).unwrap();
        let capacity: i32 = cap.get(2).unwrap().as_str().parse().unwrap();
        let durability: i32 = cap.get(3).unwrap().as_str().parse().unwrap();
        let flavor: i32 = cap.get(4).unwrap().as_str().parse().unwrap();
        let texture: i32 = cap.get(5).unwrap().as_str().parse().unwrap();
        let calories: i32 = cap.get(6).unwrap().as_str().parse().unwrap();
        let tmp = Ingredient::new(capacity, durability, flavor, texture, calories);
        ing.push(tmp);
    }
    ing
}