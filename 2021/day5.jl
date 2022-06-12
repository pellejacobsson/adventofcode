struct Line
    x0
    y0
    x1
    y1
end

function get_lines(filename; straight = false)
    lines = open(filename) do f
        re = r"^([0-9]*),([0-9]*) -> ([0-9]*),([0-9]*)"
        l = Line[]
        for line in readlines(f)
            m = match(re, line)
            push!(l, Line(parse.(Int, m.captures)...))
        end
        return l
    end
    idx = []
    if straight
        for (i, line) in enumerate(lines)
            if line.x0 == line.x1 || line.y0 == line.y1
                push!(idx, i)
            end
        end
        lines = lines[idx]
    end
    return lines
end

function get_floor_size(lines)
    x_max = 0
    y_max = 0
    for line in lines
        x_max_l = max(line.x0, line.x1)
        y_max_l = max(line.y0, line.y1)
        x_max = x_max_l > x_max ? x_max_l : x_max
        y_max = y_max_l > y_max ? y_max_l : y_max
    end
    return x_max, y_max
end

function get_points_on_line(line)
    x_min = min(line.x0, line.x1)
    x_max = max(line.x0, line.x1)
    y_min = min(line.y0, line.y1)
    y_max = max(line.y0, line.y1)
    if line.x0 == line.x1
        return [(line.x0, y) for y = y_min:y_max]
    end
    if line.y0 == line.y1
        return [(x, line.y0) for x = x_min:x_max]
    end
    k = (line.y1 - line.y0) / (line.x1 - line.x0)
    m = line.y0 - k * line.x0
    points = []
    for x = x_min:x_max
        y = k * x + m
        if isinteger(y)
            push!(points, (x, Int(y)))
        end
    end
    return points
end

lines = get_lines("5_input.txt", straight = false)
x_max, y_max = get_floor_size(lines)
d = Dict()
for line in lines
    points = get_points_on_line(line)
    for point in points
        d[point] = get(d, point, 0) + 1
    end
end

out = sum(values(d) .> 1)