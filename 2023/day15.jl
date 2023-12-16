function read_input(filename)
    open(filename) do f
        split(readline(f), ",")
    end
end

function hash(seq)
    h = 0
    for s in seq
        h += Int(s)
        h *= 17
        h %= 256
    end
    h
end

function solve(seqs)
    sum(hash.(seqs))
end

function move_lens!(boxes, seq)
    re = r"(.+)([=-])(\d?)"
    m = match(re, seq)
    label = m[1]
    box = hash(label)
    op = m[2]
    focl = op == "=" ? parse(Int, m[3]) : -1
    if !(box in keys(boxes))
        boxes[box] = []
    end
    if op == "-"
        if label in [l[1] for l in boxes[box]]
            deleteat!(boxes[box], findfirst(l -> l[1] == label, boxes[box]))
        end
    else
        if label in [l[1] for l in boxes[box]]
            boxes[box][findfirst(l -> l[1] == label, boxes[box])] = (label, focl)
        else
            push!(boxes[box], (label, focl))
        end
    end
    boxes
end

function solve2(seqs)
    boxes = Dict()
    for seq in seqs
        boxes = move_lens!(boxes, seq)
    end
    p = 0
    for (box, lenses) in boxes
        if length(lenses) > 0
            p += sum([(box + 1) * i * x[2] for (i, x) in enumerate(lenses)])
        end
    end
    p
end

function runit(filename; part2=false)
    seqs = read_input(filename)
    if !part2
        solve(seqs)
    else
        solve2(seqs)
    end
end

runit("15_input.txt")
runit("15_input.txt", part2=true)