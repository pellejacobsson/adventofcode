using OffsetArrays
using Images

function initcode(filename)
	input = open(filename) do f
		[parse(Int, s) for s in split(readlines(f)[1], ",")]
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


function paint(filename, x, y, d, pos, start_color)
	orig_code = initcode(filename)
	code = vcat(orig_code, zeros(Int, 1000))
	code = convert.(BigInt, code)
	code = OffsetArray(code, 0:length(code)-1)
	v = Dict((0, 0) => start_color)
	rel_start = 0
	while true
		old_color = get(v, (x, y), 0)
		pos, new_color, rel_start = intcode!(code, old_color, pos, rel_start)
		if new_color === nothing
			break
		end
		pos, direction, rel_start = intcode!(code, old_color, pos, rel_start)
		if d == "up"
			d = direction == 0 ? "left" : "right"
		elseif d == "right"
			d = direction == 0 ? "up" : "down"
		elseif d == "down"
			d = direction == 0 ? "right" : "left"
		else
			d = direction == 0 ? "down" : "up"
		end
		v[(x, y)] = new_color
		if d == "up"
			y += 1
		elseif d == "right"
			x += 1
		elseif d == "down"
			y -= 1
		elseif d == "left"
			x -= 1
		end
	end
	return v
end

v = paint("11_input.txt", 0, 0, "up", 0, 1)
xmin, xmax = extrema([k[1] for k in keys(v)])
ymin, ymax = extrema([k[2] for k in keys(v)])
message = zeros(Int, ymax - ymin + 1, xmax - xmin + 1)
message = OffsetArray(message, ymin:ymax, xmin:xmax)
for i = ymin:ymax, j = xmin:xmax
	message[i, j] = get(v, (j, i), 0)
end
Gray.(reverse(message, dims = 1))