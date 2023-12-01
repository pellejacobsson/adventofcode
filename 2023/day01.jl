function read_input(filename)
    open(filename) do f
        readlines(f)
    end
end

function runit(filename; part2=false)
    input = read_input(filename)
    if part2
        replace_map = Dict(
            "one" => "1",
            "two" => "2",
            "three" => "3",
            "four" => "4",
            "five" => "5",
            "six" => "6",
            "seven" => "7",
            "eight" => "8",
            "nine" => "9"
        )
        linput = replace.(input, replace_map...)
        rinput = reverse.(replace.(reverse.(input), Dict(reverse(k) => v for (k, v) in replace_map)...))
        lcalibration = [[s for s in l if isnumeric(s)] for l in linput]
        rcalibration = [[s for s in l if isnumeric(s)] for l in rinput]
        sum(parse.(Int, [x[1] * y[end] for (x, y) in zip(lcalibration, rcalibration)]))
    else
        calibration = [[s for s in l if isnumeric(s)] for l in input]
        sum(parse.(Int, [x[1] * x[end] for x in calibration]))
    end
end

runit("01_input.txt")
runit("01_input.txt", part2=true)