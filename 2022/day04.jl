function read_input(filename)
    open(filename, "r") do f
        [[parse.(Int, x) for x in split.(line, "-")] for line in split.(readlines(f), ",")]
    end
end

function range_covers(ranges)
    r1, r2 = ranges
    (r1[1] <= r2[1] && r1[2] >= r2[2]) || (r2[1] <= r1[1] && r2[2] >= r1[2])
end

function range_overlaps(ranges)
    r1, r2 = ranges
    (r1[1] <= r2[2] && r1[2] >= r2[1]) || (r2[1] <= r1[2] && r2[2] >= r1[1])
end

function runit(filename; part2=false)
    sections = read_input(filename)
    func = part2 ? range_overlaps : range_covers
    sum(func(ranges) for ranges in sections)
end

runit("04_input.txt")
runit("04_input.txt"; part2=true)