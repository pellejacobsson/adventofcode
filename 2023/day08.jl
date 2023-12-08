using Primes

function read_input(filename)
    moves = ""
    nodes = Dict{String, Tuple{String, String}}()
    open(filename) do f
        moves = readline(f)
        readline(f)
        for line in readlines(f)
            m = match(r"(.+) = \((.+), (.+)\)", line)
            nodes[m[1]] = (m[2], m[3])
        end
    end
    moves, nodes
end

function solve(moves, nodes)
    node = "AAA"
    for (i, move) in enumerate(Iterators.cycle(moves))
        node = move == 'L' ? nodes[node][1] : nodes[node][2]
        if node == "ZZZ"
            return i
        end
    end
end

function solve2(moves, nodes)
    curr_nodes = [node for (node, _) in nodes if endswith(node, "A")]
    factors = Dict{Int, Int}()
    for node in curr_nodes
        for (i, move) in enumerate(Iterators.cycle(moves))
            node = move == 'L' ? nodes[node][1] : nodes[node][2]
            if endswith(node, "Z")
                factors = mergewith(max, factors, factor(Dict, i))
                break
            end
        end
    end
    prod([f * m for (f, m) in factors])
end

function runit(part=1)
    moves, nodes = read_input("08_input.txt")
    if part == 1
        solve(moves, nodes)
    else
        solve2(moves, nodes)
    end
end

runit()
runit(2)