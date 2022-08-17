use std::fs;

fn main() {
    let filename = String::from("../01_input.txt");
    let input = read_input(&filename);
    let part1 = count_floors(&input, 1);
    let part2 = count_floors(&input, 2);
    println!("Part 1: {part1}");
    println!("Part 2: {part2}");
}

fn read_input(filename: &str) -> String {
    let input = fs::read_to_string(filename)
        .expect("Error reading file");
    return input;
}

fn count_floors(input: &str, part: i32) -> i32 {
    let mut floor = 0;
    for (i, s) in input.chars().enumerate() {
        if s == ')' {
            floor -= 1
        } else {
            floor += 1
        }
        if (part == 2) & (floor == -1) {
            return (i + 1).try_into().unwrap();
        }
    }
    return floor;
}