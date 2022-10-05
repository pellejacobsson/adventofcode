use serde_json::Value;
use std::fs::read_to_string;

fn main() {
    let input = read_to_string("../12_input.txt").unwrap();
    let v1 = serde_json::from_str::<Value>(&input).unwrap();
    let v2 = v1.clone();
    let n1 = count_num(v1);
    let n2 = count_num2(v2);
    println!("Part 1: {n1}");
    println!("Part 2: {n2}")
}

fn count_num(d: Value) -> i64 {
    match d {
        Value::Number(n) => n.as_i64().unwrap(),
        Value::Array(v) => v.into_iter().map(|e| count_num(e)).sum(),
        Value::Object(v) => v.values().map(|e| count_num(e.clone())).sum(),
        _ => 0
    }
}

fn count_num2(d: Value) -> i64 {
    match d {
        Value::Number(n) => n.as_i64().unwrap(),
        Value::Array(v) => v.into_iter().map(|e| count_num2(e)).sum(),
        Value::Object(v) => {
            let mut m = 0;
            for v in v.values() {
                if v == "red" {
                    return 0;
                }
                m += count_num2(v.clone());
            }
            return m;
        },
        _ => 0
    }
}