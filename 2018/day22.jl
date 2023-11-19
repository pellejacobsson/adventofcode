using DataStructures

function create_cave(depth, target, x_max, y_max)
    erosion_level = Dict((0, 0) => depth % 20183, target => depth % 20183)
    for x = 0:x_max, y = 0:y_max
        if (x, y) == target
            continue
        end
        if y == 0
            erosion_level[x, y] = (x * 16807 + depth) % 20183
        elseif x == 0
            erosion_level[x, y] = (y * 48271 + depth) % 20183
        else
            erosion_level[x, y] = (erosion_level[x, y - 1] * erosion_level[x - 1, y] + depth) % 20183
        end
    end
    cave = Dict{Tuple{Int, Int}, Int}()
    for ((x, y), el) in erosion_level
        cave[x, y] = el % 3
    end
    cave
end

function get_adjacent(cave, u)
    allowed = Dict(0 => (0, 1), 1 => (1, 2), 2 => (0, 2))
    x, y, tool = u
    region = cave[x, y]
    adj = Tuple{Int, Tuple{Int, Int, Int}}[]
    for (dx, dy) in [(-1, 0), (1, 0), (0, -1), (0, 1)]
        xn, yn = x + dx, y + dy
        if xn < 0 || yn < 0
            continue
        end
        region_new = cave[xn, yn]
        if tool in allowed[region_new]
            push!(adj, (1, (xn, yn, tool)))
        end
    end
    other = tool == allowed[region][1] ? allowed[region][2] : allowed[region][1]
    push!(adj, (7, (x, y, other)))
    adj
end

function dijkstra(cave, source, target)
    dist = Dict(source => 0)
    pq = PriorityQueue{Tuple{Tuple{Int, Int, Int}, Int}, Int}()
    enqueue!(pq, (source, 1), dist[source])
    i = 2
    while !isempty(pq)
        u, _ = dequeue!(pq)
        if u == target
            return dist[target]
        end
        for (d, v) in get_adjacent(cave, u)
            dn = dist[u] + d
            if !(v in keys(dist)) || dn < dist[v]
                dist[v] = dn
                enqueue!(pq, (v, i), dn)
                i += 1
            end
        end
    end                   
    println("Something went wrong!")
end

function runit(;part2=false)
    depth = 10647
    target = (7, 770)
    if !part2                          
        cave = create_cave(depth, target, target[1], target[2])
        res = sum(values(cave))
    else
        cave = create_cave(depth, target, 1000, 1000)
        res = dijkstra(cave, (0, 0, 0), (target..., 0))
    end
    res
end

runit()
runit(part2=true)                              