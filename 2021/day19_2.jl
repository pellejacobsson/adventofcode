using BSON

function max_manhattan1(points)
    max_dist = 0
    for i in 1:size(points, 2)
        for j in i:size(points, 2)
            dist = sum(abs.(points[:, i] - points[:, j]))
            max_dist = dist > max_dist ? dist : max_dist
        end
    end
    return max_dist
end

part1 = BSON.load("19_beacons.bson")
scanners = hcat(part1[:Δp_save]...)
out = max_manhattan1(scanners)