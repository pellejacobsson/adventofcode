using OffsetArrays

function read_input(filename)
    lines = open(filename) do f
        readlines(f)
    end
    re = r"^(on|off) x=(-?[0-9]*)..(-?[0-9]*),y=(-?[0-9]*)..(-?[0-9]*),z=(-?[0-9]*)..(-?[0-9]*)$"
    instructions = []
    for line in lines
        m = match(re, line)
        state = m.captures[1] == "on" ? 1 : 0
        x0 = parse(Int, m.captures[2])
        x1 = parse(Int, m.captures[3])
        y0 = parse(Int, m.captures[4])
        y1 = parse(Int, m.captures[5])
        z0 = parse(Int, m.captures[6])
        z1 = parse(Int, m.captures[7])
        push!(instructions, [state, x0, x1, y0, y1, z0, z1])
    end
    return instructions
end

# Part 1
function part1(filename)
    instructions = read_input(filename)
    cubes = OffsetArray(zeros(Int, (101, 101, 101)), (-50:50, -50:50, -50:50))
    for instruction in instructions
        on = instruction[1]
        xs = instruction[2]:instruction[3]
        ys = instruction[4]:instruction[5]
        zs = instruction[6]:instruction[7]
        xs = max(xs[1], -50):min(xs[end], 50)
        ys = max(ys[1], -50):min(ys[end], 50)
        zs = max(zs[1], -50):min(zs[end], 50)
        if on == 1
            cubes[xs, ys, zs] .= 1
        else
            cubes[xs, ys, zs] .= 0
        end
    end
    return cubes
end

cubes = part1("22_testinput1.txt")