function read_input(filename)
    m = Dict{Tuple{Int, Int, Int}, Int}()
    open(filename) do f
        for line in readlines(f)
            x, y, z = parse.(Int, split(strip(line), ","))
            m[x, y, z] = 1
        end
    end
    m
end

function calc_open_sides(m, (x, y, z); part2=false, trapped=nothing)
    s = 6
    for (dx, dy, dz) in ((-1, 0, 0), (1, 0, 0), (0, -1, 0), (0, 1, 0), (0, 0, -1), (0, 0, 1))
        xn, yn, zn = x + dx, y + dy, z + dz
        if (xn, yn, zn) in keys(m) || (part2 && (xn, yn, zn) in trapped)
            s -= 1
        end
    end
    s
end

function dfs(m, x_min, x_max, y_min, y_max, z_min, z_max, start)
    s = [start]
    explored = Set([start])
    while !isempty(s)
        v = pop!(s)
        x, y, z = v
        if x == x_min || x == x_max || y == y_min || y == y_max || z == z_min || z == z_max
            return true
        end
        for (dx, dy, dz) in ((-1, 0, 0), (1, 0, 0), (0, -1, 0), (0, 1, 0), (0, 0, -1), (0, 0, 1))
            xn, yn, zn = x + dx, y + dy, z + dz
            if !((xn, yn, zn) in keys(m)) && !((xn, yn, zn) in explored)
                push!(s, (xn, yn, zn))
                push!(explored, (xn, yn, zn))
            end
        end
    end
    false
end

function runit(filename)
    m = read_input(filename)
    sum(calc_open_sides.((m,), keys(m)))
end

function runit2(filename)
    m = read_input(filename)
    x_min, x_max = extrema(x -> x[1], keys(m))
    y_min, y_max = extrema(x -> x[2], keys(m))
    z_min, z_max = extrema(x -> x[3], keys(m))
    trapped = Set()
    for x = x_min:x_max, y = y_min:y_max, z = z_min:z_max
        if !((x, y, z) in keys(m))
            if !(dfs(m, x_min, x_max, y_min, y_max, z_min, z_max, (x, y, z)))
                push!(trapped, (x, y, z))
            end
        end
    end
    sum(calc_open_sides.((m,), keys(m); part2=true, trapped=trapped))
end

runit("18_input.txt")
runit2("18_input.txt")