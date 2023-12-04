function read_input(filename)
    w_numbers = Vector{Vector{Int}}()
    numbers = Vector{Vector{Int}}()
    open(filename) do f
        for line in readlines(f)
            w, n = split(split(line, ": ")[2], " | ")
            push!(w_numbers, parse.(Int, [s for s in split(w)]))
            push!(numbers, parse.(Int, [s for s in split(n)]))
        end
    end
    w_numbers, numbers
end

function solve(w_numbers, numbers)
    s = 0
    for (w, n) in zip(w_numbers, numbers)
        n_in = sum(n .∈ (w,))
        s += n_in > 0 ? 2^(n_in - 1) : 0
    end
    s
end

function solve2(w_numbers, numbers)
    card_count = ones(Int, length(numbers))
    for (card, (w, n)) in enumerate(zip(w_numbers, numbers))
        points = sum(n .∈ (w,))
        card_count[card + 1:card + points] .+= card_count[card]
    end
    sum(card_count)
end

function runit(filename)
    w_numbers, numbers = read_input(filename)
    part1 = solve(w_numbers, numbers)
    part2 = solve2(w_numbers, numbers)
    println("Part 1: $part1")
    println("Part 2: $part2")
end

runit("04_input.txt")