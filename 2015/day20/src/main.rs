use std::collections::HashMap;

fn main() {
    let presents_goal = 29000000;
    let part1 = runit(presents_goal);
    println!("Part 1: {part1}");
    let part2 = runit2(presents_goal);
    println!("Part 2: {part2}")
}

fn factorize(n: i32) -> Vec<i32> {
    let mut n_vec = vec![n];
    let mut f = 2;
    let mut step = 1;
    if n == 1 {
        return n_vec
    }
    if n % 2 != 0 {
        f = 3;
        step = 2;
    }
    let mut factors: Vec<i32> =  Vec::new();
    while f * f <= n {
        if n % f == 0 {
            factors.push(f);
            if n / f != f {
                factors.push(n / f);
            }
        }
        f += step;
    }
    let mut res = vec![1];
    res.append(&mut factors);
    res.append(&mut n_vec);
    return res
}

fn n_presents(house_number: i32) -> i32 {
    let mut res = 0;
    for n in factorize(house_number) {
        res += n;
    }
    res *= 10;
    return res
}

fn n_presents2(house_number: i32, visited: &mut HashMap<i32, i32>) -> i32 {
    let factors = factorize(house_number);
    let mut res = 0;
    for f in factors {
        let n_visited = visited.entry(f).or_insert(0);
        *n_visited += 1;
        if *n_visited <= 50 {
            res += f
        };
    }
    res *= 11;
    return res;
}

fn runit(presents_goal: i32) -> i32 {
    let mut h = 1;
    loop {
        let house_presents = n_presents(h);
        if house_presents > presents_goal {
            return h;
        }
        h += 1;
    }
}

fn runit2(presents_goal: i32) -> i32 {
    let mut h = 1;
    let mut visited = HashMap::new();
    loop {
        let house_presents = n_presents2(h, &mut visited);
        if house_presents > presents_goal {
            return h;
        }
        h += 1;
    }
}