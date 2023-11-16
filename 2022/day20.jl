function read_input(filename)
    open(filename) do f
        parse.(Int, readlines(f))
    end
end

function runit(filename; part2=false)
    code = read_input(filename)
    p = 1
    if part2
        code .*= 811589153
        p = 10
    end
    n = length(code)
    ix = collect(1:n)
    for _ = 1:p
        for i = 1:n
            j = findfirst(x -> x == i, ix)
            c = code[j]
            k = c + j
            k = mod1(k, n - 1)
            insert!(code, k, popat!(code, j))
            insert!(ix, k, popat!(ix, j))
        end
    end
    j = findfirst(x -> x == 0, code)
    sum(code[mod.(j .+ [1000, 2000, 3000], (n,))])
    #code
end

runit("20_input.txt") 
runit("20_input.txt", part2=true)