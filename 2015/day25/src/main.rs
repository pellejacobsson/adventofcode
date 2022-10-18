fn main() {
    let row: i64 = 3010;
    let col: i64 = 3019;
    let diag = row + col - 1;
    let p: i64 = (1..diag).sum::<i64>() + col;
    let a: i64 = 252533;
    let b: i64 = 33554393;
    let mut n = 20151125;
    for _ in 0..(p-1) {
        n = n * a % b;
    }
    println!("Answer: {n}");
}
