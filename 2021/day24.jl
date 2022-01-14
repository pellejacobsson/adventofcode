function read_input(filename)
    ops = open(filename) do f
        readlines(f)
    end
    return ops
end

function wxyz_to_i(wxyz)
    if wxyz == "w"
        i = 1
    elseif wxyz == "x"
        i = 2
    elseif wxyz == "y"
        i = 3
    elseif wxyz == "z"
        i = 4
    end
    return i
end

function run_code(ops, input)
    x = zeros(Int, 4)
    for op in ops
        sop = split(op, " ")
        if length(sop) == 2
            i = wxyz_to_i(sop[2])
            x[i] = popfirst!(input)
        else
            i = wxyz_to_i(sop[2])
            if sop[3] ∈ ["w", "x", "y", "z"]
                j = wxyz_to_i(sop[3])
                p = x[j]
            else
                p = parse(Int, sop[3])
            end
            if sop[1] == "mul"
                x[i] *= p
            elseif sop[1] == "add"
                x[i] += p
            elseif sop[1] == "div"
                x[i] = Int(floor(x[i] / p))
            elseif sop[1] == "mod"
                x[i] = x[i] % p
            elseif sop[1] == "eql"
                x[i] = x[i] == p ? 1 : 0
            else
                error("Wrong instruction: $op")
            end
        end
    end
    return x[4]
end

function test_z()
    ops = read_input("24_input.txt")
    z = Array{Int64}(undef, (14, 9))
    numbers = ones(Int, 14)
    for i = 1:14
        for j = 1:9
            input = copy(numbers)
            input[i] = j
            z[i, j] = run_code(ops, input)
        end
    end
    return z
end

function test_z2()
    ops = read_input("24_input.txt")
    z = Array{Int64}(undef, (9, 9))
    numbers = ones(Int, 14)
    for i = 1:9
        for j = 1:9
            input = copy(numbers)
            input[13] = i
            input[14] = j
            z[i, j] = run_code(ops, input)
        end
    end
    return z
end

function runit()
    ops = read_input("24_input.txt")
    z_min = typemax(Int)
    number_min = 99999999999999
    for number = 111111:999999
        input = vcat([9, 9, 9, 9, 8, 4, 2, 6], [parse(Int, s) for s in string(number)])
        z = run_code(ops, input)
        if z < z_min
            z_min = z
            number_min = number
        end
    end
    return number_min, z_min
end

n_min, z_min = runit()

z = test_z()
z2 = test_z2()

