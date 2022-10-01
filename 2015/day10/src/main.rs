use itertools::Itertools;

fn main() {
    let mut l  = vec![1, 1, 1, 3, 1, 2, 2, 1, 1, 3];
    for _ in 0..40 {
        l = look_and_say(l);
    }
    println!("Part 1: {}", l.len());
    for _ in 0..10 {
        l = look_and_say(l);
    }
    println!("Part 2: {}", l.len());
}

fn look_and_say(l: Vec<usize>) -> Vec<usize> {
    let mut ln: Vec<usize> = Vec::new();
    for (k, g) in &l.into_iter().group_by(|x| *x) {
        ln.push(g.count());
        ln.push(k);
    }
    ln
}