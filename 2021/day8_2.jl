function read_input(filename)
    lines = open(filename) do f
        readlines(f)
    end
    signal_list = String[]
    digits_list = String[]
    for line in lines
        s, d = split(line, " | ")
        push!(signal_list, s)
        push!(digits_list, d)
    end
    return signal_list, digits_list
end

function get_decoder(signal)
    dec = Dict()
    digits = split(signal)
    for digit in digits
        if length(digit) == 2
            dec[1] = digit
        elseif length(digit) == 4
            dec[4] = digit
        elseif length(digit) == 3
            dec[7] = digit
        elseif length(digit) == 7
            dec[8] = digit
        end
    end
    digits = setdiff(digits, [dec[1], dec[4], dec[7], dec[8]])
    for digit in digits
        if length(digit) == 5 && length(setdiff(digit, dec[7])) == 2
            dec[3] = digit
            break
        end
    end
    digits = setdiff(digits, [dec[3]])
    dec[9] = join(string.(union(dec[4], dec[3])))
    for digit in digits
        if Set(dec[9]) == Set(digit)
            digits = setdiff(digits, [digit])
            break
        end
    end
    digits5 = [d for d in digits if length(d) == 5]
    digits6 = [d for d in digits if length(d) == 6]
    d = intersect(dec[4], intersect(digits5...))
    for d6 in digits6
        if length(intersect(d, d6)) == 0
            dec[0] = d6
            break
        end
    end
    dec[6] = setdiff(digits6, [dec[0]])[1]
    digits = setdiff(digits, digits6)
    c = setdiff(dec[8], dec[6])
    for d5 in digits5
        if length(intersect(c, d5)) != 0
            dec[2] = d5
            break
        end
    end
    dec[5] = setdiff(digits5, [dec[2]])[1]
    return dec
end 

function decode(dec, s)
    for (key, val) in dec
        if Set(val) == Set(s)
            return key
        end
    end
end

function list_to_int(list)
    s = join(string.(list))
    return parse(Int, s)
end

signal_list, digits_list = read_input("8_input.txt")

output = []
for (signal, digits) in zip(signal_list, digits_list) 
    dec = get_decoder(signal)
    d = [decode(dec, digit) for digit in split(digits)]
    push!(output, d)
end

output_int = list_to_int.(output)
out = sum(output_int)
