use std::fs::File;
use std::io::BufReader;
use std::io::BufRead;


fn main() {
    let filename = String::from("../05_input.txt");
    let input = read_input(filename);
    let nices: i32 = input.iter().map(|s| is_nice(s, 1) as i32).sum();
    println!("Part 1: {nices}");
    let nices: i32 = input.iter().map(|s| is_nice(s, 2) as i32).sum();
    println!("Part 2: {nices}");
}

fn read_input(filename: String) -> Vec<String> {
    let mut res: Vec<String> = Vec::new();
    let f = File::open(&filename).expect("Couldn't open file");
    let f = BufReader::new(f);
    for line in f.lines() {
        res.push(line.unwrap());
    }
    return res;
}

fn contains_vowels(s: &str) -> bool {
    let vowels = "aeiou";
    let n_vowels: i32 = s.chars().map(|l| vowels.contains(l) as i32 ).sum();
    return n_vowels > 2;
}

fn repeats(s: &str, part: i32) -> bool {
    let mut s1 = s.chars();
    let mut s2 = s.chars();
    s2.next();
    if part == 2 {
        s2.next();
    }
    while let Some((l1, l2)) = s1.next().zip(s2.next()) {
        if l1 == l2 {
            return true;
        }
    }
    return false;
}

fn contains_specials(s: &str) -> bool {
    let specials = vec!["ab", "cd", "pq", "xy"];
    for special in specials.iter() {
        if s.contains(special) {
            return true;
        }
    }
    return false;
}

fn appears_twice(s: &str) -> bool {
    for i in 0..s.len()-1 {
        let s0 = &s[i..i+2];
        let s1 = &s[..i];
        let s2 = &s[i+2..];
        if s1.contains(&s0) || s2.contains(&s0) {
            return true;
        }
    }
    return false;
}

fn is_nice(s: &str, part: i32) -> bool {
    if part == 1 {
        return contains_vowels(s) && repeats(s, 1) && !contains_specials(s);
    } else {
        return repeats(s, 2) && appears_twice(s);
    }
}