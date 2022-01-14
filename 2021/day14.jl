function read_input(filename)
    lines = open(filename) do f
        readlines(f)
    end
    code = lines[1]
    rules = Dict{String, String}()
    for line in lines[3:end]
        key, val = split(line, " -> ")
        rules[key] = val
    end
    code = [string(s) for s in code]
    return code, rules
end

function step(code, rules)
    inserts = String[]
    for i in 1:length(code)-1
        pair = join(code[i:i+1])
        push!(inserts, rules[pair])
    end
    new_length = length(code) + length(inserts)
    code_new = Vector{String}(undef, new_length)
    code_new[1:2:new_length] = code
    code_new[2:2:new_length-1] = inserts
    code = code_new
    return code
end

function score(code)
    components = unique(code)
    min_val = Inf
    max_val = 0
    for component in components
        count = sum(code .== component)
        if count < min_val
            min_val = count
        end
        if count > max_val
            max_val = count
        end
    end
    return max_val - min_val
end

function run_it(filename, n_times)
    code, rules = read_input(filename)
    for n = 1:n_times
        code = step(code, rules)
    end
    return score(code)
end

out = run_it("14_input.txt", 10)