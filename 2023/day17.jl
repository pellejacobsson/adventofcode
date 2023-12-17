using DataStructures

function read_input(filename)
    grid = Dict()
    open(filename) do f
        for (i, line) in enumerate(readlines(f))
            for (j, s) in enumerate(line)
                grid[i, j] = parse(Int, s)
            end
        end
    end
    grid
end

function get_adjacent(grid, u, min_dist, max_dist)
    pos, dir, steps = u
    adj = []
    if dir == 'e'
        steps >= min_dist && pos .+ (-1, 0) in keys(grid) && push!(adj, (pos .+ (-1, 0), 'n', 1))
        steps >= min_dist && pos .+ (1, 0) in keys(grid) && push!(adj, (pos .+ (1, 0), 's', 1))
        steps < max_dist && pos .+ (0, 1) in keys(grid) && push!(adj, (pos .+ (0, 1), 'e', steps + 1))
    elseif dir == 's'
        steps >= min_dist && pos .+ (0, 1) in keys(grid) && push!(adj, (pos .+ (0, 1), 'e', 1))
        steps >= min_dist && pos .+ (0, -1) in keys(grid) && push!(adj, (pos .+ (0, -1), 'w', 1))
        steps < max_dist && pos .+ (1, 0) in keys(grid) && push!(adj, (pos .+ (1, 0), 's', steps + 1))
    elseif dir == 'w'
        steps >= min_dist && pos .+ (-1, 0) in keys(grid) && push!(adj, (pos .+ (-1, 0), 'n', 1))
        steps >= min_dist && pos .+ (1, 0) in keys(grid) && push!(adj, (pos .+ (1, 0), 's', 1))
        steps < max_dist && pos .+ (0, -1) in keys(grid) && push!(adj, (pos .+ (0, -1), 'w', steps + 1))
    elseif dir == 'n'
        steps >= min_dist && pos .+ (0, -1) in keys(grid) && push!(adj, (pos .+ (0, -1), 'w', 1))
        steps >= min_dist && pos .+ (0, 1) in keys(grid) && push!(adj, (pos .+ (0, 1), 'e', 1))
        steps < max_dist && pos .+ (-1, 0) in keys(grid) && push!(adj, (pos .+ (-1, 0), 'n', steps + 1))
    else
        error("Wrong direction")
    end
    adj
end

function dijkstra(grid, target, part2=false)
    min_dist = part2 ? 4 : 1
    max_dist = part2 ? 10 : 3
    pq = PriorityQueue()
    dist = Dict()
    pq[((1, 2), 'e', 1)] = grid[1, 2]
    pq[((2, 1), 's', 1)] = grid[2, 1]
    dist[((1, 2), 'e', 1)] = grid[1, 2]
    dist[((2, 1), 's', 1)] = grid[2, 1]
    while !isempty(pq)
        u = dequeue!(pq)
        dist_u = dist[u]
        u[1] == target && return dist_u
        for v in get_adjacent(grid, u, min_dist, max_dist)
            alt = dist_u + grid[v[1]]
            if v in keys(dist)
                if alt < dist[v]
                    pq[v] = alt
                    dist[v] = alt
                end
            else
                dist[v] = alt
                pq[v] = alt
            end
        end
    end
    error("Path not found")
end


grid = read_input("17_input.txt")
i_max = maximum(x -> x[1], keys(grid))
j_max = maximum(x -> x[2], keys(grid))
dist = dijkstra(grid, (i_max, j_max))
dist = dijkstra(grid, (i_max, j_max), true)
