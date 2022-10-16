use std::cmp;

fn main() {
    let weapon_list = [[8, 4, 0], [10, 5, 0], [25, 6, 0], [40, 7, 0], [74, 8, 0]];
    let armor_list = [[13, 0, 1], [31, 0, 2], [53, 0, 3], [75, 0, 4], [102, 0, 5]];
    let ring_list = [[25, 1, 0], [50, 2, 0], [100, 3, 0], [20, 0, 1], [40, 0, 2], [80, 0, 3]];
    let mut costs1 = Vec::new();
    let mut costs2 = Vec::new();
    for w in 0..5 {
        for a in -1..5i32 {
            for r1 in -1..6i32 {
                for r2 in -1..6i32 {
                    if (r2 == r1) && !((r1 == -1) && (r2 == -1)) {
                        continue;
                    }
                    let mut damage = weapon_list[w][1];
                    let mut cost = weapon_list[w][0];
                    let mut armor = 0;
                    if a >= 0 {
                        armor += armor_list[a as usize][2];
                        cost += armor_list[a as usize][0];
                    }
                    if r1 >= 0 {
                        armor += ring_list[r1 as usize][2];
                        damage += ring_list[r1 as usize][1];
                        cost += ring_list[r1 as usize][0];
                    }
                    if r2 >= 0 {
                        armor += ring_list[r2 as usize][2];
                        damage += ring_list[r2 as usize][1];
                        cost += ring_list[r2 as usize][0];
                    }
                    if player_wins(damage, armor, 100, 104) {
                        costs1.push(cost);
                    } else {
                        costs2.push(cost);
                    }
                }
            }
        }
    }
    println!("Part 1: {}", costs1.iter().min().unwrap());
    println!("Part 2: {}", costs2.iter().max().unwrap());
}

fn player_wins(damage: i32, armor: i32, p_hero: i32, p_boss: i32) -> bool {
    let damage_dealt = cmp::max(damage - 1, 1);
    let damage_received = cmp::max(8 - armor, 1);
    (p_boss as f64 / damage_dealt as f64).ceil() <= (p_hero as f64 / damage_received as f64).ceil()
}