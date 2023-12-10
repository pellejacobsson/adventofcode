function read_input(filename)
    grid_map = open(filename) do f
        [[s for s in line] for line in readlines(f)]
    end
    permutedims(hcat(grid_map...))
end

function find_path(grid_map, start, start_dir)
    dir_map = Dict(
        ('s', '|') => 'n',
        ('n', '|') => 's',
        ('w', '-') => 'e',
        ('e', '-') => 'w',
        ('n', 'L') => 'e',
        ('e', 'L') => 'n',
        ('n', 'J') => 'w',
        ('w', 'J') => 'n',
        ('w', '7') => 's',
        ('s', '7') => 'w',
        ('s', 'F') => 'e',
        ('e', 'F') => 's',
    )
    ix_map = Dict('n' => (-1, 0), 'e' => (0, 1), 's' => (1, 0), 'w' => (0, -1))
    prev_map = Dict('n' => 's', 'e' => 'w', 's' => 'n', 'w' => 'e')
    
    tile = start
    dist = Dict(tile => 1)
    path = [tile]
    prev = start_dir
    while true
        grid_map[tile...] == 'S' && break
        dir = dir_map[prev, grid_map[tile...]]
        prev = prev_map[dir]
        dij = ix_map[dir]
        curr_dist = dist[tile]
        tile = tile .+ dij
        dist[tile] = curr_dist + 1
        push!(path, tile)
    end
    dist, path
end

# https://www.mdpi.com/2073-8994/10/10/477
function in_polygon((xp, yp), p)
    k = 0
    n_poly = length(p)
    for i = 1:n_poly - 1
        v1 = p[i][2] - yp
        v2 = p[i+1][2] - yp
        ((v1 < 0 && v2 < 0) || (v1 > 0 && v2 > 0)) && continue
        u1 = p[i][1] - xp
        u2 = p[i+1][1] - xp
        f = u1 * v2 - u2 * v1
        if v2 > 0 && v1 <= 0
            if f > 0
                k += 1
            elseif f == 0
                return -1
            end
        elseif v1 > 0 && v2 <= 0
            if f < 0
                k += 1
            elseif f == 0
                return -1
            end
        elseif v2 == 0 && v1 < 0
            f == 0 && return -1
        elseif v1 == 0 && v2 < 0
            f == 0 && return -1
        elseif v1 == 0 && v2 == 0
            if u2 <= 0 && u1 >= 0
                return -1
            elseif u1 <= 0 && u2 >= 0
                return -1
            end
        end
    end
    k % 2 == 0 ? 0 : 1
end

function count_inside(path, grid_map)
    push!(path, path[1])
    i_max, j_max = size(grid_map)
    n_inside = 0
    for i = 1:i_max, j = 1:j_max
        if in_polygon((i, j), path) == 1
            n_inside += 1
        end
    end
    n_inside
end

function solve(grid_map)
    start = (104, 119)
    s = (103, 119)
    start_dir = 'n'
    dist, path = find_path(grid_map, start, start_dir)
    part1 = Int(dist[s] / 2)
    part2 = count_inside(path, grid_map)
    part1, part2
end

function runit(filename)
    grid_map = read_input(filename)
    part1, part2 = solve(grid_map)
    println("Part 1: $part1")
    println("Part 2: $part2")
end

runit("10_input.txt")
