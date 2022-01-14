struct Process
    inputs::Array{String}
    amounts::Array{Int}
    output_amount::Int
end

function read_input(filename)
    processes = Dict()
    proc = open(filename) do f
        for l in readlines(f)
            input, output = split(l, " => ")
            input = split(input, ", ")
            output_amount, output = split(output, " ")
            amounts = []
            inputs = []
            for s in input
                s1, s2 = split(s, " ")
                push!(amounts, parse(Int, s1))
                push!(inputs, s2)
            end
            processes[output] = Process(inputs, amounts, parse(Int, output_amount))
        end
    end
    return processes
end

function ore_amount(proc, ingredient, amount, inventory)
    process = proc[ingredient]
    if amount ≥ inventory[ingredient]
        amount -= inventory[ingredient]
        inventory[ingredient] = 0
    else
        inventory[ingredient] -= amount
        amount = 0
    end
    n_proc = ceil(amount / process.output_amount)
    inventory[ingredient] += n_proc * process.output_amount - amount
    if length(process.inputs) == 1 && process.inputs[1] == "ORE"
        return n_proc * process.amounts[1]
    else
        s = 0
        for (input, input_amount) in zip(process.inputs, process.amounts)
            s += ore_amount(proc, input, n_proc * input_amount, inventory)
        end
    end
    return s
end

# Part 1
function p1(input_filename)
    proc = read_input(input_filename)
    inventory = Dict(key => 0 for key in keys(proc))
    return ore_amount(proc, "FUEL", 1, inventory)
end

p1("14_input.txt")

# Part 2

function superfuel(proc, fuel_amount)
    inventory = Dict(key => 0.0 for key in keys(proc))
    return ore_amount(proc, "FUEL", fuel_amount, inventory)
end

proc = read_input("14_input.txt")

ore_max = 1e12
n_min = 1
n_max = 1e12
n_guess = 0
n_guess_prev = 0
while true
    n_guess_prev, n_guess = n_guess, Int(floor((n_max + n_min) / 2))
    n_ore = superfuel(proc, n_guess)
    if n_ore > ore_max
        n_max = n_guess
    else
        n_min = n_guess
    end
    if n_guess == n_guess_prev
        break
    end
    @show n_guess
end

superfuel(proc, n_guess)
superfuel(proc, n_guess+1)
