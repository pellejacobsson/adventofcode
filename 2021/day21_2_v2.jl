function runit(p1_0, p2_0)
    player1_wins = 0
    player2_wins = 0
    u = Dict{Tuple, Int64}()
    u[(p1_0, p2_0, 0, 0)] = 1
    dice = [3, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 8, 8, 8, 9]
    while length(u) > 0
        u_new = Dict{Tuple, Int64}()
        for (state, universes) in u
            for die in dice
                new_pos = state[1] + die
                new_pos = new_pos > 10 ? new_pos - 10 : new_pos
                new_score = state[3] + new_pos
                if new_score ≥ 21
                    player1_wins += universes
                else
                    u_new[(new_pos, state[2], new_score, state[4])] = 
                        get(u_new, (new_pos, state[2], new_score, state[4]), 0) + universes
                end
            end
        end
        u = u_new

        u_new = Dict{Tuple, Int64}()
        for (state, universes) in u
            for die in dice
                new_pos = state[2] + die
                new_pos = new_pos > 10 ? new_pos - 10 : new_pos
                new_score = state[4] + new_pos
                if new_score ≥ 21
                    player2_wins += universes
                else
                    u_new[(state[1], new_pos, state[3], new_score)] =
                        get(u_new, (state[1], new_pos, state[3], new_score), 0) + universes
                end
            end
        end
        u = u_new
    end
    return player1_wins, player2_wins
end

p1, p2 = runit(7, 8)