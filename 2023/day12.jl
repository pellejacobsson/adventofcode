using IterTools

function read_input(filename)
    records = []
    groups = []
    rec_map = Dict('.' => 0, '#' => 1, '?' => 2)
    open(filename) do f
        for line in readlines(f)
            r, g = split(line)
            push!(records, [rec_map[s] for s in r])
            push!(groups, parse.(Int, split(g, ",")))
        end
    end
    records, groups
end

function read_input2(filename)
    records = []
    groups = []
    open(filename) do f
        for line in readlines(f)
            r, g = split(line)
            push!(records, r)
            push!(groups, parse.(Int, split(g, ",")))
        end
    end
    records, groups
end

function get_record_perms(record, group)
    ix = findall(x -> x == 2, record)
    ix1 = findall(x -> x == 1, record)
    nix = length(ix)
    perms = [digits(n, base=2, pad=nix) for n = 0:2^nix - 1]
    perms = [perm for perm in perms if sum(perm) + sum(record[ix1])== sum(group)]
    precords = Vector{Int64}[]
    for perm in perms
        precord = copy(record)
        precord[ix] = perm
        push!(precords, precord)
    end
    precords
end

function count_record_perm(record, group)
    precords = get_record_perms(record, group)
    s = 0
    for precord in precords
        isfit = [length(g) for g in groupby(x -> x, precord) if g[1] == 1] == group
        s += isfit ? 1 : 0
    end
    s
end

function solve(records, groups)
    n = 0
    for (record, group) in zip(records, groups)
        n += count_record_perm(record, group)
    end
    n
end

function dot(record, groups)
    count_record_perm2(record[2:end], groups)
end

function pound(record, groups)
    next_group = groups[1]
    this_group = replace(record[1:min(next_group, length(record))], "?" => "#")
    this_group == "#"^next_group || return 0
    if length(record) == next_group
        return length(groups) == 1 ? 1 : 0
    end
    if record[next_group + 1] in "?."
        return count_record_perm2(record[next_group + 2:end], groups[2:end])
    end
    return 0
end

function count_record_perm2(record, groups)
    if length(groups) == 0
        return !('#' in record) ? 1 : 0
    end
    length(record) == 0 && return 0

    next_char = record[1]
    
    if next_char == '#'
        res = pound(record, groups)
    elseif next_char == '.'
        res = dot(record, groups)
    elseif next_char == '?'
        res = dot(record, groups) + pound(record, groups)
    end
    res
end

function solve2(records, groups)
    n = 0
    for (record, group) in zip(records, groups)
        n += count_record_perm2(record, group)
    end
    n
end

function runit(filename; part2=false)
    records, groups = read_input(filename)
    solve(records, groups)
end

#runit("12_input.txt")

records, groups = read_input2("12_testinput.txt")
solve2(records, groups)