function read_input(filename)
    input = open(filename) do f
        readlines(f)
    end
    image = zeros(Int64, length(input), length(input[1]))
    for (i, line) in enumerate(input)
        image[i, :] = [s == '#' ? 1 : 0 for s in line]
    end
    image
end

function calc_dist(g1, g2, row0, col0, part)
    d = abs(g1[1] - g2[1]) + abs(g1[2] - g2[2])
    n_rows = sum(min(g1[1], g2[1]) .< row0 .< max(g1[1], g2[1]))
    n_cols = sum(min(g1[2], g2[2]) .< col0 .< max(g1[2], g2[2]))
    factor = part == 1 ? 1 : 999999
    d + (n_rows + n_cols) * factor
end

function solve(image, part)
    row0 = findall(==(0), vec(sum(image, dims=2)))
    col0 = findall(==(0), vec(sum(image, dims=1)))
    galaxies = findall(==(1), image)
    g_dist = Dict{Tuple{CartesianIndex{2}, CartesianIndex{2}}, Int64}()
    for g1 in galaxies, g2 in galaxies
        (g1 == g2 || (g1, g2) in keys(g_dist) || (g2, g1) in keys(g_dist)) && continue
        g_dist[g1, g2] = calc_dist(g1, g2, row0, col0, part)
    end
    sum(values(g_dist))
end

function runit(filename; part=1)
    image = read_input(filename)
    solve(image, part)
end

runit("11_input.txt")
runit("11_input.txt", part=2)