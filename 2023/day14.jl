function read_input(filename)
    input = open(filename) do f
        [[s for s in line] for line in readlines(f)]
    end
    permutedims(hcat(input...))
end

function move!(rocks, dir='n')
    if dir == 'e'
        rocks = rotl90(rocks)
    elseif dir == 's'
        rocks = rot180(rocks)
    elseif dir == 'w'
        rocks = rotr90(rocks)
    end
    n_rows, n_cols = size(rocks)
    for i = 2:n_rows
        for j = 1:n_cols
            rocks[i, j] != 'O' && continue
            ii = findlast(x -> x in ['O', '#'], rocks[1:i - 1, j])
            ii = something(ii, 0)
            if ii < i - 1
                rocks[ii + 1, j] = 'O'
                rocks[i, j] = '.'
            end
        end
    end
    if dir == 'e'
        rocks = rotr90(rocks)
    elseif dir == 's'
        rocks = rot180(rocks)
    elseif dir == 'w'
        rocks = rotl90(rocks)
    end
    rocks
end

function solve!(rocks)
    n_rows = size(rocks, 1)
    rocks = move!(rocks, 'n')
    sum([sum(rocks[i, :] .== 'O') * (n_rows - i + 1) for i = 1:n_rows])
end

function check!(rocks)
    n_rows = size(rocks, 1)
    loads = []
    for i = 1:1000
        for dir in ['n', 'w', 's', 'e']
            rocks = move!(rocks, dir)
        end
        push!(loads, sum([sum(rocks[i, :] .== 'O') * (n_rows - i + 1) for i = 1:n_rows]))
    end
   plot(loads, m=".")
end

function solve2!(rocks)
    n_rows = size(rocks)[1]
    n_moves = 93 + 1000000000 % 93
    for _ = 1:n_moves
        for dir in ['n', 'w', 's', 'e']
            rocks = move!(rocks, dir)
        end
    end
    sum([sum(rocks[i, :] .== 'O') * (n_rows - i + 1) for i = 1:n_rows])
end

function runit(filename; part2=false)
    rocks = read_input(filename)
    if !part2
        solve!(rocks)
    else
        solve2!(rocks)
    end
end

runit("14_input.txt")
runit("14_input.txt", part2=true)