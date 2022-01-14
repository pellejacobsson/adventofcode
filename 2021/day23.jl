using DataStructures

function get_x_home(i)
    (i == 1 || i == 2) && return 3
    (i == 3 || i == 4) && return 5
    (i == 5 || i == 6) && return 7
    (i == 7 || i == 8) && return 9
    error("Wrong index: $i")
end

function get_possible_states(amphipod_state)
    new_states = Vector{Vector{Tuple{Int64, Int64}}}()
    hallway_occupied = [pos[1] for pos in amphipod_state if pos[2] == 3]
    for (i, amphipod) in enumerate(amphipod_state)
        x_home = get_x_home(i)
        x, y = amphipod
        if x == x_home && y == 1
            continue
        end
        if x == x_home && y == 2
            if (x_home, 1) ∈ amphipod_state
                idx = findfirst(amphipod_state) do a
                    a == (x_home, 1)
                end
                if get_x_home(idx) == x_home
                    continue
                end
            end
        end
        if y == 2 || (y == 1 && (x, 2) ∉ amphipod_state)
            x_left = maximum([1; hallway_occupied[hallway_occupied .< x] .+ 1])
            x_right = minimum([hallway_occupied[hallway_occupied .> x] .- 1; 11])
            possible_x = setdiff(x_left:x_right, [3, 5, 7, 9])
            for x_new in possible_x
                new_state = copy(amphipod_state)
                new_state[i] = (x_new, 3)
                push!(new_states, new_state)
            end
        elseif y == 3
            if any(x .> hallway_occupied .> x_home) || any(x .< hallway_occupied .< x_home)
                continue
            end
            if (x_home, 1) ∉ amphipod_state && (x_home, 2) ∉ amphipod_state
                new_state = copy(amphipod_state)
                new_state[i] = (x_home, 1)
                push!(new_states, new_state)
            else
                home_one_of_same = false
                if (x_home, 2) ∉ amphipod_state
                    idx = findfirst(amphipod_state) do a
                        a == (x_home, 1)
                    end
                    amphipod_idx = get_x_home(idx)
                    if amphipod_idx == x_home
                        home_one_of_same = true
                    end
                end
                if home_one_of_same
                    new_state = copy(amphipod_state)
                    new_state[i] = (x_home, 2)
                    push!(new_states, new_state)
                end
            end
        end
    end
    return new_states
end

function target_reached(state)
    is_target = ((state[1] == (3, 1) && state[2] == (3, 2)) || (state[1] == (3, 2) && state[2] == (3, 1))) &&
                ((state[3] == (5, 1) && state[4] == (5, 2)) || (state[3] == (5, 2) && state[4] == (5, 1))) &&
                ((state[5] == (7, 1) && state[6] == (7, 2)) || (state[5] == (7, 2) && state[6] == (7, 1))) &&
                ((state[7] == (9, 1) && state[8] == (9, 2)) || (state[7] == (9, 2) && state[8] == (9, 1)))
    return is_target
end

function calc_dist(u, v)
    dist = 0
    for (i, (a, b)) in enumerate(zip(u, v))
        if a == b
            continue
        end
        Δx = abs(a[1] - b[1])
        Δy = abs(a[2] - b[2])
        if i == 1 || i == 2
            factor = 1
        elseif i == 3 || i == 4
            factor = 10
        elseif i == 5 || i == 6
            factor = 100
        elseif i == 7 || i == 8
            factor = 1000
        end
        dist += factor * (Δx + Δy)
    end
    return dist
end


function dijkstra(source)
    q = PriorityQueue{Vector{Tuple}, Int64}()
    dist = Dict{Vector{Tuple}, Int64}()
    prev = Dict{Vector{Tuple}, Vector{Tuple}}()
    dist[source] = 0
    enqueue!(q, source, dist[source])
    while length(q) > 0
        u = dequeue!(q)
        for v in get_possible_states(u)
            alt = dist[u] + calc_dist(u, v)
            if alt < get(dist, v, typemax(Int))
                dist[v] = alt
                prev[v] = u
                if v ∉ keys(q)
                    enqueue!(q, v, dist[v])
                end
            end
        end
    end
    return dist, prev
end

function runit(source)
   dist, prev = dijkstra(source)

    min_dist = typemax(Int)
    for (key, val) in dist
        if target_reached(key)
            if val < min_dist
                min_dist = val
            end
        end
    end
    return min_dist
end

out = runit([(3, 2), (5, 1), (7, 2), (9, 1), (5, 2), (9, 2), (3, 1), (7, 1)])