function read_input(filename)
    lines = open(filename) do f
        readlines(f)
    end
    scanners = Dict()
    s = []
    id = 0
    i = 2
    while i ≤ length(lines)
        if lines[i] == ""
            scanners[id] = s
            id += 1
            s = []
            i += 2
        else
            push!(s, parse.(Int, split(lines[i], ",")))
            i += 1
        end
    end
    #scanners_matrix = Dict{Int64, Matrix{Int64}}()
    scanners_matrix = Vector{Matrix{Int64}}(undef, length(scanners))
    for (key, val) in scanners
        m = [val[i][j] for j = 1:3, i = 1:length(val)]
        scanners_matrix[key+1] = m
    end
    return scanners_matrix
end

function get_rotations()
    return [
        [1 0 0; 0 1 0; 0 0 1],
        [1 0 0; 0 0 -1; 0 1 0],
        [1 0 0; 0 -1 0; 0 0 -1],
        [1 0 0; 0 0 1; 0 -1 0],
        [0 -1 0; 1 0 0; 0 0 1],
        [0 0 1; 1 0 0; 0 1 0],
        [0 1 0; 1 0 0; 0 0 -1],
        [0 0 -1; 1 0 0; 0 -1 0],
        [-1 0 0; 0 -1 0; 0 0 1],
        [-1 0 0; 0 0 -1; 0 -1 0],
        [-1 0 0; 0 1 0; 0 0 -1],
        [-1 0 0; 0 0 1; 0 1 0],
        [0 1 0; -1 0 0; 0 0 1],
        [0 0 1; -1 0 0; 0 -1 0],
        [0 -1 0; -1 0 0; 0 0 -1],
        [0 0 -1; -1 0 0; 0 1 0],
        [0 0 -1; 0 1 0; 1 0 0],
        [0 1 0; 0 0 1; 1 0 0],
        [0 0 1; 0 -1 0; 1 0 0],
        [0 -1 0; 0 0 -1; 1 0 0],
        [0 0 -1; 0 -1 0; -1 0 0],
        [0 -1 0; 0 0 1; -1 0 0],
        [0 0 1; 0 1 0; -1 0 0],
        [0 1 0; 0 0 -1; -1 0 0]
    ]
end

function compare_scanners(sc1, sc2, R)
    rel = []
    rot = Dict()
    same = Dict()
    for i =  1:size(sc1, 2)
        for j = 1:size(sc2, 2)
            for (r_idx, r) in enumerate(R)
                Δp = sc1[:, i] - r * sc2[:, j]
                if Δp ∈ rel
                    same[Δp] =  get(same, Δp, 1) + 1
                    rot[r_idx] = get(rot, r_idx, 1) + 1
                end
                push!(rel, Δp)
            end
        end
    end
    if !isempty(rot) && maximum(values(rot)) > 11
        return true, argmax(same), R[argmax(rot)]
    else
        return false, nothing, nothing
    end
end

function runit(filename)
    R = get_rotations()
    scanners = read_input(filename)
    scanners0 = [scanners[1]]
    scanners = scanners[2:end]
    Δp_save = []
    loop = 1
    while length(scanners) > 0
        for scanner1 in scanners0
            for (i, scanner2) in enumerate(scanners)
                println("Loop $loop")
                loop += 1
                found_common, Δp, rot = compare_scanners(scanner1, scanner2, R)
                if found_common
                    push!(scanners0, rot * scanners[i] .+ Δp)
                    deleteat!(scanners, i)
                    push!(Δp_save, Δp)
                end
            end
        end
    end
    beacons = unique(hcat(scanners0...), dims = 2)
    return beacons, Δp_save
end

beacons, Δp_save = runit("19_input.txt")

using BSON: @save

bson("19_beacons.bson", beacons = beacons, Δp_save = Δp_save)

