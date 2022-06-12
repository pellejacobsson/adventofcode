struct Cube
    on::Bool
    r::Vector{Int}
end

function read_input(filename)
    lines = open(filename) do f
        readlines(f)
    end
    re = r"^(on|off) x=(-?[0-9]*)..(-?[0-9]*),y=(-?[0-9]*)..(-?[0-9]*),z=(-?[0-9]*)..(-?[0-9]*)$"
    instructions = Cube[]
    for line in lines
        m = match(re, line)
        state = m.captures[1] == "on" ? 1 : 0
        x0 = parse(Int, m.captures[2])
        x1 = parse(Int, m.captures[3])
        y0 = parse(Int, m.captures[4])
        y1 = parse(Int, m.captures[5])
        z0 = parse(Int, m.captures[6])
        z1 = parse(Int, m.captures[7])
        push!(instructions, Cube(state, [x0, x1, y0, y1, z0, z1]))
    end
    return instructions
end

function intersection(c1, c2)
    x11, x12, y11, y12, z11, z12 = c1.r
    x21, x22, y21, y22, z21, z22 = c2.r
    state = !c2.on
    x1 = max(x11, x21)
    x2 = min(x12, x22)
    x1 > x2 && return false, nothing
    y1 = max(y11, y21)
    y2 = min(y12, y22)
    y1 > y2 && return false, nothing
    z1 = max(z11, z21)
    z2 = min(z12, z22)
    z1 > z2 && return false, nothing
    return true, Cube(state, [x1, x2, y1, y2, z1, z2])
end

function n_cuboids(cube)
    x1, x2, y1, y2, z1, z2 = cube.r
    factor = cube.on ? 1 : -1
    return factor * (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)
end

function runit(filename)
    instructions = read_input(filename)
    clist = Cube[]
    push!(clist, instructions[1])
    for instruction in instructions[2:end]
        addlist = Cube[]
        for c in clist
            does_intersect, ic = intersection(instruction, c)
            if does_intersect
                push!(addlist, ic)
            end
        end
        clist = vcat(clist, addlist)
        if instruction.on
            push!(clist, instruction)
        end
    end
    return sum(n_cuboids.(clist))
end


out = runit("22_input.txt")