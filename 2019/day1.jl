### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 6130c620-4cda-11eb-3954-1d5a7b57011d
input = open("1_input.txt") do f
	[parse(Int, s) for s in readlines(f)]
end

# ╔═╡ c51a78c0-4cda-11eb-3489-d368f64c87aa
Int(sum(floor.(input ./ 3) .- 2))

# ╔═╡ a7a6b000-4cdb-11eb-064f-5bf7e64a6726
function calcfuel(m)::Int
	f = floor(m / 3) - 2
	if f ≤ 0
		return 0
	else
		return f + calcfuel(f)
	end
end

# ╔═╡ d508e1d2-4cdb-11eb-05df-2136c031be31
sum(calcfuel.(input))

# ╔═╡ Cell order:
# ╠═6130c620-4cda-11eb-3954-1d5a7b57011d
# ╠═c51a78c0-4cda-11eb-3489-d368f64c87aa
# ╠═a7a6b000-4cdb-11eb-064f-5bf7e64a6726
# ╠═d508e1d2-4cdb-11eb-05df-2136c031be31
