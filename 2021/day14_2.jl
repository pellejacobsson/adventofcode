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

function count_elements(polymer, first_element, last_element)
    elements = Dict{String, Int64}()
    for (key, val) in polymer
        k1 = string(key[1])
        k2 = string(key[2])
        elements[k1] = get(elements, k1, 0) + val
        elements[k2] = get(elements, k2, 0) + val
    end
    for (key, val) in elements
        if key == first_element || key == last_element
            elements[key] = Int((val + 1) / 2)
        else
            elements[key] = Int(val / 2)
        end
    end
    return elements
end


function runit(filename, n_times)
    code, rules = read_input(filename)
    code = join(code)

    polymer = Dict{String, Int64}()
    for i = 1:length(code)-1
        key = code[i:i+1]
        polymer[key] = get(polymer, key, 0) + 1
    end
    for n = 1:n_times
        new_polymer = Dict{String, Int64}()
        for (key, val) in polymer
            new_code = string(key[1])*rules[key]*string(key[2])
            new_polymer[new_code[1:2]] = get(new_polymer, new_code[1:2], 0) + val
            new_polymer[new_code[2:3]] = get(new_polymer, new_code[2:3], 0) + val
        end
        polymer = new_polymer
    end
    elements = count_elements(polymer, string(code[1]), string(code[end]))
    return maximum(values(elements)) - minimum(values(elements))
end


out = runit("14_input.txt", 40)