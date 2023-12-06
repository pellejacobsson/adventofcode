function calc_dist(time, dist)
    my_dist = [(time - hold_time) * hold_time for hold_time = 1:time-1]
    sum(my_dist .> dist)
end

function solve(;part=1)
    times = [60, 94, 78, 82]
    dists = [475, 2138, 1015, 1650]
    if part == 1
        prod(calc_dist.(times, dists))
    else
        time = parse(Int, join(string.(times)))
        dist = parse(Int, join(string.(dists)))
        calc_dist(time, dist)
    end
end

solve()
solve(part=2)