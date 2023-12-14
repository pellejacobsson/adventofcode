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

function n_rec(rec, l)
    sum(rec .== '#') > l && return 0
    sum(in.(rec, (['#', '?'],))) < l && return 0
    any(1 .< findall(==('.'), rec) .< length(rec)) && return 0
    ix = findall(==('?'), rec)
    ix1 = findall(==('#'), rec)
    nix = length(ix)
    perms = [digits(n, base=2, pad=nix) for n = 0:2^nix - 1]
    perms = [perm for perm in perms if sum(perm) + sum(rec[ix1])== sum(group)]
        

function n_ways(rec, g)
    if length(g) == 1


function runit(filename; part2=false)
    records, groups = read_input(filename)
    solve(records, groups)
end

runit("12_input.txt")