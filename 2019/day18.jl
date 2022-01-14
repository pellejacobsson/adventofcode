tunnel_map = open("18_testinput1.txt") do f
    d = Dict()
    for (i, l) in enumerate(readlines(f))
        for (j, ll) in enumerate(l)
            d[(i, j)] = ll
        end
    end
    return d
end

all_keys = unique([lowercase(c) for c in setdiff(values(tunnel_map), ['#', '.', '@'])])
n_keys = length(all_keys)
p_start = findfirst(x -> x == '@', tunnel_map)

function get_adjacent(p)
    x, y = p
    return [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]
end

function bfs(tunnel_map, p_start, n_keys)
    queue = [p_start]
    found_keys = []
    explored = []
    d = 0
    path = []
    #for n = 1:100
    while length(queue) > 0
        v = popfirst!(queue)
        push!(path, v)
        for w in get_adjacent(v)
            if w ∉ explored
                if tunnel_map[w] == '.'
                    push!(queue, w)
                    push!(explored, w)
                elseif tunnel_map[w] ∈ 'a':'z'
                    push!(found_keys, tunnel_map[w])
                    push!(queue, w)
                    explored = []
                    push!(explored, w)
                    if length(found_keys) == n_keys
                        break
                    end
                elseif tunnel_map[w] ∈ 'A':'Z'
                    if lowercase(tunnel_map[w]) ∈ found_keys
                        push!(queue, w)
                        push!(explored, w)
                    end
                end
            end
        end
        d += 1
    end
    return found_keys, path, d
end

fk, path, d = bfs(tunnel_map, p_start, n_keys)