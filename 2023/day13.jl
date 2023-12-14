function read_input(filename)
    inputs = open(filename) do f
        #split.(split(read(f, String), "\n\n"))
        split.(split(read(f, String), "\r\n\r\n"))
    end
    matrices = []
    for input in inputs
        m = [[s == '#' ? 1 : 0 for s in line] for line in input]
        push!(matrices, BitArray(permutedims(hcat(m...))))
    end
    matrices
end

function find_sym(m1; part2=false, prev=("na", 0))
    n_rows, n_cols = size(m1)
    m2 = reverse(m1, dims=2)
    cix = []
    for n = 1:n_cols - 1
        n_rl = min(n, n_cols - n)
        push!(cix, n - n_rl + 1:n)
    end
    for (i, (ix1, ix2)) in enumerate(zip(cix, reverse(cix)))
        !(part2 && ("v", i) == prev) && m1[:, ix1] == m2[:, ix2] && return "v", i
    end

    m2 = reverse(m1, dims=1)
    cix = []
    for n = 1:n_rows - 1
        n_rl = min(n, n_rows - n)
        push!(cix, n - n_rl + 1:n)
    end
    for (i, (ix1, ix2)) in enumerate(zip(cix, reverse(cix)))
        !(part2 && ("h", i) == prev) && m1[ix1, :] == m2[ix2, :] && return "h", i
    end
    return "na", 0
end

function solve(matrices, part2=false)
    s = 0
    for m in matrices
        c, ss = find_sym(m)
        if !part2
            s += c == "v" ? ss : ss * 100
        else
            n_rows, n_cols = size(m)
            for i = 1:n_rows, j = 1:n_cols
                m2 = copy(m)
                m2[i, j] = !m2[i, j]
                c2, ss2 = find_sym(m2, part2=true, prev=(c, ss))
                if ss2 > 0
                    s += c2 == "v" ? ss2 : ss2 * 100
                    break
                end
            end
        end
    end
    s
end

function runit(filename; part2=false)
    matrices = read_input(filename)
    solve(matrices, part2)
end

runit("13_input.txt")
runit("13_input.txt", part2=true)