function read_input(filename)
    grid = Dict{Tuple{Int64, Int64}, Char}()
    open(filename) do f
        for (i, line) in enumerate(readlines(f))
            for (j, s) in enumerate(line)
                if s != '#'
                    grid[i, j] = s
                end
            end
        end
    end
    grid
end

function get_adjacent(grid, v, part2)
    adj = []
    for dv in [(-1, 0), (1, 0), (0, -1), (0, 1)]
        nv = v .+ dv
        if nv in keys(grid)
            if part2 || grid[v] == '.'
                push!(adj, nv)
            elseif grid[v] == '>' && dv == (0, 1)
                push!(adj, nv)
            elseif grid[v] == 'v' && dv == (1, 0)
                push!(adj, nv)
            end
        end
    end
    adj
end

function dfs(grid, source, goal, part2)
    stack = [source]
    l_stack = [0]
    longest_path = 0
    explored_stack = [Set([source])]
    while !isempty(stack)
        v = pop!(stack)
        path_length = pop!(l_stack)
        explored = pop!(explored_stack)
        if v == goal
            longest_path = max(longest_path, path_length)
        end
        if path_length + (length(grid) - length(explored)) <= longest_path
            continue
        end
        for w in get_adjacent(grid, v, part2)
            if !(w in explored)
                new_explored = copy(explored)
                push!(new_explored, v)
                push!(stack, w)
                push!(l_stack, path_length + 1)
                push!(explored_stack, new_explored)
            end
        end
    end
    longest_path
end

function find_nodes(source, goal, grid)
    nodes = [source, goal]
    for (p, v) in grid
        v == '#' && continue
        neighbors = 0
        for dp = [(-1, 0), (1, 0), (0, -1), (0, 1)]
            if p .+ dp in keys(grid) && grid[p .+ dp] != '#'
                neighbors += 1
            end
        end
        if neighbors >= 3
            push!(nodes, p)
        end
    end
    nodes
end

function reduce_graph(nodes, grid, part2)
    dir_map = Dict(
        '^' => [(-1, 0)],
        'v' => [(1, 0)],
        '>' => [(0, 1)],
        '<' => [(0, -1)],
        '.' => [(-1, 0), (1, 0), (0, -1), (0, 1)]
    )
    graph = Dict(node => Dict() for node in nodes)
    for (si, sj) in nodes
        stack = [(0, si, sj)]
        seen = Set([(si, sj)])
        while !isempty(stack)
            n, i, j = pop!(stack)
            if n != 0 && (i, j) in nodes
                graph[si, sj][i, j] = n
                continue
            end
            dirs = part2 ? [(-1, 0), (1, 0), (0, -1), (0, 1)] : dir_map[grid[i, j]]
            for (di, dj) in dirs
                ni = i + di
                nj = j + dj
                if (ni, nj) in keys(grid) && !((ni, nj) in seen)
                    push!(stack, (n + 1, ni, nj))
                    push!(seen, (ni, nj))
                end
            end
        end
    end
    graph
end

function dfs2(graph, seen, node, goal)
    if node == goal
        return 0
    end
    m = 0
    push!(seen, node)
    for (w, d) in graph[node]
        if !(w in seen)
            m = max(m, dfs2(graph, seen, w, goal) + d)
        end
    end
    delete!(seen, node)
    return m
end

function runit(filename; part2=false)
    grid = read_input(filename)
    source = (1, 2)
    goal = (141, 140)
    dfs(grid, source, goal, part2)
end

function runit2(filename; part2=false)
    grid = read_input(filename)
    source = (1, 2)
    goal = (141, 140)
    nodes = find_nodes(source, goal, grid)
    graph = reduce_graph(nodes, grid, part2)
    dfs2(graph, Set(), source, goal)
end

runit("23_input.txt")
runit2("23_input.txt")
runit2("23_input.txt", part2=true)
