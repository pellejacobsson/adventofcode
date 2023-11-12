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
    dists = Dict()
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

function runit(filename)
    valves = read_input(filename)
    dists = calc_dists(valves)
    flow_valves = Set(k for (k, v) in valves if v.flow_rate > 0)
    comb = dfs(dists, flow_valves, 30, "AA", Dict())
    @show length(comb)
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

runit("16_input.txt")