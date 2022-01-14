### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 443124b0-4d17-11eb-2e50-857191e4ae0b
function initcode(noun, verb)
	input = open("2_input.txt") do f
		[parse(Int, s) for s in split(readlines(f)[1], ",")]
	end
	input[2] = noun
	input[3] = verb
	return input
end

# ╔═╡ 282b2b7e-4d12-11eb-2506-3316dce68cbc
function runcode(input)
	i = 1
	while input[i] ≠ 99
		pos = input[i+3] + 1
		op1 = input[i+1] + 1
		op2 = input[i+2] + 1
		op = input[i] == 1 ? (+) : (*)
		input[pos] = op(input[op1], input[op2])
		i += 4
	end
end

# ╔═╡ 2e14023e-4d14-11eb-2369-b13c4d9f11b8
function initruncode(noun, verb)
	input = initcode(noun, verb)
	runcode(input)
	return input[1]
end

# ╔═╡ c82b9210-4d16-11eb-3b18-0f117b2d11a4
function findnounverb(target)
	for noun in 0:99
		for verb in 0:99
			val = initruncode(noun, verb)
			if val == target
				return noun, verb
			end
		end
	end
end

# ╔═╡ 67013ba0-4d18-11eb-2c3d-bf15e656234a
(noun, verb) = findnounverb(19690720)

# ╔═╡ 76736542-4d18-11eb-0c54-af289cedcf38
100 * noun + verb

# ╔═╡ Cell order:
# ╠═443124b0-4d17-11eb-2e50-857191e4ae0b
# ╠═282b2b7e-4d12-11eb-2506-3316dce68cbc
# ╠═2e14023e-4d14-11eb-2369-b13c4d9f11b8
# ╠═c82b9210-4d16-11eb-3b18-0f117b2d11a4
# ╠═67013ba0-4d18-11eb-2c3d-bf15e656234a
# ╠═76736542-4d18-11eb-0c54-af289cedcf38
