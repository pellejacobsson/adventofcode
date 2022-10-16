
use std::cmp;
use std::collections::{HashMap, HashSet};
use binary_heap_plus::BinaryHeap;

struct State {
    cost: i32,
    order: i32,
    g: Game
}



#[derive(Clone)]
struct Game {
    player_points: i32,
    mana: i32,
    boss_points: i32,
    boss_damage: i32,
    armor: i32,
    shield_counter: i32,
    poison_counter: i32,
    poison_wait: bool,
    recharge_counter: i32,
    recharge_wait: bool,
    missile_active: bool,
    drain_active: bool,
    players_turn: bool,
    shield_restart: bool,
    shield_wait: bool,
    poison_restart: bool,
    recharge_restart: bool,
    part: i32
}

impl Game {
    fn new(player_points: i32, mana: i32, boss_points: i32, boss_damage: i32, part: i32) -> Game {
        Game {
            player_points,
            mana,
            boss_points,
            boss_damage,
            armor: 0,
            shield_counter: 0,
            poison_counter: 0,
            poison_wait: false,
            recharge_counter: 0,
            recharge_wait: false,
            missile_active: false,
            drain_active: false,
            players_turn: true,
            shield_restart: false,
            shield_wait: false,
            poison_restart: false,
            recharge_restart: false,
            part
        }
    }

    fn state(&self) -> (i32, i32, i32, i32, i32, i32, i32, bool, bool, bool) {
        (self.player_points, self.mana, self.boss_points, self.armor, self.shield_counter, self.poison_counter, 
            self.recharge_counter, self.missile_active, self.drain_active, self.players_turn)
    }

    fn activate_missile(&mut self) {
        self.missile_active = true;
        self.mana -= 53;
    }

    fn activate_drain(&mut self) {
        self.drain_active = true;
        self.mana -= 73;
    }

    fn activate_shield(&mut self) {
        if self.shield_counter == 0 {
            self.shield_wait = true;
        } else {
            self.shield_wait = false;
        }
        if self.shield_counter == 1 {
            self.shield_restart = true;
        }
        self.shield_counter = 6;
        self.mana -= 113;
    }

    fn activate_poison(&mut self) {
        if self.poison_counter == 0 {
            self.poison_wait = true;
        } else {
            self.poison_wait = false;
        }
        if self.poison_counter == 1 {
            self.poison_restart = true;
        }
        self.poison_counter = 6;
        self.mana -= 173;
    }

    fn activate_recharge(&mut self) {
        if self.recharge_counter == 0 {
            self.recharge_wait = true;
        } else {
            self.recharge_wait = false;
        }
        if self.recharge_counter == 1 {
            self.recharge_restart = true;
        }
        self.recharge_counter = 5;
        self.mana -= 229;
    }

    fn apply_effects(&mut self) {
        if self.missile_active {
            self.boss_points -= 4;
            self.missile_active = false;
        }
        if self.drain_active {
            self.boss_points -= 2;
            self.player_points += 2;
            self.drain_active = false;
        }
        if self.shield_counter > 0 {
            if !self.shield_wait {
                self.armor = 7;
                if !self.shield_restart {
                    self.shield_counter -= 1;
                } else {
                    self.shield_restart = false;
                }
            } else {
                self.shield_wait = false;
            }
        } else {
            self.armor = 0;
        }
        if self.poison_counter > 0 {
            if !self.poison_wait {
                self.boss_points -= 3;
                if !self.poison_restart {
                    self.poison_counter -= 1;
                } else {
                    self.poison_restart = false;
                }
            } else {
                self.poison_wait = false;
            }
        }
        if self.recharge_counter > 0 {
            if !self.recharge_wait {
                self.mana += 101;
                if !self.recharge_restart {
                    self.recharge_counter -= 1;
                } else {
                    self.recharge_restart = false;
                }
            } else {
                self.recharge_wait = false;
            }
        }
    }

    fn go_turn(&mut self) -> i32 {
        let mut res = 0;
        if self.part == 2 && self.players_turn {
            self.player_points -= 1;
        }
        self.apply_effects();
        if self.boss_points <= 0 {
            res = 1;
        }
        if !self.players_turn {
            self.player_points -= cmp::max(self.boss_damage - self.armor, 1);
            if self.player_points <= 0 && res == 0 {
                res = -1;
            }
            self.players_turn = true;
        } else {
            self.players_turn = false;
        }
        res
    }
}

fn next_possible_states(g: &Game) -> Vec<(Game, i32)> {
    let mut states = Vec::new();
    if g.mana >= 53 {
        let mut h = g.clone();
        h.activate_missile();
        states.push((h, 53));
    }
    if g.mana >= 73 {
        let mut h = g.clone();
        h.activate_drain();
        states.push((h, 73));
    }
    if g.shield_counter <= 1 && g.mana >= 113 {
        let mut h = g.clone();
        h.activate_shield();
        states.push((h, 113));
    }
    if g.poison_counter <= 1 && g.mana >= 173 {
        let mut h = g.clone();
        h.activate_poison();
        states.push((h, 173));
    }
    if g.recharge_counter <= 1 && g.mana >= 229 {
        let mut h = g.clone();
        h.activate_recharge();
        states.push((h, 229));
    }
    states
}

fn run_game(g: &Game) -> Option<i32> {
    let mut q = BinaryHeap::new_by(|a: (i32, i32, Game), b: (i32, i32, Gam)| b.cmp(a));
    let mut dist = HashMap::new();
    let mut order = 0;
    let mut explored = HashSet::new();
    for (v, cost) in next_possible_states(g) {
        dist.insert(v.state(), cost);
        q.push((cost, order, v));
        order += 1;
        println!("{cost}");
    }
    while q.len() > 0 {
        let (d, _, mut u) = q.pop().unwrap();
        //println!("{d}");
        //let u_state = u.state();
        let mut outcome = u.go_turn();
        if outcome == 1 {
            return Some(d);
        }
        outcome = u.go_turn();
        if outcome == 1 {
            return Some(d);
        }
        dist.insert(u.state(), d);
        explored.insert(u.state());
        if outcome == 0 {
            for (v, cost) in next_possible_states(&u) {
                if !explored.contains(&v.state()) {
                    let alt = d + cost;
                    if dist.contains_key(&v.state()) {
                        if alt < *dist.get(&v.state()).unwrap() {
                            dist.insert(v.state(), alt);
                        }
                    } else {
                        dist.insert(v.state(), alt);
                    }
                    q.push((*dist.get(&v.state()).unwrap(), order, v.clone()));
                    order += 1;
                    explored.insert(v.state());
                }
            }
        }
    }
    None
}

fn main() {
    let g = Game::new(50, 500, 58, 9, 1);
    let part1 = run_game(&g);
    println!("Part 1: {}", part1.unwrap());
    //let g = Game::new(50, 500, 58, 9, 2);
    //let part2 = run_game(&g);
    //println!("Part 2: {}", part2.unwrap());
}
