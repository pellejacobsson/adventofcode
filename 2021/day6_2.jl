fish = open("6_input.txt") do f
    [parse(Int, s) for s in split(readline(f), ",")]
end

#fish = [3, 4, 3, 1, 2]

function n_fish(day_0, day, mem)
    if day_0 > day
        return 0
    else
        if haskey(mem, day_0)
            return mem[day_0]
        else
            temp = (day - day_0 - 2) ÷ 7 + sum([n_fish(d, day, mem) for d = day_0 .+ 9 .+ 0:7:day])
            mem[day_0] = temp
            return temp
        end
    end
end

function calc_fish(fish, days)
    n_fish_0 = length(fish)
    mem = Dict{Int64, Int64}()
    return Int(sum([n_fish(day_0, days, mem) for day_0 = fish .- 8])) + n_fish_0
end

out = calc_fish(fish, 256)