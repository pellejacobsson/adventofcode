function read_input(filename)
    rounds = open(filename, "r") do f
        Tuple.(split.(readlines(f)))
    end
end

function calc_score(rounds, part2)
    if !part2
        score_table = Dict(
            ("A", "X") => 1 + 3,
            ("A", "Y") => 2 + 6,
            ("A", "Z") => 3 + 0,
            ("B", "X") => 1 + 0,
            ("B", "Y") => 2 + 3,
            ("B", "Z") => 3 + 6,
            ("C", "X") => 1 + 6,
            ("C", "Y") => 2 + 0,
            ("C", "Z") => 3 + 3
        )
    else
        score_table = Dict(
            ("A", "X") => 3 + 0,
            ("A", "Y") => 1 + 3,
            ("A", "Z") => 2 + 6,
            ("B", "X") => 1 + 0,
            ("B", "Y") => 2 + 3,
            ("B", "Z") => 3 + 6,
            ("C", "X") => 2 + 0,
            ("C", "Y") => 3 + 3,
            ("C", "Z") => 1 + 6
        )
    end
    score = 0
    for round in rounds
        score += score_table[round]
    end
    score
end

function runit(filename; part2=false)
    rounds = read_input(filename)
    score = calc_score(rounds, part2)
end

runit("02_input.txt")
runit("02_input.txt"; part2=true)