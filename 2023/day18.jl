function read_input(filename; part2=false)
    dir_map = Dict("R" => 0, "D" => 1, "L" => 2, "U" => 3)
    open(filename) do f
        if !part2
            [[dir_map[s[1]], parse(Int, s[2])] for s in split.(readlines(f))]
        else
            [[parse(Int, s[3][end-1]), parse(Int, s[3][3:end-2], base=16)] for s in split.(readlines(f))]
        end
    end
end

function dig_ditch(instructions)
    grid = Dict()
    i, j = 0, 0
    for (dir, steps) in instructions
        if dir == 3
            for di = 1:steps
               grid[i - di, j] = 1
            end
            i -= steps
        elseif dir == 0
            for dj = 1:steps
                grid[i, j + dj] = 1
            end
            j += steps
        elseif dir == 1
            for di = 1:steps
                grid[i + di, j] = 1
            end
            i += steps
        elseif dir == 2
            for dj = 1:steps
                grid[i, j - dj] = 1
            end
            j -= steps
        else
            error("Wrong dir")
        end
    end
    grid
end

function dig_ditch2(instructions)
    p = [[0, 0]]
    x_prev, y_prev = 0, 0
    for (dir, steps) in instructions
        if dir == 0
            push!(p, [x_prev + steps, y_prev])
            x_prev += steps
        elseif dir == 1
            push!(p, [x_prev, y_prev - steps])
            y_prev -= steps
        elseif dir == 2
            push!(p, [x_prev - steps, y_prev])
            x_prev -= steps
        elseif dir == 3
            push!(p, [x_prev, y_prev + steps])
            y_prev += steps
        else
            error("Wrong dir")
        end
    end
    p
end

function flood_fill(grid, start)
    q = [start]
    while !isempty(q)
        i, j = pop!(q)
        grid[i, j] = 1
        for (di, dj) in [(-1, 0), (1, 0), (0, -1), (0, 1)]
            (i + di, j + dj) in keys(grid) && continue
            push!(q, (i + di, j + dj))
        end
    end
end

function shoelace(p)
    x = [xy[1] for xy in p]
    y = [xy[2] for xy in p]
    x = [x[end]; x; x[1]]
    dx = x[1:end-2] - x[3:end]
    sum(y .* dx) / 2
end

# Shoelace + Pick's theorem
function solve2(instructions)
    p = dig_ditch2(instructions)
    a = shoelace(reverse(p[2:end]))
    b = sum([instruction[2] for instruction in instructions])
    Int(a + 1 + b / 2)
end

function solve(instructions)
    grid = dig_ditch(instructions)
    flood_fill(grid, (1, 1))
    length(keys(grid))
end

function runit(filename; part2=false)
    instructions = read_input(filename; part2=part2)
    solve2(instructions)
end

runit("18_input.txt")
runit("18_input.txt", part2=true)
