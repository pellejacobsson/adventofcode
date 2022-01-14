fish = open("6_input.txt") do f
    [parse(Int, s) for s in split(readline(f), ",")]
end

function update_fish!(fish)
    restart_idx = fish .== 0
    n_new_fish = sum(restart_idx)
    normal_idx = .!restart_idx
    fish[normal_idx] .-= 1
    fish[restart_idx] .= 6
    new_fish = fill(8, n_new_fish)
    fish = vcat(fish, new_fish)
    return fish
end

fish = [3, 4, 3, 1, 2]

for n = 1:80
    fish = update_fish!(fish)
end

out = length(fish)