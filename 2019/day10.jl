function read_input(filename)
    input = open(filename, "r") do f
        readlines(f)
    end
    nrows = length(input)
    ncols = length(input[1])
    return [input[i][j] .== '#' for i = 1:nrows, j = 1:ncols]
end

function count_seen(m_in, i, j)
    m = copy(m_in)
    nrows = size(m, 1)
    ncols = size(m, 2)
    for k = 1:nrows
        for l = 1:ncols
            if !((k == i) && (l == j)) && m[k, l]
                if k == i
                    if l > j
                        m[k, l + 1:end] .= false
                    elseif l < j
                        m[k, 1:l - 1] .= false
                    end
                elseif l == j
                    if k > i
                        m[k + 1:end, j] .= false
                    elseif k < i
                        m[1:k - 1, j] .= false
                    end
                else
                    di, dj = k - i, l - j
                    di, dj  = di / abs(di), dj / abs(di)
                    c = 1
                    while 1 ≤ k + c * di ≤ nrows && 1 ≤ l + c * dj ≤ ncols
                        if isinteger(l + c * dj)
                            p, q = Int(k + c * di), Int(l + c * dj)
                            m[p, q] = false
                        end
                        c += 1
                    end
                end
            end
        end
    end
    return sum(m) - 1
end

m = read_input("10_input.txt")

mm = zeros(Int, size(m))
for i = 1:size(m, 1)
    for j = 1:size(m, 2)
        if m[i, j]
            mm[i, j] = count_seen(m, i, j)
        end
    end
end