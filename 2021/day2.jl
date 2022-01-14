instructions = open("2_input.txt") do f
    map(x -> (x[1], parse(Int, x[2])), [split(s, " ") for s in readlines(f)])
end

# Part 1
hor = 0
dep = 0
for (d, a) in instructions
    if d == "forward"
        hor += a
    elseif d == "down"
        dep += a
    elseif d == "up"
        dep -= a
    else
        error("Unknown command")
    end
end

hor*dep

# Part 2
hor = 0
dep = 0
aim = 0
for (d, a) in instructions
    if d == "forward"
        hor += a
        dep += aim * a
    elseif d == "down"
        aim += a
    elseif d == "up"
        aim -= a
    else
        error("Unknown command")
    end
end

print(hor*dep)