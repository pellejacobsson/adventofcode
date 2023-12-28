function read_input(filename)
    garden = Dict()
    start = ()
    open(filename) do f
        for (i, line) in enumerate(readlines(f))
            for (j, s) in enumerate(line)
                if s == '.'
                    garden[i, j] = 1
                elseif s == 'S'
                    start = (i, j)
                    garden[i, j] = 1
                end
            end
        end
    end
    garden, start
end

function take_step(garden, reached, i_max, j_max)
    reached_new = Set()
    for (i, j) in reached
        for (di, dj) in [(-1, 0), (1, 0), (0, -1), (0, 1)]
            ni, nj = i + di, j + dj
            if (mod1(ni, i_max), mod1(nj, j_max)) in keys(garden)
                push!(reached_new, (ni, nj))
            end
        end
    end
    reached_new
end

function solve(garden, n_steps, start)
    i_max = maximum(x -> x[1], keys(garden))
    j_max = maximum(x -> x[2], keys(garden))
    reached = Set((start,))
    for n in 1:n_steps
        reached = take_step(garden, reached, i_max, j_max)
    end
    length(reached)
end

function runit(filename, n_steps)
    garden, start = read_input(filename)
    solve(garden, n_steps, start)
end

# Needed some hints to see the 65 + n * 131.
function runit2(filename)
    garden, start = read_input(filename)
    alpha = solve(garden, 65, start)
    beta = solve(garden, 65 + 131, start)
    gamma = solve(garden, 65 + 2 * 131, start)
    a = (-2 * beta + alpha + gamma) / 2
    b = (4 * beta - 3 * alpha - gamma) / 2
    c = alpha
    p = 202300
    Int(a * p^2 + b * p + c)
end

runit("21_input.txt", 64)

runit2("21_input.txt")