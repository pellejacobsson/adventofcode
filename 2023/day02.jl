function read_input(filename)
    games = []
    open(filename) do f
        for line in readlines(f)
            _, cube_part = split(line, ": ")
            sets = []
            for set in split(cube_part, "; ")
                cube_dict = Dict()
                for cubes in split(set, ", ")
                    n, color = split(cubes)
                    cube_dict[color] = parse(Int, n)
                end
                push!(sets, cube_dict)
            end
            push!(games, sets)
        end
    end
    games
end

function read_input2(filename)
    games = []
    rgb_map = Dict("red" => 1, "green" => 2, "blue" => 3)
    open(filename) do f
        for line in readlines(f)
            _, cube_part = split(line, ": ")
            sets = split(cube_part, "; ")
            cubes = zeros(Int, 3, length(sets))
            for (j, set) in enumerate(sets)
                for cube in split(set, ", ")
                    n, color = split(cube)
                    cubes[rgb_map[color], j] = parse(Int, n)
                end
            end
            push!(games, cubes)
        end
    end
    games
end

function runit(filename)
    games = read_input(filename)
    id_sum = 0
    power_sum = 0
    for (n, game) in enumerate(games)
        valid = true
        r_max, g_max, b_max = 0, 0, 0
        for set in game
            r = get(set, "red", 0)
            g = get(set, "green", 0)
            b = get(set, "blue", 0)
            if r > 12 || g > 13 || b > 14
                valid = false
            end
            r_max = max(r_max, r)
            g_max = max(g_max, g)
            b_max = max(b_max, b)
        end
        id_sum += valid ? n : 0
        power_sum += r_max * g_max * b_max
    end
    id_sum, power_sum
end

function runit2(filename)
    games = read_input2(filename)
    games_max = [vec(maximum(game, dims=2)) for game in games]
    id_sum = sum([n for (n, game_max) in enumerate(games_max) if all(game_max .<= [12, 13, 14])])
    power_sum = sum(prod.(games_max))
    id_sum, power_sum
end

runit("02_input.txt")
runit2("02_input.txt")