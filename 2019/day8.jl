### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ 56c9f6eb-64cb-4156-aeb7-71b7e4ced708
using Colors

# ╔═╡ bafac392-5e46-11eb-3816-49f479abc179
function read_data(filename)
	input = open(filename) do f
		readline(f)
	end
	m = [parse(Int, s) for s in input]
	return m
end

# ╔═╡ da2f6ed0-5e48-11eb-3ac2-0b1fdaf91467
function get_data(filename, nrows, ncols)
	m = read_data(filename)
	m = reshape(m, ncols, nrows, :)
	m = permutedims(m, [2, 1, 3])
	return m
end

# ╔═╡ 0fe08cd0-5e49-11eb-0b86-ff620fad69b8
function count_values(layer, value)
	return sum(layer .== value)
end

# ╔═╡ 2add1e92-5e49-11eb-0576-e9cd5bd2ae22
function find_min_zero_layer(m)
	i_min = 1
	z_min = 26*5
	for i in 1:size(m)[3]
		z_curr = count_values(m[:,:,i], 0)
		if z_curr < z_min
			i_min = i
			z_min = z_curr
		end
	end
	return i_min
end

# ╔═╡ 711d32c0-5e47-11eb-093d-21c679d9fccc
m = get_data("8_input.txt", 6, 25);

# ╔═╡ 55d8769b-9818-4e8d-b9a2-777b392b6b23
find_min_zero_layer(m)

# ╔═╡ 1e911420-5e49-11eb-2637-9b74cabe56e9
count_values(m[:,:,7], 1) * count_values(m[:,:,7], 2)

# ╔═╡ 8fc39a6f-bb26-4848-9b5b-f9c124926a9e
function get_pixel_color(m, row, col)
	i = findfirst(x -> x != 2, m[row, col, :])
	return m[row, col, i]
end

# ╔═╡ e06b8330-1007-466c-bce1-855d42bc13c0
m2 = fill(3, 6, 25)

# ╔═╡ 54706a67-862f-490d-8f5c-e81fbb6988eb
for i = 1:6
	for j = 1:25
		m2[i, j] = get_pixel_color(m, i, j)
	end
end

# ╔═╡ 3ef00edd-6623-4ac3-85bf-d1d4b64b6030
Gray.(m2 .== 0)

# ╔═╡ Cell order:
# ╠═bafac392-5e46-11eb-3816-49f479abc179
# ╠═da2f6ed0-5e48-11eb-3ac2-0b1fdaf91467
# ╠═0fe08cd0-5e49-11eb-0b86-ff620fad69b8
# ╠═2add1e92-5e49-11eb-0576-e9cd5bd2ae22
# ╠═711d32c0-5e47-11eb-093d-21c679d9fccc
# ╠═55d8769b-9818-4e8d-b9a2-777b392b6b23
# ╠═1e911420-5e49-11eb-2637-9b74cabe56e9
# ╠═8fc39a6f-bb26-4848-9b5b-f9c124926a9e
# ╠═e06b8330-1007-466c-bce1-855d42bc13c0
# ╠═54706a67-862f-490d-8f5c-e81fbb6988eb
# ╠═56c9f6eb-64cb-4156-aeb7-71b7e4ced708
# ╠═3ef00edd-6623-4ac3-85bf-d1d4b64b6030
