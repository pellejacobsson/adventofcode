function read_input(filename)
    input = open(filename) do f
        m = []
        for l in readlines(f)
            push!(m, [parse(Int, x) for x in split(l, "")])
        end
        nrows = length(m)
        ncols = length(m[1])
        m = [m[i][j] for i = 1:nrows, j = 1:ncols]
        return m
    end
    return input
end

# Part 1
input = read_input("3_input.txt")
γ = sum(input, dims = 1) .> size(input, 1) / 2
ϵ = .!γ
γ = [Int(x) for x in vec(γ)]
ϵ = [Int(x) for x in vec(ϵ)]

γ_10 = parse(Int, join([string(s) for s in γ]), base = 2)
ϵ_10 = parse(Int, join([string(s) for s in ϵ]), base = 2)

out = γ_10 * ϵ_10

# Part 2
function filter_column!(m, col; rating = "O")
    n_rows = size(m, 1)
    n_ones = sum(m[:, col])
    n_zeros = n_rows - n_ones
    if rating == "O"
        value = n_ones ≥ n_zeros ? 1 : 0
    elseif rating == "CO2"
        value = n_ones < n_zeros ? 1 : 0
    else
        error("Wrong rating input")
    end
    idx = m[:, col] .== value
    m = m[idx, :]
    return m
end

input = read_input("3_input.txt")
for col = 1:size(input, 2)
    input = filter_column!(input, col, rating = "O")
    if size(input, 1) == 1
        break
    end
end

o_10 = parse(Int, join([string(s) for s in vec(input)]), base = 2)

input = read_input("3_input.txt")
for col = 1:size(input, 2)
    input = filter_column!(input, col, rating = "CO2")
    if size(input, 1) == 1
        break
    end
end

co2_10 = parse(Int, join([string(s) for s in vec(input)]), base = 2)

out = o_10 * co2_10