function read_input(filename)
    open(filename) do f
        segments = [split(strip(s), " -> ") for s in readlines(f)]
        segments = [[parse.(Int, split(s, ",")) for s in segment] for segment in segments]
    end
end

function fill_rock!(rocks, segment)
    for (seg1, seg2) in zip(segment, segment[2:end])
        x1, y1 = seg1
        x2, y2 = seg2
        xrange = min(x1, x2):max(x1, x2)
        yrange = min(y1, y2):max(y1, y2)
        fill_value = length(xrange) == 1 ? xrange[1] : yrange[1]
        max_len = maximum(length, (xrange, yrange))
        for (x, y) in zip([[r; fill(fill_value, max_len - length(r))] for r in [xrange, yrange]]...)
            push!(rocks, (x, y))
        end
    end
end

function fill_rocks(segments)
    rocks = Set()
    fill_rock!.((rocks,), segments)
    rocks = Dict(r => 1 for r in rocks)
end

function drop_sand!(rocks, y_max, part2; start=(500, 0))
    x, y = start
    while true
        if y >= y_max && !part2
            return 1
        end
        if y + 1 == y_max + 2 && part2
            break
        end
        if !((x, y + 1) in keys(rocks))
            y += 1
        elseif !((x - 1, y + 1) in keys(rocks))
            x -= 1
            y += 1
        elseif !((x + 1, y + 1) in keys(rocks))
            x += 1
            y += 1
        else
            break
        end
    end
    if (x, y) == start
        return 2
    else
        rocks[(x, y)] = 2
        return 0
    end
end

function runit(filename; part2=false)
    segments = read_input(filename)
    rocks = fill_rocks(segments)
    y_max = maximum(x -> x[2], keys(rocks))
    c = 0
    while true
        res = drop_sand!(rocks, y_max, part2)
        if res == 2
            c += 1
            break
        elseif res == 1
            break
        end
        c += 1
    end
    c
end

print("Part 1: $(runit("14_input.txt"))")
print("Part 2: $(runit("14_input.txt", part2=true))")