function runit(pos1, pos2)
    score1 = 0
    score2 = 0
    itot = 0
    i = 1
    while true
        pos1 += sum(i:i+2)
        pos1 = pos1 % 10 == 0 ? 10 : pos1 % 10
        score1 += pos1
        itot += 3
        i += 3
        i = i > 100 ? i % 100 : i
        if score1 ≥ 1000
            break
        end
        pos2 += sum(i:i+2)
        pos2 = pos2 % 10 == 0 ? 10 : pos2 % 10
        score2 += pos2
        itot += 3
        i += 3
        i = i > 100 ? i % 100 : i
        if score2 ≥ 1000
            break
        end
    end
    return score1, score2, itot
end

score1, score2, rounds = runit(7, 8)

out = min(score1, score2) * rounds