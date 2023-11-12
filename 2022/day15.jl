function read_input(filename)
    expr = r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"
    sensors = Dict{Vector{Int64}, Tuple{Vector{Int64}, Int64}}()
    open(filename) do f
        for line in readlines(f)
            m = match(expr, line)
            s = parse.(Int, [m[1], m[2]])
            b = parse.(Int, [m[3], m[4]])
            d = abs(b[1] - s[1]) + abs(b[2] - s[2])
            sensors[s] = (b, d)
        end
    end
    sensors
end

function runit(filename)
    sensors = read_input(filename)
    y_line = 2000000
    x_pos = Set()
    x_pos_beacon = Set()
    for ((sensor_x, sensor_y), ((beacon_x, beacon_y), dist)) in sensors
        dx = dist - abs(sensor_y - y_line)
        x_min = sensor_x - dx
        x_max = sensor_x + dx
        union!(x_pos, Set(x_min:x_max))
        if beacon_y == y_line
            push!(x_pos_beacon, beacon_x)
        end
    end
    length(setdiff(x_pos, x_pos_beacon))
end

function get_sensor_polygons(sensors)
    polygons = []
    for ((sensor_x, sensor_y), ((beacon_x, beacon_y), dist)) in sensors
        polygon = (
            (sensor_x + dist, sensor_x, sensor_x - dist, sensor_x),
            (sensor_y, sensor_y - dist, sensor_y, sensor_y + dist)
        )
        push!(polygons, polygon)
    end
    polygons
end

function segs_intersect(h_seg, v_seg)
    if h_seg[2] <= v_seg[1] <= h_seg[3] && v_seg[2] <= h_seg[1] <= v_seg[3]
        return (v_seg[1], h_seg[1])
    else
        return nothing
    end
end

function runit2(filename)
    sensors = read_input(filename)
    polygons = get_sensor_polygons(sensors)
    u = [[polygon[1][n] + polygon[2][n] for n = 1:4] for polygon in polygons]
    v = [[polygon[1][n] - polygon[2][n] for n = 1:4] for polygon in polygons]
    h_segs = []
    v_segs = []
    for (uu, vv) in zip(u, v)
        push!(h_segs, (vv[1], uu[2], uu[1]))
        push!(h_segs, (vv[3], uu[3], uu[4]))
        push!(v_segs, (uu[2], vv[3], vv[2]))
        push!(v_segs, (uu[1], vv[4], vv[1]))
    end
    intersections = []
    for h_seg in h_segs, v_seg in v_segs
        inters = segs_intersect(h_seg, v_seg)
        if !(inters === nothing)
            push!(intersections, inters)
        end
    end
    u2 = Set()
    for i1 in intersections, i2 in intersections
        du = abs(i1[1] - i2[1])
        if du == 2
            push!(u2, i1)
            push!(u2, i2)
        end
    end
    v2 = Set()
    for (uu1, vv1) in u2, (uu2, vv2) in u2
        dv = abs(vv1 - vv2)
        if dv == 2
            push!(v2, (uu1, vv1))
        end
    end
    u_sol = minimum([p[1] for p in v2]) + 1
    v_sol = minimum([p[2] for p in v2]) + 1
    x = (u_sol + v_sol) ÷ 2
    y = (u_sol - v_sol) ÷ 2
    4000000 * x + y
end

runit("15_input.txt")
runit2("15_input.txt")