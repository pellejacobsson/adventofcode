using BenchmarkTools
using DataStructures

function read_input(filename)
    lines = open(filename) do f
        readlines(f)
    end
    m = zeros(Int, length(lines), length(lines[1]))
    for (i, line) in enumerate(lines)
        m[i, :] = [parse(Int, s) for s in string(line)]
    end
    return m
end

function find_adjacent(m, u)
    i_max, j_max = size(m)
    i, j = u
    v = Tuple[]
    v_pot = [(i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1)]
    for (ip, jp) in v_pot
        if ip > 0 && jp > 0 && ip ≤ i_max && jp ≤ j_max
            push!(v, (ip, jp))
        end
    end
    return v
end

function dijkstra1(grid, source, target)
    n_rows, n_cols = size(grid)
    q = Set{Tuple}()
    dist = Dict{Tuple, Int64}()
    prev = Dict{Tuple, Tuple}()
    for i = 1:n_rows, j = 1:n_cols
        dist[(i, j)] = typemax(Int)
        push!(q, (i, j))
    end
    dist[source] = 0
    while length(q) > 0
        u = argmin(Dict(key => val for (key, val) in dist if key ∈ q))
        delete!(q, u)
        if u == target
            return dist, prev
        end
        for v in find_adjacent(grid, u)
            if v ∈ q
                alt = dist[u] + grid[v[1], v[2]]
                if alt < dist[v]
                    dist[v] = alt
                    prev[v] = u
                end
            end
        end
    end
    return "Path not found"
end

function dijkstra2(grid, source, target)
    q = trues(size(grid))
    dist = fill(typemax(Int), size(grid))
    prev = Dict{Tuple, Tuple}()
    
    dist[source[1], source[2]] = 0
    while sum(q) > 0
        dist_tmp = copy(dist)
        dist_tmp[.!q] .= typemax(Int)
        u = Tuple(argmin(dist_tmp))

        q[u[1], u[2]] = false
        if u == target
            return dist, prev
        end
        for v in find_adjacent(grid, u)
            if q[v[1], v[2]]
                alt = dist[u[1], u[2]] + grid[v[1], v[2]]
                if alt < dist[v[1], v[2]]
                    dist[v[1], v[2]] = alt
                    prev[v] = u
                end
            end
        end
    end
    return "Path not found"
end

function dijkstra3(grid, source, target)
    q = PriorityQueue{Tuple, Int64}()
    dist = fill(typemax(Int), size(grid))
    dist[source[1], source[2]] = 0
    prev = Dict{Tuple, Tuple}()
    for i = 1:size(grid, 1), j = 1:size(grid, 2)
        enqueue!(q, (i, j), dist[i, j])
    end
    
    while length(q) > 0
        u = dequeue!(q)

        if u == target
            return dist, prev
        end
        for v in find_adjacent(grid, u)
            if v ∈ keys(q)
                alt = dist[u[1], u[2]] + grid[v[1], v[2]]
                if alt < dist[v[1], v[2]]
                    dist[v[1], v[2]] = alt
                    prev[v] = u
                    q[v] = alt
                end
            end
        end
    end
    return "Path not found"
end

# Part 1
grid = read_input("15_input.txt")
source = (1, 1)
target = (size(grid, 1), size(grid, 2))
dist3, prev3 = dijkstra3(grid, source, target)
out = dist3[target[1], target[2]]

# Part 2
function repeat_grid(grid)
    grid = hcat([grid .+ n for n = 0:4]...)
    grid = vcat([grid .+ n for n = 0:4]...)
    reset_idx = grid .> 9
    grid[reset_idx] = grid[reset_idx] .% 9
    return grid
end

grid = read_input("15_input.txt")
grid = repeat_grid(grid)
source = (1, 1)
target = (size(grid, 1), size(grid, 2))
dist3, prev3 = dijkstra3(grid, source, target)
out = dist3[target[1], target[2]]