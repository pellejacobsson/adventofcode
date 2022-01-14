### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 2eb7e320-4db3-11eb-3a27-df9fa2c0461d
function readinput(filename)
	input = open(filename) do f
		readlines(f)
	end
	w1 = split(input[1], ",")
	w2 = split(input[2], ",")
	return w1, w2
end

# ╔═╡ 8958e170-4dcd-11eb-22ce-1d964cdcb772
function move(grid::Dict, i::Int64, j::Int64, instr::SubString{String})
	dir = instr[1]
	steps = parse(Int, instr[2:end])
	val0 = grid[(i, j)]
	if dir == 'R'
		for s in 1:steps
			if !haskey(grid, (i, j+s))
				grid[(i, j+s)] = val0 + s
			end
		end
		return i, j + steps
	elseif dir == 'U'
		for s in 1:steps
			if !haskey(grid, (i+s, j))
				grid[(i+s, j)] = val0 + s
			end
		end
		return i + steps, j
	elseif dir == 'L'
		for s in 1:steps
			if !haskey(grid, (i, j-s))
				grid[(i, j-s)] = val0 + s
			end
		end
		return i, j - steps
	else
		for s in 1:steps
			if !haskey(grid, (i-s, j))
				grid[(i-s, j)] = val0 + s
			end
		end
		return i - steps, j
	end
end

# ╔═╡ d9d4a460-4dd0-11eb-0138-f7ccd4eee7dc
function laywire(wire)
	g = Dict()
	i, j = 0, 0
	g[(i, j)] = 0
	for w in wire
		i, j = move(g, i, j, w)
	end
	return g
end

# ╔═╡ 9c2675a0-4dce-11eb-2a5d-39ca37c7e28d
function laywires(filename::String)
	w1, w2 = readinput(filename)
	g1 = laywire(w1)
	g2 = laywire(w2)
	return g1, g2
end

# ╔═╡ 9a3da67e-4dd0-11eb-084f-b3bbe3637cb1
function findmindist(g1, g2)
	d = []
	for (k1, v1) in g1
		if k1 == (0, 0)
			continue
		end
		if haskey(g2, k1)
			push!(d, abs(k1[1]) + abs(k1[2]))
		end
	end
	return minimum(d)
end

# ╔═╡ cf251670-4dd1-11eb-3b21-93720a402450
function minsteps(g1, g2)
	d = []
	for (k1, v1) in g1
		if k1 == (0, 0)
			continue
		end
		if haskey(g2, k1)
			push!(d, k1)
		end
	end
	s = 1000000
	for k in d
		cs = g1[k] + g2[k]
		if cs < s
			s = cs
		end
	end
	return s
end

# ╔═╡ 5977c58e-4dd0-11eb-30bd-91694fae8bb7
g1, g2 = laywires("3_input.txt")

# ╔═╡ 6da29fce-4dd1-11eb-3293-61988551ba4a
findmindist(g1, g2)

# ╔═╡ 59a5a170-4dd2-11eb-1194-9520e77df470
minsteps(g1, g2)

# ╔═╡ Cell order:
# ╠═2eb7e320-4db3-11eb-3a27-df9fa2c0461d
# ╠═8958e170-4dcd-11eb-22ce-1d964cdcb772
# ╠═d9d4a460-4dd0-11eb-0138-f7ccd4eee7dc
# ╠═9c2675a0-4dce-11eb-2a5d-39ca37c7e28d
# ╠═9a3da67e-4dd0-11eb-084f-b3bbe3637cb1
# ╠═cf251670-4dd1-11eb-3b21-93720a402450
# ╠═5977c58e-4dd0-11eb-30bd-91694fae8bb7
# ╠═6da29fce-4dd1-11eb-3293-61988551ba4a
# ╠═59a5a170-4dd2-11eb-1194-9520e77df470
