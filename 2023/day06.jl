using BenchmarkTools

function calc_dist(t, d)
    my_d = [(t - t_h) * t_h for t_h = 1:t-1]
    sum(my_d .> d)
end

function calc_dist2(t, d)
    p1 = 0.5 * t
    p2 = 0.5 * sqrt(t^2 - 4 * d)
    ceil(p1 + p2) - floor(p1 - p2) - 1
end

function solve(;part=1, eq=false)
    ts = [60, 94, 78, 82]
    ds = [475, 2138, 1015, 1650]
    if part == 1
        eq ? Int(prod(calc_dist2.(ts, ds))) : prod(calc_dist.(ts, ds))
    else
        t = 60947882
        d = 475213810151650
        eq ? Int(calc_dist2(t, d)) : calc_dist(t, d)
    end
end

function runit()
    t1 = @belapsed solve()
    t2 = @belapsed solve(part=2)
    t3 = @belapsed solve(eq=true)
    t4 = @belapsed solve(part=2, eq=true)
    println("Part 1 loop: $(t1*1e6) μs")
    println("Part 2 loop: $(t2*1e6) μs")
    println("Part 1 loop: $(t3*1e6) μs")
    println("Part 2 loop: $(t4*1e6) μs")
end