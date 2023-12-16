function read_input(filename)
    grid = Dict()
    open(filename) do f
        for (i, line) in enumerate(readlines(f))
            for (j, s) in enumerate(line)
                grid[i, j] = s
            end
        end
    end
    grid
end

function shine(beam, grid, visited, dir_map, turn_map)
    
    pos, dir = beam
    new_beams = []
    while true
        !(pos in keys(grid)) && break
        (pos, dir) in visited && break
        tile = grid[pos]
        push!(visited, (pos, dir))
        if tile == '.'
            pos = pos .+ dir_map[dir]
        elseif tile in ['\\', '/']
            dir = turn_map[(tile, dir)]
            pos = pos .+ dir_map[dir]
        elseif tile == '-'
            if dir in ['e', 'w']
                pos = pos .+ dir_map[dir]
            else
                new_beams = [(pos .+ (0, -1), 'w'), (pos .+ (0, 1), 'e')]
                break
            end
        elseif tile == '|'
            if dir in ['s', 'n']
                pos = pos .+ dir_map[dir]
            else
                new_beams = [(pos .+ (-1, 0), 'n'), (pos .+ (1, 0), 's')]
                break
            end
        else
            error("Wrong tile")
        end
    end
    return new_beams, visited
end
    
function calc_energized(grid, start, dir_map, turn_map)
    beams = [start]
    visited = Set()
    while length(beams) > 0
        beam = pop!(beams)
        new_beams, visited = shine(beam, grid, visited, dir_map, turn_map)
        append!(beams, new_beams)
    end
    length(Set([x[1] for x in visited]))
end

function solve(grid, part2)
    dir_map = Dict('n' => (-1, 0), 'e' => (0, 1), 's' => (1, 0), 'w' => (0, -1))
    turn_map = Dict(('\\', 'n') => 'w', ('\\', 'e') => 's', ('\\', 's') => 'e',
        ('\\', 'w') => 'n', ('/', 'n') => 'e', ('/', 'e') => 'n', ('/', 's') => 'w',
        ('/', 'w') => 's')
    if !part2
        calc_energized(grid, ((1, 1), 'e'), dir_map, turn_map)
    else
        i_max = maximum(x -> x[1], keys(grid))
        j_max = maximum(x -> x[2], keys(grid))
        startsr = [((i, 1), 'e') for i = 1:i_max]
        startsl = [((i, j_max), 'w') for i = i_max]
        startsu = [((1, j), 's') for j = 1:j_max]
        startsd = [((i_max, j), 'n') for j = 1:j_max]
        starts = vcat(startsr, startsl, startsu, startsd)
        max_energized = 0
        for start in starts
            energized = calc_energized(grid, start, dir_map, turn_map)
            if energized > max_energized
                max_energized = energized
            end
        end
        max_energized
    end
end

function runit(filename; part2=false)
    grid = read_input(filename)
    solve(grid, part2)
end

runit("16_input.txt")
runit("16_input.txt", part2=true)