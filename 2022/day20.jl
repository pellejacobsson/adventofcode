function read_input(filename)
    open(filename) do f
        parse.(Int, readlines(f))
    end
end

function runit(filename; part2=false)
    code = read_input(filename)
    p = 1
    if part2
        code *= 811589153
        p = 10
    end
    n = length(code)
    ix = collect(1:n + 1)
    for _ = 1:p
        for i = 1:n
            j = findfirst(x -> x == i, ix)
            c = code[j]
            k = mod((j + c) - 1, n) + 1
            #if k > n
            #    k = mod(k, n)
            #end
            insert!(code, k, popat!(code, j))
            insert!(ix, k, popat!(ix, j))
        end
    end
    code
end

runit("20_testinput.txt")