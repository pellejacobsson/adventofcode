use std::fs::File;
use std::io::{BufReader, BufRead};
use std::collections::HashMap;

struct Computer {
    reg: HashMap<String, i32>,
    i: i32,
    instructions: Vec<Vec<String>>

}

impl Computer {
    fn new(instructions: Vec<Vec<String>>, i: i32, a: i32, b: i32) -> Computer {
        Computer {
            reg: HashMap::from([(String::from("a"), a), (String::from("b"), b)]),
            i,
            instructions
        }
    }
}

fn main() {
    let instructions = read_input("../23_input.txt");
    let c = Computer::new(instructions, 0, 0, 0);
}

fn read_input(filename: &str) -> Vec<Vec<String>> {
    let f = File::open(filename).expect("File not found");
    let f = BufReader::new(f);
    let instructions = Vec::new();
    for line in f.lines() {
        let mut cmd: Vec<String> = line.unwrap().to_owned().split(" ").map(|x| x.to_string()).collect();
        if cmd[1].len() == 2 && cmd[1].as_bytes()[1] == ',' as u8 {
            cmd[1] = (cmd[1].as_bytes()[0] as char).to_string();
        } 
    }
    instructions
}