function read_map(filename)
    rows = open(filename) do f
        readlines(f)
    end
    n_rows = length(rows)
    n_cols = length(rows[1])
    m = zeros(Int, (n_rows, n_cols))
    for i = 1:n_rows
        m[i, :] = [parse(Int, s) for s in string.(rows[i])]
    end
    return m
end

function pad_matrix(m, pad)
    m2 = fill(pad, size(m) .+ 2)
    m2[2:end-1, 2:end-1] = m
    return m2
end

function get_sinks(m)
    m_pad = pad_matrix(m, 10)
    d = Dict()
    for i = 2:size(m_pad, 1) - 1, j = 2:size(m_pad, 2) - 1
        if sum(m_pad[i, j] .< m_pad[(i-1):(i+1), (j-1):(j+1)]) == 8
            d[(i-1, j-1)] = m_pad[i, j] + 1
        end
    end
    return d
end

m = read_map("9_input.txt")
d = get_sinks(m)
out1 = sum(values(d))

# Part 2

function get_adjacent(m, v)
    i, j = v
    i_min, j_min = 1, 1
    i_max, j_max = size(m)
    w = []
    if i - 1 ≥ i_min
        push!(w, (i-1, j))
    end
    if i + 1 ≤ i_max
        push!(w, (i+1, j))
    end
    if j - 1 ≥ j_min
        push!(w, (i, j-1))
    end
    if j + 1 ≤ j_max
        push!(w, (i, j+1))
    end
    return w
end

function count_basin(m, i, j)
    stack = [(i, j)]
    explored = []
    count = 0
    while length(stack) > 0
        v = pop!(stack)
        if v ∉ explored
            push!(explored, v)
            count += 1
            for w in get_adjacent(m, v)
                if m[w...] > m[v...] && m[w...] != 9
                    push!(stack, w)
                end
            end
        end
    end
    return count
end

b = Dict()
for (i, j) in keys(d)
    b[(i, j)] = count_basin(m, i, j)
end

out2 = prod(sort(collect(values(b)), rev = true)[1:3])