use std::fs::File;
use std::io::{BufRead, BufReader};
use regex::Regex;

struct Raindeer {
    name: String,
    speed: usize,
    move_time: usize,
    rest_time: usize,
    move_counter: usize,
    rest_counter: usize,
    is_moving: bool,
    distance: usize,
    points: usize
}

impl Raindeer {
    fn new(name: String, speed: usize, move_time: usize, rest_time: usize) -> Raindeer {
        Raindeer {
            name: name,
            speed: speed,
            move_time: move_time,
            rest_time: rest_time,
            move_counter: 0,
            rest_counter: 0,
            is_moving: true,
            distance: 0,
            points: 0
        }
    }
}

fn main() {
    let mut raindeer = read_input("../14_input.txt");
    for _ in 0..2503 {
        for r in raindeer.iter_mut() {
            step(r);
        }
        let max_dist = raindeer.iter().map(|x| x.distance).max().unwrap();
        for r in raindeer.iter_mut() {
            if r.distance == max_dist {
                r.points += 1;
            }
        }
    }
    let max_dist = raindeer.iter().map(|x| x.distance).max().unwrap();
    let max_points = raindeer.iter().map(|x| x.points).max().unwrap();
    for r in raindeer.iter() {
        println!("{}: {}, {}", r.name, r.distance, r.points);
    }
    println!("-------------");
    println!("Max distance: {max_dist}");
    println!("Max points: {max_points}")

}


fn step(r: &mut Raindeer) {
    if r.is_moving {
        if r.move_counter == r.move_time {
            r.is_moving = false;
            r.move_counter = 0;
            r.rest_counter = 1
        } else {
            r.move_counter += 1;
            r.distance += r.speed;
        }
    } else {
        if r.rest_counter == r.rest_time {
            r.is_moving = true;
            r.rest_counter = 0;
            r.move_counter = 1;
            r.distance += r.speed;
        } else {
            r.rest_counter += 1;
        }
    }
}

fn read_input(filename: &str) -> Vec<Raindeer> {
    let f = File::open(filename).expect("Could not find file");
    let f = BufReader::new(f);
    let mut raindeer: Vec<Raindeer> = Vec::new();
    let re = Regex::new(r"(.*) can fly (\d+?) km/s for (\d+?) seconds, but then must rest for (\d+?) seconds.").unwrap();
    for line in f.lines() {
        let s = line.unwrap();
        let cap = re.captures(&s).unwrap();
        let name = cap[1].to_owned();
        let speed: usize = cap.get(2).unwrap().as_str().parse().unwrap();
        let move_time: usize = cap.get(3).unwrap().as_str().parse().unwrap();
        let rest_time:usize = cap.get(4).unwrap().as_str().parse().unwrap();
        raindeer.push(Raindeer::new(name, speed, move_time, rest_time));
    }
    raindeer
}