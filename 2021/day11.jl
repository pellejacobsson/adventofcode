function read_input(filename)
    lines = open(filename) do f
        readlines(f)
    end
    m = zeros(Int, length(lines), length(lines[1]))
    for (i, line) in enumerate(lines)
        m[i, :] = [parse(Int, s) for s in line]
    end
    return m
end

function apply_mask!(idx, i, j)
    i_range = max(1, i - 1):min(10, i + 1)
    j_range = max(1, j - 1):min(10, j + 1)
    idx .= false
    idx[i_range, j_range] .= true
    idx[i, j] = false
    return nothing
end


function step!(m, idx, flashed)
    flashed .= false
    m .+= 1
    keep_going = true
    n_flashes = 0
    while keep_going
        keep_going = false
        for i in 1:size(m, 1), j in 1:size(m, 2)
            if m[i, j] > 9 && !flashed[i, j]
                apply_mask!(idx, i, j)
                m[idx] .+= 1
                flashed[i, j] = true
                keep_going = true
                n_flashes += 1
            end
        end
    end
    flashed_idx = m .> 9
    m[flashed_idx] .= 0
    all_flashed = false
    if sum(flashed_idx) == 100
        all_flashed = true
    end
    return all_flashed, n_flashes
end

function run_it!(m, n_times)
    flashed = falses(size(m))
    idx = falses(size(m))
    n_flashes = 0
    for n = 1:n_times
        all_flashed, new_flashes = step!(m, idx, flashed)
        n_flashes += new_flashes
        if all_flashed
            println("All flashed")
            return n
        end
    end
    return n_flashes
end

m1 = read_input("11_testinput_step1.txt")
m2 = read_input("11_testinput_step2.txt")
m3 = read_input("11_testinput_step3.txt")
m100 = read_input("11_testinput_step100.txt")
m = read_input("11_input.txt")
out = run_it!(m, 1000)