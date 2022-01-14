### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ b8bf20c0-4eb6-11eb-013c-eb5848d0ece8
r = 246515:739105

# ╔═╡ ea756a70-4eb6-11eb-08b1-d3fc335b425c
hastwin(n) = sum(diff([parse(Int, s) for s in string(n)]) .== 0) > 0

# ╔═╡ eb31c020-4eb7-11eb-38b9-83b2e28ab770
function hastwin2(n)
	nl = [parse(Int, s) for s in string(n)]
	triples = []
	for i in 3:length(nl)
		if nl[i-2] == nl[i-1] == nl[i]
			push!(triples, nl[i])
		end
	end
	doubles = []
	for i in 2:length(nl)
		if nl[i-1] == nl[i] && nl[i] ∉ triples
			push!(doubles, nl[i])
		end
	end
	return length(doubles) > 0
end

# ╔═╡ 1df3c9f0-4eb7-11eb-0b62-95c26b75e79d
function isincreasing(n)
	nl = [parse(Int, s) for s in string(n)]
	return nl[1] <= nl[2] <= nl[3] <= nl[4] <= nl[5] <= nl[6]
end

# ╔═╡ 70054f6e-4eb7-11eb-257a-d7ee7aa32b97
function count(r)
	c = 0
	for i in r
		if hastwin2(i) && isincreasing(i)
			c += 1
		end
	end
	return c
end

# ╔═╡ b6919cf0-4eb7-11eb-3085-d5c82fc40dbc
count(r)

# ╔═╡ Cell order:
# ╠═b8bf20c0-4eb6-11eb-013c-eb5848d0ece8
# ╠═ea756a70-4eb6-11eb-08b1-d3fc335b425c
# ╠═eb31c020-4eb7-11eb-38b9-83b2e28ab770
# ╠═1df3c9f0-4eb7-11eb-0b62-95c26b75e79d
# ╠═70054f6e-4eb7-11eb-257a-d7ee7aa32b97
# ╠═b6919cf0-4eb7-11eb-3085-d5c82fc40dbc
