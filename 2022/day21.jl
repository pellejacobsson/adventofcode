using Plots

function read_input(filename)
    monkeys = Dict()
    open(filename) do f
        for line in readlines(f)
            s = split(strip(line), " ")
            if length(s) == 2
                monkeys[s[1][1:end-1]] = parse(Int, s[2])
            else
                monkeys[s[1][1:end-1]] = s[2:end]
            end
        end
    end
    monkeys
end

function yell(monkey, monkeys)
    res = monkeys[monkey]
    if typeof(res) == Int
        return res
    else
        monkey1 = res[1]
        monkey2 = res[3]
        op = res[2]
        f = Dict(
            "+" => +,
            "-" => -,
            "*" => *,
            "/" => /,
            "==" => ==
        )
        if op in ["+", "-", "*", "/"]
            return Int(round(f[op](yell(monkey1, monkeys), yell(monkey2, monkeys))))
        elseif op == "=="
            return yell(monkey1, monkeys) == yell(monkey2, monkeys)
        elseif op == "?"
            return (yell(monkey1, monkeys), yell(monkey2, monkeys))
        else
            println("Something went wrong!")
        end
    end
end

function runit(filename)
    monkeys = read_input("21_input.txt")
    yell("root", monkeys)
end

function runit2(filename, x1, x2)
    monkeys = read_input(filename)
    monkeys["root"][2] = "?"
    root = []
    humn_vals = [x1, x2]
    for n in humn_vals
        monkeys["humn"] = n
        push!(root, yell("root", monkeys))
    end
    plot(humn_vals, [x[1] for x in root], markershape=:auto)
    hline!([root[1][2]])
end

function runit3(filename)
    monkeys = read_input("21_input.txt")
    monkeys["root"][2] = "=="
    root = []
    humn_vals = Int(3.0326718002e12):Int(3.0326718004e12)
    for n in humn_vals
        monkeys["humn"] = n
        if yell("root", monkeys)
            println("n = $n")
        end
    end
end

function runit4(filename)
    monkeys = read_input(filename)
    monkeys["root"][2] = "?"
    monkeys["humn"] = 3032671800353
    yell("root", monkeys)
end

runit("21_input.txt")

runit2("21_input.txt", 3032*10^9, 3033*10^9)

runit3("21_input.txt")

runit4("21_input.txt")