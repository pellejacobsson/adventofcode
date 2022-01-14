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

orig_code = initcode("9_input.txt")
code = vcat(orig_code, zeros(Int, 1000))
convert.(BigInt, code)
test_code = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
test_code2 = [104,1125899906842624,99]
test_code3 = [1102,34915192,34915192,7,4,7,99,0]
runcode!(code, 2, 1)
