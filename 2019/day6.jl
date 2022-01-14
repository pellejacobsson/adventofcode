### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 261ec150-58a5-11eb-3933-439d7a0e1d83
function readinput(filename)
	input = open(filename) do f
		readlines(f)
	end
	d = Dict()
	rexp = r"(.*)\)(.*)"
	for l in input
		m = match(rexp, l)
		orbiter = m.captures[2]
		orbitee = m.captures[1]
		d[orbiter] = orbitee
	end
	return d
end

# ╔═╡ 61f92c60-58a5-11eb-33e4-c9292dae3dff
function countorb(mem, d, orbiter)
	if orbiter == "COM"
		return 0
	else
		if haskey(mem, orbiter)
			return mem[orbiter]
		else
			val = 1 + countorb(mem, d, d[orbiter])
			mem[orbiter] = val
			return val
		end
	end
end

# ╔═╡ 5bf943d0-58a6-11eb-2b74-679705d7c603
function countall(d)
	mem = Dict()
	s = 0
	for o in keys(d)
		s += countorb(mem, d, o)
	end
	return s
end

# ╔═╡ 6db4a7de-58ab-11eb-117b-2f504251f35c
function getorb(d, orbiter)
	orbitee_list = []
	o = orbiter
	while o != "COM"
		push!(orbitee_list, o)
		o = d[o]
	end
	return orbitee_list
end

# ╔═╡ a0487290-58a6-11eb-0dfb-077eb88d4c1f
d = readinput("6_input.txt")

# ╔═╡ 42861bc2-58a7-11eb-18da-7be4461d2db7
c = countall(d)

# ╔═╡ 9ec4aa00-58ac-11eb-2a68-752e30767e9e
function orbdist(d, o1, o2)
	l1 = getorb(d, o1)
	l2 = getorb(d, o2)
	i, j = 0, 0
	for (idx, o) in enumerate(l1)
		if o in l2
			i = idx
			j = findfirst(x -> x == o, l2)
			break
		end
	end
	return i + j - 2
end

# ╔═╡ 68a4f640-58ad-11eb-3f86-3156ca855b00
orbdist(d, d["YOU"], d["SAN"])

# ╔═╡ Cell order:
# ╠═261ec150-58a5-11eb-3933-439d7a0e1d83
# ╠═61f92c60-58a5-11eb-33e4-c9292dae3dff
# ╠═5bf943d0-58a6-11eb-2b74-679705d7c603
# ╠═6db4a7de-58ab-11eb-117b-2f504251f35c
# ╠═a0487290-58a6-11eb-0dfb-077eb88d4c1f
# ╠═42861bc2-58a7-11eb-18da-7be4461d2db7
# ╠═9ec4aa00-58ac-11eb-2a68-752e30767e9e
# ╠═68a4f640-58ad-11eb-3f86-3156ca855b00
