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

function apply_velocity!(moon::Vector{Moon})
    for moon in moons
        apply_velocity!(moon)
    end
end

function update_moons!(moons, n)
    for _ = 1:n
        apply_gravity!(moons)
        apply_velocity!(moons)
    end
end

function energy(moon::Moon)
    pot = abs(moon.x) + abs(moon.y) + abs(moon.z)
    kin = abs(moon.vx) + abs(moon.vy) + abs(moon.vz)
    return pot * kin
end

function energy(moons::Vector{Moon})
    return sum([energy(moon) for moon in moons])
end


moons = read_input("12_input.txt")
update_moons!(moons, 1000)
e = energy(moons)