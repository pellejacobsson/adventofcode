use std::fs::File;
use std::io::{BufReader, BufRead};
use regex::Regex;

fn main() {
    let filename = "../08_input.txt";
    let input = read_input(filename);
    let re = Regex::new(r#"\\x[0-9a-f]{2}"#).unwrap();
    let mut delta = 0;
    let mut line_new: String;
    for line in &input {
        line_new = mem_chars(&line[1..line.len()-1], &re);
        delta += line.len() - line_new.len();
    }
    println!("Part 1: {delta}");
    delta = 0;
    for line in input {
        line_new = enc_chars(&line);
        delta += line_new.len() - line[1..line.len()-1].len();
    }
    println!("Part 2: {delta}");
}

fn read_input(filename: &str) -> Vec<String> {
    let mut res: Vec<String> = Vec::new();
    let f = File::open(filename).expect("Could not open file");
    let f = BufReader::new(f);
    for line in f.lines() {
        res.push(line.unwrap());
    }
    return res;
}

fn mem_chars(line: &str, re: &Regex) -> String {
    let line_new = line.replace(r#"\\"#, r#"\"#);
    let line_new = line_new.replace(r#"\""#, r#"""#);
    let line_new = re.replace_all(&line_new, "X").into_owned();
    return line_new;
}

fn enc_chars(line: &str) -> String {
    let line_new = line.replace(r#"\"#, r#"\\"#);
    let line_new = line_new.replace(r#"""#, r#"\""#);
    return line_new;
}