function read_input(filename)
    input = open(filename) do f
        split(read(f, String), "\n\n")
    end
    seeds = parse.(Int, split(input[1])[2:end])
    range_maps = [[parse.(Int, l) for l in split.(split(input[n], "\n")[2:end])] for n = 2:8]
    seeds, range_maps
end

function source_to_dest(source, range_map)
    for (dest_start, source_start, len) in range_map
        if source_start <= source <= source_start + len - 1
            return source - source_start + dest_start
        end
    end
    return source
end

function solve(seeds, range_maps)
    dests = seeds
    for range_map in range_maps
        dests = source_to_dest.(dests, (range_map,))
    end
    minimum(dests)
end

function source_to_dest2!(ranges, source, range_map)
    found = false
    for (dest_start, source_start, len) in range_map
        overlap = intersect(source, source_start:source_start + len - 1)
        if length(overlap) == 0
            continue
        end
        dest = overlap .+ (dest_start - source_start)
        if length(dest) != length(source)
            if source[1] < source_start
                push!(ranges, source[1]:source_start - 1)
            end
            if source[end] > source_start + len - 1
                push!(ranges, source_start + len:source[end])
            end
        end
        found = true
        break
    end
    if !found
        dest = source
    end
    dest
end

function solve2(seeds, range_maps)
    ranges = [s:s+l-1 for (s, l) in zip(seeds[1:2:end], seeds[2:2:end])]
    for range_map in range_maps
        dest_ranges = UnitRange{Int64}[]
        while length(ranges) > 0
            range = popfirst!(ranges)
            dest_range = source_to_dest2!(ranges, range, range_map)
            push!(dest_ranges, dest_range)
        end
        ranges = dest_ranges
    end
    minimum(r -> r[1], ranges)
end

function runit(filename)
    seeds, range_maps = read_input(filename)
    part1 = solve(seeds, range_maps)
    println("Part 1: $part1")
    part2 = solve2(seeds, range_maps)
    println("Part 2: $part2")
end

runit("05_input.txt")