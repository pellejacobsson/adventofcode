function calc_dist(t, d)
    my_d = [(t - t_h) * t_h for t_h = 1:t-1]
    sum(my_d .> d)
end

function solve(;part=1)
    ts = [60, 94, 78, 82]
    ds = [475, 2138, 1015, 1650]
    if part == 1
        prod(calc_dist.(ts, ds))
    else
        t = parse(Int, join(string.(ts)))
        d = parse(Int, join(string.(ds)))
        calc_dist(t, d)
    end
end

solve()
solve(part=2)