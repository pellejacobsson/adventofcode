function read_input(filename)
    symbols = Dict{Tuple{Int64, Int64}, Char}()
    numbers = Vector{Tuple{Int64, Vector{Tuple{Int64, Int64}}}}()
    open(filename) do f
        for (i, line) in enumerate(readlines(f))
            line_numbers = [(parse(Int, line[jj]), [(i, j) for j in jj]) for jj in findall(r"\d+", line)]
            numbers = [numbers; line_numbers]
            line_symbols = Dict((i, j) => line[j] for j in findall(x -> !(x == '.' || isnumeric(x)), line))
            symbols = merge(symbols, line_symbols)
        end
    end
    symbols, numbers
end

function solve(symbols, numbers)
    part_sum = 0
    for (n, ij) in numbers
        counted = false
        for (i, j) in ij
            for (di, dj) in Iterators.product([0, -1, 1], [0, -1, 1])
                (di, dj) == (0, 0) && continue
                if (i + di, j + dj) in keys(symbols)
                    part_sum += n
                    counted = true
                    break
                end
            end
            counted && break
        end
    end
    part_sum
end

function solve2(symbols, numbers)
    gear_ratio = 0
    for ((si, sj), symbol) in symbols
        symbol == '*' || continue
        n_list = Int64[]
        for (n, nij) in numbers
            adjacent = false
            for (ni, nj) in nij
                for (di, dj) in Iterators.product([0, -1, 1], [0, -1, 1])
                    (di, dj) == (0, 0) && continue
                    if (ni + di, nj + dj) == (si, sj)
                        push!(n_list, n)
                        adjacent = true
                        break
                    end
                end
                adjacent && break
            end
        end
        if length(n_list) == 2
            gear_ratio += prod(n_list)
        end
    end
    gear_ratio
end

function runit(filename)
    symbols, numbers = read_input(filename)
    println("Part 1: $(solve(symbols, numbers))")
    println("Part 2: $(solve2(symbols, numbers))")
end

runit("03_input.txt")