sonar = open("1_input.txt") do f
    [parse(Int, s) for s in readlines(f)]
end

# Part 1
sum(diff(sonar) .> 0)

#Part 2
n_sonar = length(sonar)
sonar_moving_sum = [sum(sonar[i:i+2]) for i = 1:n_sonar-2]
sum(diff(sonar_moving_sum) .> 0)