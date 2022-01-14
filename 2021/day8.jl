function read_input(filename)
    lines = open(filename) do f
        readlines(f)
    end
    signal_list = []
    digits_list = []
    for line in lines
        s, d = split(line, " | ")
        push!(signal_list, s)
        push!(digits_list, d)
    end
    return signal_list, digits_list
end

signal_list, digits_list = read_input("8_input.txt")

s = Dict(2 => 0, 3 => 0, 4 => 0, 7 => 0)
for digits in digits_list
    n_digits = length.(split(digits))
    for n_digit in n_digits
        if n_digit ∈ [2, 3, 4, 7]
            s[n_digit] += 1
        end
    end
end