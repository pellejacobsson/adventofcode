using OffsetArrays

function get_code(filename)
    code = open(filename) do f
        read(f, String)
    end
    code = parse.(Int, split(code, ","))
    return code
end

function intcode!(instruction, input, i_start, rel_start)
	i = i_start
	rel = rel_start
	while instruction[i] != 99
		opcode = instruction[i]
		opcode_list = [parse(Int, x) for x in string(opcode)]
		opcode_list = vcat(zeros(Int, 5 - length(opcode_list)), opcode_list)
		a, b, c, d, e = (opcode_list...,)
		if e == 1 || e == 2
			if c == 0
				p1 = instruction[instruction[i+1]]
			elseif c == 1
				p1 = instruction[i+1]
			elseif c == 2
				p1 = instruction[instruction[i+1] + rel]
			else
				error("Parameter error")
			end
			if b == 0
				p2 = instruction[instruction[i+2]]
			elseif b == 1
				p2 = instruction[i+2]
			elseif b == 2
				p2 = instruction[instruction[i+2] + rel]
			else
				error("Parameter error")
			end
			if a == 0
				p3 = instruction[i+3]
			elseif a == 2
				p3 = instruction[i+3] + rel
			else
				error("Parameter error")
			end
			instruction[p3] = e == 1 ? p1 + p2 : p1 * p2
			i += 4
		elseif e == 3
			if c == 0
				p1 = instruction[i+1]
			elseif c == 2
				p1 = instruction[i+1] + rel
			else
				error("Parameter error")
			end
			instruction[p1] = input
			i += 2
		elseif e == 4
			if c == 0
				p1 = instruction[instruction[i+1]]
			elseif c == 1
				p1 = instruction[i+1]
			elseif c == 2
				p1 = instruction[instruction[i+1] + rel]
			else
				error("Parameter error")
			end
			i += 2
			return i, p1, rel
		elseif e == 5 || e == 6
			if c == 0
				p1 = instruction[instruction[i+1]]
			elseif c == 1
				p1 = instruction[i+1]
			elseif c == 2
				p1 = instruction[instruction[i+1] + rel]
			else
				error("Parameter error")
			end
			if b == 0
				p2 = instruction[instruction[i+2]]
			elseif b == 1
				p2 = instruction[i+2]
			elseif b == 2
				p2 = instruction[instruction[i+2] + rel]
			else
				error("Parameter error")
			end
			if e == 5 && p1 != 0
				i = p2
			elseif e == 6 && p1 == 0
				i = p2
			else
				i += 3
			end
		elseif e == 7 || e == 8
			if c == 0
				p1 = instruction[instruction[i+1]]
			elseif c == 1
				p1 = instruction[i+1]
			elseif c == 2
				p1 = instruction[instruction[i+1] + rel]
			else
				error("Parameter error")
			end
			if b == 0
				p2 = instruction[instruction[i+2]]
			elseif b == 1
				p2 = instruction[i+2]
			elseif b == 2
				p2 = instruction[instruction[i+2] + rel]
			else
				error("Parameter error")
			end
			if a == 0
				p3 = instruction[i+3]
			elseif a == 2
				p3 = instruction[i+3] + rel
			else
				error("Parameter error")
			end
			if e == 7
				instruction[p3] = p1 < p2 ? 1 : 0
			else
				instruction[p3] = p1 == p2 ? 1 : 0
			end
			i += 4
		elseif e == 9
			if c == 0
				p1 = instruction[instruction[i+1]]
			elseif c == 1
				p1 = instruction[i+1]
			elseif c == 2
				p1 = instruction[instruction[i+1] + rel]
			else
				error("Parameter error")
			end
			rel += p1
			i += 2
		else
			error("Opcode error")
		end
	end
	return i, nothing, rel
end

function runcode(code, input)
    ascii = []
    i = 0
    rel = 0
	output = -1
    while true
        i, output, rel = intcode!(code, input, i, rel)
		if output === nothing
			break
		else
        	push!(ascii, output)
		end
    end
    return ascii
end

function make_matrix(ascii)
	nrows = findfirst(x -> x == 10, ascii)
	ncols = Int((length(ascii) - 1) / nrows)
	m = reshape(ascii[1:end-1], (nrows, :))
	m = transpose(m)
	return m[:, 1:end-1]
end

function write_scaffolds(ascii, filename)
	open(filename, "w") do f
		write(f, String(UInt8.(ascii)))
	end
end

orig_code = get_code("17_input.txt")
code = vcat(orig_code, zeros(Int, 10000))
code = OffsetArray(code, 0:length(code)-1)
asc = runcode(code, 1)
m = make_matrix(asc)

nodes = Dict()
for i = 2:size(m, 1)-1, j = 2:size(m, 2)-1
	if m[i, j] == 35 && m[i-1, j] == 35 && m[i+1,j] == 35 && m[i, j-1] == 35 && m[i, j+1] == 35
		nodes[(i, j)] = (i - 1) * (j - 1)
	end
end

sum(values(nodes))
