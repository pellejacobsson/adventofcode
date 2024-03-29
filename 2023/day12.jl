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
            push!(groups, Tuple(parse.(Int, split(g, ","))))
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

function count(record, groups, mem)
    if record == ""
        return isempty(groups) ? 1 : 0
    end
    if isempty(groups)
        return '#' in record ? 0 : 1
    end

    if (record, groups) in keys(mem)
        return mem[(record, groups)]
    end

    res = 0
    if record[1] in ".?"
        res += count(record[2:end], groups, mem)
    end
    if record[1] in "#?"
        if groups[1] <= length(record) && !('.' in record[1:groups[1]]) && (groups[1] == length(record) || record[groups[1] + 1] != '#')
            res += count(record[groups[1] + 2:end], groups[2:end], mem)
        end
    end
    mem[(record, groups)] = res
    res
end

function solve2(records, groups)
    n = 0
    mem = Dict()
    for (record, group) in zip(records, groups)
        n += count(record, group, mem)
    end
    n
end

function runit(filename; part2=false)
    records, groups = read_input2(filename)
    if part2
        records = [join(repeat([r], 5), "?") for r in records]
        groups = [Tuple(repeat([g...], 5)) for g in groups]
    end
    solve2(records, groups)
end

runit("12_input.txt")
runit("12_input.txt", part2=true)