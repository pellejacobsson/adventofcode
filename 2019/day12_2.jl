mutable struct Moon{T}
    x::T
    y::T
    z::T
    vx::T
    vy::T
    vz::T
end
Moon(x, y, z) = Moon(x, y, z, 0, 0, 0)


function read_input(filename)
	input = open(filename) do f
        readlines(f)
	end
    re = r"<x=([-,0-9]*),.*y=([-,0-9]*),.*z=([-,0-9]*)>"
    moons = Moon[]
    for l in input
        m = match(re, l)
        x, y, z = parse.(Int, m.captures)
        push!(moons, Moon(x, y, z))
    end
    return moons
end

function apply_gravity!(moon1::Moon, moon2::Moon)
    if moon1.x < moon2.x
        moon1.vx += 1
        moon2.vx -= 1
    elseif moon1.x > moon2.x
        moon1.vx -= 1
        moon2.vx += 1
    end
    if moon1.y < moon2.y
        moon1.vy += 1
        moon2.vy -= 1
    elseif moon1.y > moon2.y
        moon1.vy -= 1
        moon2.vy += 1
    end
    if moon1.z < moon2.z
        moon1.vz += 1
        moon2.vz -= 1
    elseif moon1.z > moon2.z
        moon1.vz -= 1
        moon2.vz += 1
    end
end

function apply_gravity!(moons::Vector{Moon})
    n_moons = length(moons)
    for i = 1:n_moons
        for j = (i+1):n_moons
            apply_gravity!(moons[i], moons[j])
        end
    end
end

function apply_velocity!(moon::Moon)
    moon.x += moon.vx
    moon.y += moon.vy
    moon.z += moon.vz
end

function apply_velocity!(moons::Vector{Moon})
    for moon in moons
        apply_velocity!(moon)
    end
end

function update_moons!(moons::Vector{Moon})
    apply_gravity!(moons)
    apply_velocity!(moons)
end

function coord_equal(moons, moons_orig, coord)
    if coord == 1
        return [moon.x for moon in moons] == [moon.x for moon in moons_orig]
    elseif coord == 2
        return [moon.y for moon in moons] == [moon.y for moon in moons_orig]
    elseif coord == 3
        return [moon.y for moon in moons] == [moon.y for moon in moons_orig]
    else
        error("Wrong coordinate number")
    end
end


moons_orig = read_input("12_input.txt")
moons_x = deepcopy(moons_orig)
moons_y = deepcopy(moons_orig)
moons_z = deepcopy(moons_orig)

x_states = Dict(vcat([moon.x for moon in moons_x], [moon.vx for moon in moons_x]) => 0)
i = 0
x0 = 0
xp = 0
for _ = 1:1000000
    i += 1
    update_moons!(moons_x)
    new_state = vcat([moon.x for moon in moons_x], [moon.vx for moon in moons_x])
    if haskey(x_states, new_state)
        x0 = x_states[new_state]
        xp = i - x0
        break
    else
        x_states[new_state] = i
    end
end

y_states = Dict(vcat([moon.y for moon in moons_y], [moon.vy for moon in moons_y]) => 0)
i = 0
y0 = 0
yp = 0
for _ = 1:1000000
    i += 1
    update_moons!(moons_y)
    new_state = vcat([moon.y for moon in moons_y], [moon.vy for moon in moons_y])
    if haskey(y_states, new_state)
        y0 = y_states[new_state]
        yp = i - y0
        break
    else
        y_states[new_state] = i
    end
end

z_states = Dict(vcat([moon.z for moon in moons_z], [moon.vz for moon in moons_z]) => 0)
i = 0
z0 = 0
zp = 0
for _ = 1:1000000
    i += 1
    update_moons!(moons_z)
    new_state = vcat([moon.z for moon in moons_z], [moon.vz for moon in moons_z])
    if haskey(z_states, new_state)
        z0 = z_states[new_state]
        zp = i - z0
        break
    else
        z_states[new_state] = i
    end
end

lcm(xp, yp, zp)