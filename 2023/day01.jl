function read_input(filename)
    open(filename) do f
        readlines(f)
    end
end

function runit(filename; part2=false) :: Int
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
        rinput = replace.(reverse.(input), Dict(reverse(k) => v for (k, v) in replace_map)...)
        codes = [x.match[1] * y.match[1] for (x, y) in zip(match.(r"\d", linput), match.(r"\d", rinput))]
    else
        codes = [x.match[1] * x.match[end] for x in match.(r"\d", input)]
    end
    sum(parse.(Int, codes))
end

runit("01_input.txt")
runit("01_input.txt", part2=true)