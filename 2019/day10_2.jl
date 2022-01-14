function read_input(filename)
    input = open(filename, "r") do f
        readlines(f)
    end
    nrows = length(input)
    ncols = length(input[1])
    return [input[i][j] .== '#' for i = 1:nrows, j = 1:ncols]
end

function calc_angles(i, j, m)
    a = zeros(size(m))
    for k in 1:size(a, 1), l in 1:size(a, 2)
        θ = atan((l - j), (i - k))
        a[k, l] = θ < 0 ? θ + 2π : θ
    end
    return a
end

m = read_input("10_input.txt")
pos0 = (23, 18)
m[pos0...] = false
a = calc_angles(pos0[1], pos0[2], m)
aa = a[m]
aai = [(i, j) for i = 1:size(m, 1), j = 1:size(m, 2)][m]
d = [sqrt((i - pos0[1])^2 + (j - pos0[2])^2) for i = 1:size(m, 1), j = 1:size(m, 2)][m]
ac = [count(aa .== x) for x in aa]

for θ in sort(unique(aa))
    #idx = findall(x -> x .== θ, aa)
    idx = findall(x -> abs.(x .- θ) .≤ 1e-5, aa)
    if length(idx) > 1
        cidx = idx[sortperm(d[idx])]
        aa[cidx] .+= (0:length(idx)-1) * 2π
    end
end

aai = aai[sortperm(aa)]

output = []
for c in aai
    push!(output, (c[2] - 1, c[1] - 1))
end

