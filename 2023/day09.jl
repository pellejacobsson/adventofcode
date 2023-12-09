function read_input(filename)
    open(filename) do f
        [parse.(Int, split(line)) for line in readlines(f)]
    end
end

function diff_to_zero(vals, part)
    end_vals = [vals[part == 1 ? end : 1]]
    while true
        vals = diff(vals)
        if all(vals .== 0)
            break
        end
        save_val = vals[part == 1 ? end : 1]
        push!(end_vals, save_val)
    end
    if part == 1
        v = sum(end_vals)
    else
        v = 0
        for n in reverse(end_vals)
            v = n - v
        end
    end
    v
end

function solve(vals_list, part=1)
    sum(diff_to_zero.(vals_list, part))
end

function runit(part=1)
    values = read_input("09_input.txt")
    solve(values, part)
end

runit(1)
runit(2)