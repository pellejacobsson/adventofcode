function get_input(filename)
    n = open(filename) do f
        readline(f)
    end
    return [parse(Int, s) for s in n]
end

function calc_phase(input)
    base = [0, 1, 0, -1]
    output = zeros(Int, length(input))
    nl = length(input)
    for i in 1:nl
        inner_rep = i
        outer_rep = Int(ceil((nl + 1) / (i * 4)))
        mask = repeat(base, inner = inner_rep)
        mask = repeat(mask, outer = outer_rep)
        mask = mask[2:nl + 1]
        d = abs(sum([x % 10 for x in input .* mask])) % 10
        output[i] = d
    end
    return output
end

function calc_nphases!(input, n_phases)
    for n = 1:n_phases
        input = calc_phase(input)
    end
    return input
end

input = get_input("16_input.txt")
output = calc_nphases!(input, 100)
answer = join([string(s) for s in output[1:8]])

# Part 2

function get_last(n)
    l = [parse(Int, s) for s in string(n)]
    return l[end]
end

input = get_input("16_input.txt")
input = repeat(input, 10000)
i_start = parse(Int, join([string(s) for s in input[1:7]])) + 1
input = input[i_start:end]
l_input = length(input)

a = ones(BigInt, l_input)
for n = 1:99
    a = cumsum(a)
end
A = zeros(BigInt, 8, l_input)
for n = 1:8
    A[n, n:end] = a[1:(end-n+1)]
end

output = A * input
answer = [[parse(Int, s) for s in string(output[n])][end] for n = 1:8]
answer = join([string(n) for n in answer])
