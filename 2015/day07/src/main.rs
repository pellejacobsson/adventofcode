use std::fs::File;
use std::io::{BufReader, BufRead};
use std::collections::HashMap;

fn main() {
    let filename = "../07_input.txt";
    let booklet = read_input(filename);
}

fn read_input(filename: &str) -> HashMap<String,Vec<String>> {
    let f = File::open(&filename).expect("Could not open file");
    let f = BufReader::new(f);
    let mut booklet = HashMap::new();
    for line in f.lines() {
        let l = line.unwrap();
        let l: Vec<_> = l.split(" -> ").collect();
        let key = String::from(l[1]);
        let val = String::from(l[0]);
        let val: Vec<String> = val.split(" ").into_iter().map(String::from).collect();
        booklet.insert(key, val);
    }
    return booklet;
}

fn signal(booklet: &mut HashMap<String, Vec<String>>, wire: &str) -> String {
    if wire.parse::<i32>().is_ok() {
        return String::from(wire);
    } else {
        let instruction = &booklet[wire];
        if instruction.len() == 1 {
            let value = &instruction[0];
            if wire.parse::<i32>().is_ok() {
                return String::from(value);
            } else {
                let res = signal(booklet, value);
                booklet.insert(String::from(wire), vec![res]);
                return res;
            }
        } else if instruction.len() == 2 {
            let value = String::from(&instruction[1]);
            let res = (!value.parse::<u16>().unwrap()).to_string();
            booklet.insert(String::from(wire), vec![res]);
            return res;
        } else if instruction.len() == 3 {
            let value1 = signal(booklet, &instruction[0]).parse::<u16>().unwrap();
            let value2 = signal(booklet, &instruction[1]).parse::<u16>().unwrap();
            let op = &instruction[1];
            let mut res: u16 = 0;
            match op.as_str() {
                "AND" => res = value1 & value2,
                "OR" => res = value1 | value2,
                "RSHIFT" => res = value1 >> value2,
                "LSHIFT" => res = value1 << value2,
                _ => (),
            }
            booklet.insert(String::from(wire), vec![res.to_string()]);
            return res.to_string();
        } else {
            return String::from("Error");
        }
    }
}