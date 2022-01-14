using OffsetArrays
using Colors

function initcode(filename)
	input = open(filename) do f
		[parse(Int, s) for s in split(read(f, String), ",")]
	end
	return input
end

function intcode!(instruction, input, i_start, rel_start)
	i = i_start
	rel = rel_start
	while instruction[i] != 99
		opcode = instruction[i]
		opcode_list = [parse(Int, x) for x in string(opcode)]
		opcode_list = vcat(zeros(Int, 5 - length(opcode_list)), opcode_list)
		a, b, c, d, e = (opcode_list...,)
		if e == 1 || e == 2
			if c == 0
				p1 = instruction[instruction[i+1]]
			elseif c == 1
				p1 = instruction[i+1]
			elseif c == 2
				p1 = instruction[instruction[i+1] + rel]
			else
				error("Parameter error")
			end
			if b == 0
				p2 = instruction[instruction[i+2]]
			elseif b == 1
				p2 = instruction[i+2]
			elseif b == 2
				p2 = instruction[instruction[i+2] + rel]
			else
				error("Parameter error")
			end
			if a == 0
				p3 = instruction[i+3]
			elseif a == 2
				p3 = instruction[i+3] + rel
			else
				error("Parameter error")
			end
			instruction[p3] = e == 1 ? p1 + p2 : p1 * p2
			i += 4
		elseif e == 3
			if c == 0
				p1 = instruction[i+1]
			elseif c == 2
				p1 = instruction[i+1] + rel
			else
				error("Parameter error")
			end
			instruction[p1] = input
			i += 2
		elseif e == 4
			if c == 0
				p1 = instruction[instruction[i+1]]
			elseif c == 1
				p1 = instruction[i+1]
			elseif c == 2
				p1 = instruction[instruction[i+1] + rel]
			else
				error("Parameter error")
			end
			i += 2
			return i, p1, rel
		elseif e == 5 || e == 6
			if c == 0
				p1 = instruction[instruction[i+1]]
			elseif c == 1
				p1 = instruction[i+1]
			elseif c == 2
				p1 = instruction[instruction[i+1] + rel]
			else
				error("Parameter error")
			end
			if b == 0
				p2 = instruction[instruction[i+2]]
			elseif b == 1
				p2 = instruction[i+2]
			elseif b == 2
				p2 = instruction[instruction[i+2] + rel]
			else
				error("Parameter error")
			end
			if e == 5 && p1 != 0
				i = p2
			elseif e == 6 && p1 == 0
				i = p2
			else
				i += 3
			end
		elseif e == 7 || e == 8
			if c == 0
				p1 = instruction[instruction[i+1]]
			elseif c == 1
				p1 = instruction[i+1]
			elseif c == 2
				p1 = instruction[instruction[i+1] + rel]
			else
				error("Parameter error")
			end
			if b == 0
				p2 = instruction[instruction[i+2]]
			elseif b == 1
				p2 = instruction[i+2]
			elseif b == 2
				p2 = instruction[instruction[i+2] + rel]
			else
				error("Parameter error")
			end
			if a == 0
				p3 = instruction[i+3]
			elseif a == 2
				p3 = instruction[i+3] + rel
			else
				error("Parameter error")
			end
			if e == 7
				instruction[p3] = p1 < p2 ? 1 : 0
			else
				instruction[p3] = p1 == p2 ? 1 : 0
			end
			i += 4
		elseif e == 9
			if c == 0
				p1 = instruction[instruction[i+1]]
			elseif c == 1
				p1 = instruction[i+1]
			elseif c == 2
				p1 = instruction[instruction[i+1] + rel]
			else
				error("Parameter error")
			end
			rel += p1
			i += 2
		else
			error("Opcode error")
		end
	end
	return i, nothing, rel
end


function get_new_coords(p, dir)
    x = p[1]
    y = p[2]
    if dir == 1
        y += 1
    elseif dir == 2
        y -= 1
    elseif dir == 3
        x -= 1
    elseif dir == 4
        x += 1
    else
        error("$dir is not a valid direction")
    end
    return x, y
end

function get_adjacent(p)
    x = p[1]
    y = p[2]
    return [(x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]
end

function get_opposite_dir(dir)
    if dir == 1
        return 2
    elseif dir == 2
        return 1
    elseif dir == 3
        return 4
    elseif dir == 4
        return 3
    else
        error("Wrong direction $dir")
    end
end

function step!(code, droid_map, dir_prev, p_prev, i, rel)
    for dir = 1:4
        p = get_new_coords(p_prev, dir)
        if p ∉ keys(droid_map)
            i, output, rel = intcode!(code, dir, i, rel)
            if output ∈ [1, 2]
                droid_map[p] = output
                i, _, rel = step!(code, droid_map, dir, p, i, rel)
            elseif output == 0
                droid_map[p] = 0
            else
                error("Wrong output: $output")
            end
        end
    end
    opposite_dir = get_opposite_dir(dir_prev)
    i, output, rel = intcode!(code, opposite_dir, i, rel)
    return i, output, rel
end

function make_map(input_filename)
    orig_code = initcode(input_filename)
    code = vcat(orig_code, zeros(Int, 1000))
    code = OffsetArray(code, 0:length(code)-1)
    droid_map = Dict((0, 0) => 1)
    step!(code, droid_map, 1, (0, 0), 0, 0)
    return droid_map
end

function findxyminmax(droid_map)
    x_min = 0
    y_min = 0
    x_max = 0
    y_max = 0
    for (x, y) in keys(droid_map)
        x_min = x < x_min ? x : x_min
        x_max = x > x_max ? x : x_max
        y_min = y < y_min ? y : y_min
        y_max = y > y_max ? y : y_max
    end
    return x_min, x_max, y_min, y_max
end

function make_matrix(droid_map)
    x_min, x_max, y_min, y_max = findxyminmax(droid_map)
    a = fill(0, x_max - x_min + 1, y_max - y_min + 1)
    a = OffsetArray(a, x_min:x_max, y_min:y_max)
    for (key, val) in droid_map
        a[key[1], key[2]] = val
    end
    a[0, 0] = 3
    return a
end

droid_map = make_map("15_input.txt")
m = make_matrix(droid_map)

Gray.(m/3)

function bfs(droid_map, p_start, p_goal)
    queue = [p_start]
    explored = [p_start]
    d = Dict(p_start => 0)
    while length(queue) > 0
        v = popfirst!(queue)
        if v == p_goal
            return d
        else
            for w in get_adjacent(v)
                if droid_map[w] != 0 && w ∉ explored
                    push!(explored, w)
                    push!(queue, w)
                    d[w] = d[v] + 1
                end
            end
        end
    end
end

function tank_coord(droid_map)
    for (key, val) in droid_map
        if val == 2
            return key
        end
    end
end

start = (0, 0)
goal = tank_coord(droid_map)

d = bfs(droid_map, start, goal)

d[goal]

# Part 2
function p2(goal, droid_map)
	filled = []
	filled_new = [goal]
	filled_newnew = []
	minutes = 0
	spread = true
	while spread
		minutes += 1
		spread = false
		for p in filled_new
			for q in get_adjacent(p)
				if get(droid_map, q, 0) == 1 && q ∉ filled
					spread = true
					push!(filled_newnew, q)
				end
			end
		end
		filled = vcat(filled, filled_new)
		filled_new = filled_newnew
		filled_newnew = []
	end
	return minutes - 1
end

p2(goal, droid_map)