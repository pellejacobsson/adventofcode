function read_input(filename)
    open(filename) do f
        [parse.(Int, split(line, r", | @ ")) for line in readlines(f)]
    end
end

function calc_intersect(p1, p2)
    x10, y10, _, vx1, vy1, _ = p1
    x20, y20, _, vx2, vy2, _ = p2
    a = vy1 / vx1 - vy2 / vx2
    b = y20 - y10 + vy1 / vx1 * x10 - vy2 / vx2 * x20
    c = y10 - vy1 / vx1 * x10
    d = vy1 / vx1
    x = b / a
    y = c + d * x
    t1 = (x - x10) / vx1
    t2 = (x - x20) / vx2
    x, y, t1, t2
end

function runit(filename)
    p = read_input(filename)
    s = 0
    x_min, x_max = 200000000000000, 400000000000000
    y_min, y_max = 200000000000000, 400000000000000
    for i in eachindex(p)
        for j = i + 1:length(p)
            x, y, t1, t2 = calc_intersect(p[i], p[j])
            if x_min <= x <= x_max && y_min <= y <= y_max && t1 >= 0 && t2 >= 0 && !any((x, y) .== Inf)
                s += 1
            end
        end
    end
    s
end

runit("24_input.txt")
