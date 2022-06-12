using DataStructures

function get_x_home(i)
    i ∈ 1:4 && return 3
    i ∈ 5:8 && return 5
    i ∈ 9:12 && return 7
    i ∈ 13:16 && return 9
    error("Wrong index: $i")
end

function get_possible_states(amphipod_state)
    new_states = Vector{Vector{Tuple{Int64, Int64}}}()
    hallway_occupied = [pos[1] for pos in amphipod_state if pos[2] == 5]
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
        if x == x_home && y == 3
            if (x_home, 1) ∈ amphipod_state && (x_home, 2) ∈ amphipod_state
                idx1 = findfirst(amphipod_state) do a
                    a == (x_home, 1)
                end
                idx2 = findfirst(amphipod_state) do a
                    a == (x_home, 2)
                end
                if get_x_home(idx1) == x_home && get_x_home(idx2) == x_home
                    continue
                end
            end
        end
        if x == x_home && y == 4
            if (x_home, 1) ∈ amphipod_state && (x_home, 2) ∈ amphipod_state && (x_home, 3) ∈ amphipod_state
                idx1 = findfirst(amphipod_state) do a
                    a == (x_home, 1)
                end
                idx2 = findfirst(amphipod_state) do a
                    a == (x_home, 2)
                end
                idx3 = findfirst(amphipod_state) do a
                    a == (x_home, 3)
                end
                if get_x_home(idx1) == x_home && get_x_home(idx2) == x_home && get_x_home(idx3) == x_home
                    continue
                end
            end
        end
        if y == 4 || (y == 3 && (x, 4) ∉ amphipod_state) || 
                (y == 2 && (x, 4) ∉ amphipod_state && (x, 3) ∉ amphipod_state) ||
                (y == 1 && (x, 4) ∉ amphipod_state && (x, 3) ∉ amphipod_state && (x, 2) ∉ amphipod_state)
            x_left = maximum([1; hallway_occupied[hallway_occupied .< x] .+ 1])
            x_right = minimum([hallway_occupied[hallway_occupied .> x] .- 1; 11])
            possible_x = setdiff(x_left:x_right, [3, 5, 7, 9])
            for x_new in possible_x
                new_state = copy(amphipod_state)
                new_state[i] = (x_new, 5)
                push!(new_states, new_state)
            end
        elseif y == 5
            if any(x .> hallway_occupied .> x_home) || any(x .< hallway_occupied .< x_home)
                continue
            end
            if (x_home, 1) ∉ amphipod_state
                new_state = copy(amphipod_state)
                new_state[i] = (x_home, 1)
                push!(new_states, new_state)
            elseif (x_home, 2) ∉ amphipod_state
                idx = findfirst(amphipod_state) do a
                    a == (x_home, 1)
                end
                amphipod_idx = get_x_home(idx)
                if amphipod_idx == x_home
                    new_state = copy(amphipod_state)
                    new_state[i] = (x_home, 2)
                    push!(new_states, new_state)
                end
            elseif (x_home, 3) ∉ amphipod_state
                idx1 = findfirst(amphipod_state) do a
                    a == (x_home, 1)
                end
                idx2 = findfirst(amphipod_state) do a
                    a == (x_home, 2)
                end
                amphipod_idx1 = get_x_home(idx1)
                amphipod_idx2 = get_x_home(idx2)
                if amphipod_idx1 == x_home && amphipod_idx2 == x_home
                    new_state = copy(amphipod_state)
                    new_state[i] = (x_home, 3)
                    push!(new_states, new_state)
                end
            elseif (x_home, 4) ∉ amphipod_state
                idx1 = findfirst(amphipod_state) do a
                    a == (x_home, 1)
                end
                idx2 = findfirst(amphipod_state) do a
                    a == (x_home, 2)
                end
                idx3 = findfirst(amphipod_state) do a
                    a == (x_home, 3)
                end
                amphipod_idx1 = get_x_home(idx1)
                amphipod_idx2 = get_x_home(idx2)
                amphipod_idx3 = get_x_home(idx3)
                if amphipod_idx1 == x_home && amphipod_idx2 == x_home && amphipod_idx3 == x_home
                    new_state = copy(amphipod_state)
                    new_state[i] = (x_home, 4)
                    push!(new_states, new_state)
                end
            end
        end
    end
    return new_states
end

function target_reached(state)
    is_target = all([s[1] for s in state[1:4]] .== 3) && all([s[1] for s in state[5:8]] .== 5) &&
                all([s[1] for s in state[9:12]] .== 7) && all([s[1] for s in state[13:16]] .== 9)
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
        if i ∈ 1:4
            factor = 1
        elseif i ∈ 5:8
            factor = 10
        elseif i ∈ 9:12
            factor = 100
        elseif i ∈ 13:16 
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

#out = runit([(3, 1), (7, 2), (9, 1), (9, 3), (3, 4), (5, 2), (7, 3), (7, 4), (5, 3), (5, 4), (7, 1), (9, 2), (3, 2), (3, 3), (5, 1), (9, 4)])
out = runit([(3, 4), (5, 1), (7, 2), (9, 3), (5, 2), (7, 3), (7, 4), (9, 1), (5, 3), (5, 4), (9, 2), (9, 4), (3, 1), (3, 2), (3, 3), (7, 1)])