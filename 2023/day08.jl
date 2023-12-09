using Base.Iterators

function read_input(filename)
    open(filename) do f
        moves = readline(f)
        nodes = Dict{String, Tuple{String, String}}()
        readline(f)
        for line in readlines(f)
            m = match(r"(.+) = \((.+), (.+)\)", line)
            nodes[m[1]] = (m[2], m[3])
        end
        moves, nodes
    end
end

function solve(moves, nodes)
    node = "AAA"
    for (i, move) in enumerate(cycle(moves))
        node = move == 'L' ? nodes[node][1] : nodes[node][2]
        node == "ZZZ" && return i
    end
end

function check_cyclic(moves, nodes, node)
    cycle_l = Int[]
    cycle_n = 1
    for (i, move) in enumerate(cycle(moves))
        node = move == 'L' ? nodes[node][1] : nodes[node][2]
        if endswith(node, "Z")
            push!(cycle_l, i)
            cycle_n > 1 ? break : cycle_n += 1
        end
    end
    return cycle_l[2] / cycle_l[1] == 2
end

function check_all_cyclic(moves, nodes)
    all(check_cyclic(moves, nodes, node) for node in keys(nodes) if endswith(node, "A"))
end

function solve2(moves, nodes)
    curr_nodes = [node for node in keys(nodes) if endswith(node, "A")]
    cycle_l = Int[]
    for node in curr_nodes
        for (i, move) in enumerate(cycle(moves))
            node = move == 'L' ? nodes[node][1] : nodes[node][2]
            if endswith(node, "Z")
                push!(cycle_l, i)
                break
            end
        end
    end
    lcm(cycle_l)
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