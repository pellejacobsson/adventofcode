function get_x_coords(filename)
    x = open(filename) do f
        [parse(Int, s) for s in split(readline(f), ",")]
    end
    return x
end

function min_sum_dist(x; part2 = false)
    x_min = minimum(x)
    x_max = maximum(x)
    d = []
    for x0 = x_min:x_max
        push!(d, sum(crab_dist.(x, x0, part2 = part2)))
    end
    return d
end

function crab_dist(x, x0; part2 = false)
    if part2
        return sum(1:abs(x - x0))
    else
        return abs(x - x0)
    end
end

x = get_x_coords("7_input.txt")

dist = min_sum_dist(x, part2 = true)
out = minimum(dist)