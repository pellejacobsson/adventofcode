function read_input(filename)
    lines = open(filename) do f
        readlines(f)
    end
    d = Dict{String, Vector{String}}()
    for line in lines
        node1, node2 = split(line, "-")
        if haskey(d, node1) && node2 ∉ d[node1]
            push!(d[node1], node2)
        else
            d[node1] = [node2]
        end
        if haskey(d, node2) && node1 ∉ d[node2]
            push!(d[node2], node1)
        else
            d[node2] = [node1]
        end
    end
    return d
end

function is_small_cave(cave)
    return all([islowercase(s) for s in cave])
end

delete_node!(list, node) = deleteat!(list, findfirst(x -> x == node, list))

function count_paths(graph, v, visited, revisit)
    if v == "end"
        return 1
    end
    if v ∈ visited
        if v == "start" || revisit
            return 0
        else
            revisit = true
        end
    end
    if is_small_cave(v)
        push!(visited, v)
    end
    s = sum([count_paths(graph, w, visited, revisit) for w ∈ graph[v]])
    if is_small_cave(v)
        delete_node!(visited, v)
    end
    return s
end

graph = read_input("12_input.txt")
out = count_paths(graph, "start", [], false)