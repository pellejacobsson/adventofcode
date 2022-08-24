use md5;

fn main() {
    let input = String::from("bgvyzdsv");
    let res1 = part(input.as_bytes(), 5);
    let res2 = part(input.as_bytes(), 6);
    println!("Part 1: {res1}");
    println!("Part 2: {res2}");
}

fn part(input: &[u8], n_zeros: usize) -> u64 {
    let mut n = 0;
    let mut s = Vec::new();
    s.extend_from_slice(input);
    let start_string = "0".repeat(n_zeros);
    loop {
        s.truncate(input.len());
        let ns = format!("{}", n);
        s.extend_from_slice(ns.as_bytes());
        let digest = md5::compute(&s);
        let digest = format!("{:x}", digest);
        if digest.starts_with(&start_string) {
            return n;
        }
        n += 1;
    }
}
