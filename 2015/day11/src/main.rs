use std::str;

fn main() {
    let mut password = b"hepxcrrq".to_owned();
    next_password(&mut password);
    println!("Part 1: {}", str::from_utf8(&password).unwrap());
    next_password(&mut password);
    println!("Part 2: {}", str::from_utf8(&password).unwrap());
    
}

fn next_password(w: &mut [u8]) {
    loop {
        step(w);
        if has_straight(&w) && has_pairs(&w) {
            break;
        }
    }
}

fn step(w: &mut [u8]) {
    for i in (0..=7).rev() {
        if w[i] < 122 {
            if [104, 107, 110].contains(&w[i]) {
                w[i] += 2;
            } else {
                w[i] += 1;
            }
            break;
        } else {
            w[i] = b'a';
        }
    }
}

fn has_straight(w: &[u8]) -> bool {
    for i in 0..w.len()-2 {
        if (w[i] + 1== w[i+1]) && (w[i] + 2 == w[i+2]) {
            return true;
        }
    }
    false
}

fn has_pairs(w: &[u8]) -> bool {
    let mut one_found = false;
    let mut i = 0;
    while i < w.len() - 1 {
        if w[i] == w[i+1] {
            if one_found {
                return true;
            } else {
                one_found = true;
                i += 1;
            }
        }
        i += 1;
    }
    false
}