use std::fs::File;
use std::io::{BufReader, BufRead};
use std::collections::HashMap;

struct Computer {
    reg: HashMap<String, i32>,
    i: usize,
    instructions: Vec<Vec<String>>

}

impl Computer {
    fn new(instructions: Vec<Vec<String>>, i: usize, a: i32, b: i32) -> Computer {
        Computer {
            reg: HashMap::from([(String::from("a"), a), (String::from("b"), b)]),
            i,
            instructions
        }
    }
}

fn run_cmd(c: &mut Computer) -> i32 {
    if c.i >= c.instructions.len() {
        return 0;
    }
    let cmd = &c.instructions[c.i][0];
    let par = &c.instructions[c.i][1..];
    let mut status = 1;
    if cmd == "hlf" {
        let p = &par[0];
        *c.reg.entry(p.to_string()).or_insert(0) /= 2;
        c.i += 1;
    } else if cmd == "tpl" {
        let p = &par[0];
        *c.reg.entry(p.to_string()).or_insert(0) *= 3;
        c.i += 1;
    } else if cmd == "inc" {
        let p = &par[0];
        *c.reg.entry(p.to_string()).or_insert(0) += 1;
        c.i += 1;
    } else if cmd == "jmp" {
        let mut p: i32 = (&par[0][1..]).to_string().parse().unwrap();
        if par[0].as_bytes()[0] == '-' as u8 {
            p *= -1;
        }
        c.i = (c.i as i32 + p) as usize;
    } else if cmd == "jie" {
        let p1 = &par[0];
        let mut p2: i32 = (&par[1][1..]).to_string().parse().unwrap();
        if par[1].as_bytes()[0] == '-' as u8 {
            p2 *= -1;
        }
        if c.reg.get(p1).unwrap() % 2 == 0 {
            c.i = (c.i as i32 + p2) as usize;
        } else {
            c.i += 1;
        }
    } else if cmd == "jio" {
        let p1 = &par[0];
        let mut p2: usize = (&par[1][1..]).to_string().parse().unwrap();
        if par[1].as_bytes()[0] == '-' as u8 {
            p2 = -(p2 as i32) as usize;
        }
        if c.reg.get(p1).copied().unwrap() == 1 {
            c.i += p2;
        } else {
            c.i += 1;
        }
    } else {
        status = 0;
    }
    return status;
}

fn main() {
    let instructions = read_input("../23_input.txt");
    let mut c = Computer::new(instructions, 0, 0, 0);
    let mut res = 1;
    while res == 1 {
        res = run_cmd(&mut c);
    }
    println!("Part 1: {}", c.reg.get("b").copied().unwrap());
    let instructions = read_input("../23_input.txt");
    let mut c = Computer::new(instructions, 0, 1, 0);
    res = 1;
    while res == 1 {
        res = run_cmd(&mut c);
    }
    println!("Part 2: {}", c.reg.get("b").copied().unwrap());
}

fn read_input(filename: &str) -> Vec<Vec<String>> {
    let f = File::open(filename).expect("File not found");
    let f = BufReader::new(f);
    let mut instructions = Vec::new();
    for line in f.lines() {
        let mut cmd: Vec<String> = line.unwrap().to_owned().split(" ").map(|x| x.to_string()).collect();
        if cmd[1].len() == 2 && cmd[1].as_bytes()[1] == ',' as u8 {
            cmd[1] = (cmd[1].as_bytes()[0] as char).to_string();
        }
        instructions.push(cmd);
    }
    instructions
}