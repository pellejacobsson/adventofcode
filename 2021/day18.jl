function read_input(filename)
    lines = open(filename) do f
        readlines(f)
    end
    return lines
end

function parse_pair(line)
    d = 0
    i = 1
    val =[]
    depth = []
    while i ≤ length(line)
        if line[i] == ','
            i += 1
        elseif line[i] == '['
            d += 1
            i += 1
        elseif line[i] == ']'
            d -= 1
            i += 1
        elseif occursin(line[i], "0123456789")
            if occursin(line[i+1], "0123456789")
                push!(val, parse(Int, line[i:i+1]))
                push!(depth, d)
                i += 2
            else
                push!(val, parse(Int, line[i]))
                push!(depth, d)
                i += 1
            end
        else
            error("Unknown character: $(line[i])")
        end
    end
    return val, depth
end

function explode(val, depth)
    for i = 1:length(val)-1
        if depth[i] > 4 && (depth[i] == depth[i+1])
            if i > 1
                val[i-1] += val[i]
            end
            if i < length(val) - 1
                val[i+2] += val[i+1]
            end
            val[i] = 0
            deleteat!(val, i+1)
            depth[i] -= 1
            deleteat!(depth, i+1)
            return true, val, depth
        end
    end
    return false, val, depth
end

function splitit(val, depth)
    for i = 1:length(val)
        if val[i] > 9
            v1 = Int(floor(val[i] / 2))
            v2 = Int(ceil(val[i] / 2))
            if i == 1
                val[i] = v2
                val = vcat(v1, val)
                depth[i] += 1
                depth = vcat(depth[i], depth)
            elseif i == length(val)
                val[i] = v1
                push!(val, v2)
                depth[i] += 1
                push!(depth, depth[i])
            else
                val = vcat(val[1:i-1], v1, v2, val[i+1:end])
                depth = vcat(depth[1:i-1], depth[i] + 1, depth[i] + 1, depth[i+1:end])
            end
            return true, val, depth
        end
    end
    return false, val, depth
end

function reduce_pair(val, depth)
    while true
        did_explode, val, depth = explode(val, depth)
        if did_explode
            #println("Exploded")
            continue
        end
        did_split, val, depth = splitit(val, depth)
        # if did_split
        #     println("Split")
        # end
        if !did_split
            break
        end
    end
    return val, depth
end

function add_pairs(val1, val2, depth1, depth2)
    val = vcat(val1, val2)
    depth = vcat(depth1, depth2)
    depth .+= 1
    val, depth = reduce_pair(val, depth)
    return val, depth
end


function calc_magnitude(val, depth)
    while length(val) > 1
        max_depth = maximum(depth)
        i = findfirst(x -> x == max_depth, depth)
        val[i] = 3 * val[i] + 2 * val[i+1]
        deleteat!(val, i + 1)
        depth[i] -= 1
        deleteat!(depth, i + 1)
    end
    return val[1]
end

function runit(filename)
    pairs = read_input(filename)
    val1, depth1 = parse_pair(pairs[1])
    for n = 2:length(pairs)
        val2, depth2 = parse_pair(pairs[n])
        val1, depth1 = add_pairs(val1, val2, depth1, depth2)
    end
    return calc_magnitude(val1, depth1)
end

out = runit("18_input.txt")

# Part 2
function magn_of_two(pair1, pair2)
    val1, depth1 = parse_pair(pair1)
    val2, depth2 = parse_pair(pair2)
    val, depth = add_pairs(val1, val2, depth1, depth2)
    return calc_magnitude(val, depth)
end

function runit2(filename)
    pairs = read_input(filename)
    m = zeros(Int, length(pairs), length(pairs))
    for i = 1:length(pairs), j = 1:length(pairs)
        if i != j
            m[i, j] = magn_of_two(pairs[i], pairs[j])
        end
    end
    return m
end

m = runit2("18_input.txt")
out = maximum(m)