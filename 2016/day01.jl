function read_input(filename)
    open(filename) do f
        [(s[1], parse(Int, s[2:end])) for s in split(readline(f), ", ")]
    end
end

mutable struct Grid
    x
    y
    dir
    part
    visited::Set{Tuple{Int, Int}}
    back
end
Grid() = Grid(0, 0, 'N', 1, Set(), false)

const rot_map = Dict(
    ('R', 'N') => 'E',
    ('R', 'E') => 'S',
    ('R', 'S') => 'W',
    ('R', 'W') => 'N',
    ('L', 'N') => 'W',
    ('L', 'E') => 'N',
    ('L', 'S') => 'E',
    ('L', 'W') => 'S'
)

const dxy = Dict(
    'N' => (0, 1),
    'E' => (1, 0),
    'S' => (0, -1),
    'W' => (-1, 0)
)

function step!(g::Grid, dxy, steps)
    xn, yn = g.x, g.y
    dx, dy = dxy[g.dir]
    for _ in 1:steps
        (xn, yn) = (xn, yn) .+ (dx, dy)
        if g.part == 2 && (xn, yn) in g.visited
            g.back = true
            break
        end
        push!(g.visited, (xn, yn))
    end
    g.x = xn
    g.y = yn
end

function move!(g::Grid, instructions)
    for (rot, steps) in instructions
        g.dir = rot_map[(rot, g.dir)]
        step!(g, dxy, steps)
        if g.part == 2 && g.back
            break
        end
    end
end

function runit(filename; part2=false)
    instructions = read_input(filename)
    g = Grid()
    if part2
        g.part = 2
    end
    move!(g, instructions)
    abs(g.x) + abs(g.y)
end

runit("01_input.txt")

runit("01_input.txt", part2=true)