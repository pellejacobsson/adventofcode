function initcode(filename)
	input = open(filename) do f
		[parse(Int, s) for s in split(readlines(f)[1], ",")]
	end
	return input
end

function runcode!(input, inputval, istart)
	i = istart
	rel = 0
	inputval = [inputval]
	while input[i] ≠ 99
		opcode = input[i]
		opcode_list = [parse(Int, x) for x in string(opcode)]
		lop = length(opcode_list)
		if lop == 1
			a, b, c, e = 0, 0, 0, opcode
		elseif lop == 3
			a, b, c, e = 0, 0, opcode_list[end-2], opcode_list[end]
		elseif lop == 4
			a, b, c, e = 0, opcode_list[end-3], opcode_list[end-2], opcode_list[end]
		elseif lop == 5
			a, b, c, e = opcode_list[end-4], opcode_list[end-3], opcode_list[end-2], opcode_list[end]
		end
		if e == 3
			if length(inputval) == 0
				return i, "I", nothing
			else
				save_pos = input[i + 1] + 1
				if c == 2
					save_pos += rel
				end
				input[save_pos] = pop!(inputval)
				i += 2
			end
		elseif e == 4
			if c == 0
				output_val = input[input[i+1] + 1]
			elseif c == 1
				output_val = input[i+1]
			else
				output_val = input[input[i+1] + 1 + rel]
			end
			i += 2
			return i, "0", output_val
		elseif e == 5
			if c == 0
				op1 = input[input[i+1] + 1]
			elseif c == 1
				op1 = input[i+1]
			else
				op1 = input[input[i+1] + 1 + rel]
			end
			if b == 0
				op2 = input[input[i+2] + 1]
			elseif b == 1
				op2 = input[i+2]
			else
				op2 = input[input[i+2] + 1 + rel]
			end
			if op1 != 0
				i = op2 + 1
			else
				i += 3
			end
		elseif e == 6
			if c == 0
				op1 = input[input[i+1] + 1]
			elseif c == 1
				op1 = input[i+1]
			else
				op1 = input[input[i+1] + 1 + rel]
			end
			if b == 0
				op2 = input[input[i+2] + 1]
			elseif b == 1
				op2 = input[i+2]
			else
				op2 = input[input[i+2] + 1 + rel]
			end
			if op1 == 0
				i = op2 + 1
			else
				i += 3
			end
		elseif e == 7
			save_pos = input[i+3] + 1
			if a == 2
				save_pos += rel
			end
			if c == 0
				op1 = input[input[i+1] + 1]
			elseif c == 1
				op1 = input[i+1]
			else
				op1 = input[input[i+1] + 1 + rel]
			end
			if b == 0
				op2 = input[input[i+2] + 1]
			elseif b == 1
				op2 = input[i+2]
			else
				op2 = input[input[i+2] + 1 + rel]
			end
			input[save_pos] = op1 < op2 ? 1 : 0
			i += 4
		elseif e == 8
			save_pos = input[i+3] + 1
			if a == 2
				save_pos += rel
			end
			if c == 0
				op1 = input[input[i+1] + 1]
			elseif c == 1
				op1 = input[i+1]
			else
				op1 = input[input[i+1] + 1 + rel]
			end
			if b == 0
				op2 = input[input[i+2] + 1]
			elseif b == 1
				op2 = input[i+2]
			else
				op2 = input[input[i+2] + 1 + rel]
			end
			input[save_pos] = op1 == op2 ? 1 : 0
			i += 4
		elseif e == 9
			if c == 0
				val = input[input[i+1] + 1]
			elseif c == 1
				val = input[i+1]
			else
				val = input[input[i+1] + 1 + rel]
			end
			rel += val
			i += 2
		else
			save_pos = input[i+3] + 1
			if a == 2
				save_pos += rel
			end
			if c == 0
				op1 = input[input[i+1] + 1]
			elseif c == 1
				op1 = input[i+1]
			else
				op1 = input[input[i+1] + 1 + rel]
			end
			if b == 0
				op2 = input[input[i+2] + 1]
			elseif b == 1
				op2 = input[i+2]
			else
				op2 = input[input[i+2] + 1 + rel]
			end
			op = e == 1 ? (+) : (*)
			input[save_pos] = op(op1, op2)
			i += 4
		end	
	end
	return i, "S", nothing
end

orig_code = initcode("11_input.txt")
#code = copy(orig_code)
code = vcat(orig_code, zeros(Int, 1000))
v = Dict((0, 0) => 0)
global x = 0
global y = 0
global d = "up"
global pos = 1
for m = 1:10000
	old_color = get(v, (x, y), 0)
	pos, _, new_color = runcode!(code, old_color, pos)
	if new_color === nothing
		println("Breaking at $m")
		break
	end
	pos, _, direction = runcode!(code, old_color, pos)
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






