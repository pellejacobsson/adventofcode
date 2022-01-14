### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 8ad65d80-59b1-11eb-0571-51bdbbd4053f
using Combinatorics

# ╔═╡ f7c33a62-5d91-11eb-0185-8f03c6c9277d
using PlutoUI

# ╔═╡ 443124b0-4d17-11eb-2e50-857191e4ae0b
function initcode(filename)
	input = open(filename) do f
		[parse(Int, s) for s in split(readlines(f)[1], ",")]
	end
	return input
end

# ╔═╡ 282b2b7e-4d12-11eb-2506-3316dce68cbc
function runcode!(input, inputval, istart)
	i = istart
	inputval = [inputval]
	while input[i] ≠ 99
		opcode = input[i]
		opcode_list = [parse(Int, x) for x in string(opcode)]
		lop = length(opcode_list)
		if opcode == 3
			if length(inputval) == 0
				return i, "I", nothing
			else
				input[input[i + 1] + 1] = pop!(inputval)
				i += 2
			end
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
				i += 2
				return i, "O", output_val
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
	return i, "S", nothing
end

# ╔═╡ 41ea3950-5035-11eb-33e7-0b743cc26ed2
orig_code = initcode("7_input.txt")

# ╔═╡ 9d65b030-59b2-11eb-1e59-4bf5e7fbfaf4
function runallamps(orig_code, phase_list)
	codes = [copy(orig_code) for _ in 1:5]
	istart = ones(Int, 5)
	for j = 1:5
		i, _res, _out = runcode!(codes[j], phase_list[j], istart[j])
		istart[j] = i
	end
	out = 0
	prevout = fill(0, 5)
	stop = false
	while !stop
		for j = 1:5
			i, res, out = runcode!(codes[j], out, istart[j])
			if j == 5 && res == "S"
				stop = true
				break
			end
			if res == "O"
				prevout[j] = out
			else
				out = prevout[j]
			end
			istart[j] = i
		end
	end
	return prevout[end]
end

# ╔═╡ aec756d2-5d6d-11eb-3a62-71a6e1e8fcf0
runallamps(orig_code, [9,7,8,5,6])

# ╔═╡ e6dc3920-5d93-11eb-177c-876abd78a119
function maxthruster(orig_code)
	maxval = 0
	for phase_list in permutations(5:9)
		val = runallamps(orig_code, phase_list)
		if val > maxval
			maxval = val
		end
	end
	return maxval
end

# ╔═╡ 00d03480-5d94-11eb-0b7d-cf5b87c586fe
maxthruster(orig_code)

# ╔═╡ 92c6cc20-5d79-11eb-3fcc-8d660061b425


# ╔═╡ Cell order:
# ╠═443124b0-4d17-11eb-2e50-857191e4ae0b
# ╠═282b2b7e-4d12-11eb-2506-3316dce68cbc
# ╠═41ea3950-5035-11eb-33e7-0b743cc26ed2
# ╠═8ad65d80-59b1-11eb-0571-51bdbbd4053f
# ╠═f7c33a62-5d91-11eb-0185-8f03c6c9277d
# ╠═9d65b030-59b2-11eb-1e59-4bf5e7fbfaf4
# ╠═aec756d2-5d6d-11eb-3a62-71a6e1e8fcf0
# ╠═e6dc3920-5d93-11eb-177c-876abd78a119
# ╠═00d03480-5d94-11eb-0b7d-cf5b87c586fe
# ╟─92c6cc20-5d79-11eb-3fcc-8d660061b425
