### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 443124b0-4d17-11eb-2e50-857191e4ae0b
function initcode()
	input = open("5_input.txt") do f
		[parse(Int, s) for s in split(readlines(f)[1], ",")]
	end
	return input
end

# ╔═╡ 282b2b7e-4d12-11eb-2506-3316dce68cbc
function runcode!(input, inputval)
	i = 1
	output = []
	instruction_output = []
	while input[i] ≠ 99
		opcode = input[i]
		opcode_list = [parse(Int, x) for x in string(opcode)]
		lop = length(opcode_list)
		if opcode == 3
			input[input[i + 1] + 1] = inputval
			i += 2
		else
			if lop == 1
				b, c, e = 0, 0, opcode
			elseif lop == 3
				b, c, e = 0, opcode_list[end-2], opcode_list[end]
			elseif lop == 4
				b, c, e = opcode_list[end-3], opcode_list[end-2], opcode_list[end]
			end
			if e == 4
				output_val = c == 1 ? input[i+1] : input[input[i+1] + 1]
				push!(output, output_val)
				push!(instruction_output, i)
				i += 2
			elseif e == 5
				op1 = c == 1 ? input[i+1] : input[input[i+1] + 1]
				op2 = b == 1 ? input[i+2] : input[input[i+2] + 1]
				if op1 != 0
					i = op2 + 1
				else
					i += 3
				end
			elseif e == 6
				op1 = c == 1 ? input[i+1] : input[input[i+1] + 1]
				op2 = b == 1 ? input[i+2] : input[input[i+2] + 1]
				if op1 == 0
					i = op2 + 1
				else
					i += 3
				end
			elseif e == 7
				save_pos = input[i+3] + 1
				op1 = c == 1 ? input[i+1] : input[input[i+1] + 1]
				op2 = b == 1 ? input[i+2] : input[input[i+2] + 1]
				input[save_pos] = op1 < op2 ? 1 : 0
				i += 4
			elseif e == 8
				save_pos = input[i+3] + 1
				op1 = c == 1 ? input[i+1] : input[input[i+1] + 1]
				op2 = b == 1 ? input[i+2] : input[input[i+2] + 1]
				input[save_pos] = op1 == op2 ? 1 : 0
				i += 4
			else
				save_pos = input[i+3] + 1
				op1 = c == 1 ? input[i+1] : input[input[i+1] + 1]
				op2 = b == 1 ? input[i+2] : input[input[i+2] + 1]
				op = e == 1 ? (+) : (*)
				input[save_pos] = op(op1, op2)
				i += 4
			end
		end	
	end
	return output, instruction_output
end

# ╔═╡ 41ea3950-5035-11eb-33e7-0b743cc26ed2
begin
	orig_code = initcode()
	code = deepcopy(orig_code)
end

# ╔═╡ 21681ff0-5277-11eb-00c0-e3278c2b092c
out, iout = runcode!(code, 5)

# ╔═╡ 5070a760-527a-11eb-1fab-b9267fbf8e75
out

# ╔═╡ b92d4960-527b-11eb-26c0-ebd22743841c
iout

# ╔═╡ Cell order:
# ╠═443124b0-4d17-11eb-2e50-857191e4ae0b
# ╠═282b2b7e-4d12-11eb-2506-3316dce68cbc
# ╠═41ea3950-5035-11eb-33e7-0b743cc26ed2
# ╠═21681ff0-5277-11eb-00c0-e3278c2b092c
# ╠═5070a760-527a-11eb-1fab-b9267fbf8e75
# ╠═b92d4960-527b-11eb-26c0-ebd22743841c
