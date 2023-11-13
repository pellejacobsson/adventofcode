struct Valve
    flow_rate
    neighbors
end

function read_input(filename)
    valves = Dict{String, Valve}()
    expr = r"^Valve ([A-Z]{2}) has flow rate=(\d+); tunnels? leads? to valves? (.*)$"
    open(filename) do f
        for line in readlines(f)
            m = match(expr, line)
            flow_rate = parse(Int, m[2])
            neighbors = split(m[3], ", ")
            valves[m[1]] = Valve(flow_rate, neighbors)
        end
    end
    valves
end

function bfs(valves, start)
    q = [start]
    visited = Set([start])
    dist = Dict(start => 0)
    while length(q) > 0
        u = popfirst!(q)
        for v in valves[u].neighbors
            if !(v in visited)
                push!(visited, v)
                dist[v] = dist[u] + 1
                push!(q, v)
            end
        end
    end
    dist
end

function calc_dists(valves)
    flow_rate_valves = [k for (k, v) in valves if v.flow_rate > 0]
    dists = Dict{String, Dict{String, Int}}()
    for start_valve in ["AA"; flow_rate_valves]
        d = bfs(valves, start_valve)
        dists[start_valve] = Dict(k => v for (k, v) in d if k in flow_rate_valves && k!= start_valve)
    end
    dists
end

function dfs(dists, valves, time, start, opened_valves)
    comb = [opened_valves]
    if time < 2
        return comb
    end
    for adj in valves
        new_time = time - dists[start][adj] - 1
        new_ov = merge(opened_valves, Dict(adj => new_time))
        new_valves = setdiff(valves, Set([adj]))
        comb = [comb; dfs(dists, new_valves, new_time, adj, new_ov)]
    end
    comb
end

function dfs_iterative(dists, valves, time, start)
    stack = [(time, start, Dict{String, Int}(), valves)]
    comb = []

    while !isempty(stack)
        time, start, opened_valves, valves = pop!(stack)
        if time < 2
            push!(comb, opened_valves)
            continue
        end
        for adj in valves
            new_time = time - dists[start][adj] - 1
            new_ov = merge(opened_valves, Dict(adj => new_time))
            new_valves = setdiff(valves, Set([adj]))
            push!(stack, (new_time, adj, new_ov, new_valves))
        end
    end
    comb
end

function runit(filename)
    valves = read_input(filename)
    dists = calc_dists(valves)
    flow_valves = Set(k for (k, v) in valves if v.flow_rate > 0)
    #comb = dfs(dists, flow_valves, 30, "AA", Dict())
    comb = dfs_iterative(dists, flow_valves, 30, "AA")
    max_pressure = 0
    for visited in comb
        flow_vals = [valves[k].flow_rate * v for (k, v) in visited]
        if length(flow_vals) == 0
            continue
        end
        pressure = sum(flow_vals)
        if pressure > max_pressure
            max_pressure = pressure
        end
    end
    max_pressure
end

function runit2(filename)
    valves = read_input(filename)
    dists = calc_dists(valves)
    flow_valves = Set(k for (k, v) in valves if v.flow_rate > 0)
    comb = dfs_iterative(dists, flow_valves, 26, "AA")
    comb_sorted = sort(comb, by=x -> sum(valves[k].flow_rate * v for (k, v) in x), rev=true)
    max_pressure = 0
    for human in comb_sorted, elephant in comb_sorted
        human_pressure = sum(valves[k].flow_rate * v for (k, v) in human)
        elephant_pressue = sum(valves[k].flow_rate * v for (k, v) in elephant)
        pressure = human_pressure + elephant_pressue
        if pressure <= max_pressure
            break
        end
        human_set = Set(keys(human))
        elephant_set = Set(keys(elephant))
        if length(intersect(human_set, elephant_set)) == 0
            if pressure > max_pressure
                max_pressure = pressure
            end
        end
    end
    max_pressure
end

runit("16_input.txt")

# Gives wrong answer...
runit2("16_input.txt")