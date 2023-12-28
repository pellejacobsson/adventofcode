function read_input(filename)
    bricks = []
    open(filename) do f
        for line in readlines(f)
            push!(bricks, [parse.(Int, split(c, ",")) for c in split(line, "~")])
        end
    end
    sort(bricks, by=b -> b[1][3])
end

function intersect_xy(a, b)
    xa = a[1][1]:a[2][1]
    xb = b[1][1]:b[2][1]
    ya = a[1][2]:a[2][2]
    yb = b[1][2]:b[2][2]
    length(intersect(xa, xb)) > 0 && length(intersect(ya, yb)) > 0
end

function fall(bricks)
    for (i, brick) in enumerate(bricks)
        max_z = 1
        for brick_l in bricks[1:i-1]
            if intersect_xy(brick, brick_l)
                max_z = max(max_z, brick_l[2][3] + 1)
            end
        end
        delta_z = brick[2][3] - brick[1][3]
        brick[2][3] = max_z + delta_z
        brick[1][3] = max_z
    end
end

function fall_test(bricks_orig, i_rem)
    bricks = deepcopy(bricks_orig)
    deleteat!(bricks, i_rem)
    bricks_fell = 0
    for (i, brick) in enumerate(bricks)
        max_z = 1
        for brick_l in bricks[1:i-1]
            if intersect_xy(brick, brick_l)
                max_z = max(max_z, brick_l[2][3] + 1)
            end
        end
        if brick[1][3] != max_z
            bricks_fell += 1
        end
        delta_z = brick[2][3] - brick[1][3]
        brick[2][3] = max_z + delta_z
        brick[1][3] = max_z
    end
    return bricks_fell
end

function find_support(bricks)
    supports = Dict()
    supported_by = Dict()
    for (i, brick) = enumerate(bricks)
        supports[i] = []
        supported_by[i] = []
        z_up_ix = findall(b -> b[1][3] == brick[2][3] + 1, bricks)
        z_down_ix = findall(b -> b[2][3] == brick[1][3] - 1, bricks)
        for j = z_up_ix
            if intersect_xy(brick, bricks[j])
                push!(supports[i], j)
            end
        end
        for j = z_down_ix
            if intersect_xy(brick, bricks[j])
                push!(supported_by[i], j)
            end
        end
    end
    supports, supported_by
end

function solve(bricks)
    supports, supported_by = find_support(bricks)
    s1 = Set([i for (i, v) in supports if length(v) == 0])
    s2 = Set(vcat([v for v in values(supported_by) if length(v) > 1]...))
    s3 = Set(vcat([v for v in values(supported_by) if length(v) == 1]...))
    setdiff(union(s1, s2), s3)
end

function runit(filename)
    bricks = read_input(filename)
    fall(bricks)
    sort!(bricks, by=b -> b[1][3])
    removable = solve(bricks)
    n_removable = length(removable)
    println("Part 1: $n_removable")
    s = 0
    for i = 1:length(bricks)
        i in removable && continue
        s_fall = fall_test(bricks, i)
        s += s_fall
    end
    println("Part 2: $s")
end

runit("22_input.txt")