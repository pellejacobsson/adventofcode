function read_input(filename)
    inputs = open(filename) do f
        split.(split(read(f, String), "\n\n"))
    end
    matrices = []
    for input in inputs
        m = [[s == '#' ? 1 : 0 for s in line] for line in input]
        push!(matrices, BitArray(permutedims(hcat(m...))))
    end
    matrices
end
