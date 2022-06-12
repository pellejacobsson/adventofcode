using OffsetArrays
using Colors

function read_input(filename)
    lines = open(filename) do f
        readlines(f)
    end
    d = Dict()
    idx = findfirst(x -> x == "", lines)
    for line in lines[1:idx-1]
        x, y = [parse(Int, s) for s in split(line, ",")]
        d[(x, y)] = 1
    end
    along_coord = []
    along_value = []
    for line in lines[idx+1:end]
        re = r"^fold along (x|y)=([0-9]*)$"
        m = match(re, line)
        push!(along_coord, m.captures[1])
        push!(along_value, parse(Int, m.captures[2]))
    end
    x_max = maximum([v[1] for v in collect(keys(d))])
    y_max = maximum([v[2] for v in collect(keys(d))])
    m = falses(y_max + 1, x_max + 1)
    m = OffsetArray(m, 0:y_max, 0:x_max)
    for (x, y) in keys(d)
        m[y, x] = true
    end
    return m, along_coord, along_value
end

function fold_paper(m, coord, value)
    if coord == "x"
        m2 = m[:, 0:value-1] .| reverse(m[:, value+1:end], dims = 2)
    elseif coord == "y"
        m2 = m[0:value-1, :] .| reverse(m[value+1:end, :], dims = 1)
    else
        error("Wrong folding coordinate")
    end
    m2 = OffsetArray(m2, 0:size(m2,1)-1, 0:size(m2,2)-1)
    return m2
end

m, along_coord, along_value = read_input("13_input.txt")

# Part 1
mf = fold_paper(m, along_coord[1], along_value[1])
out = sum(mf)

# Part 2
for (coord, value) in zip(along_coord[2:end], along_value[2:end])
    mf = fold_paper(mf, coord, value)
end

Gray.(mf)