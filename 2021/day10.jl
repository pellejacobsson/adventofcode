function get_input(filename)
    lines = open(filename) do f
        readlines(f)
    end
    code = []
    for line in lines
        push!(code, [s for s in line])
    end
    return code
end

function get_incorrects(code)
    left = ['(', '[', '{', '<']
    closing = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>')
    incorrect = []
    idx = []
    for (i, code_line) in enumerate(code)
        stack = []
        for c in code_line
            if c in left
                push!(stack, c)
            elseif c == closing[stack[end]]
                pop!(stack)
            else
                push!(incorrect, c)
                push!(idx, i)
                break
            end
        end
    end
    return incorrect, idx
end

function score(incorrect)
    scores = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
    s = 0
    for p in incorrect
        s += scores[p]
    end
    return s
end

code = get_input("10_input.txt")
incorrect, idx = get_incorrects(code)
out = score(incorrect)

# Part 2
function autocomplete(code)
    left = ['(', '[', '{', '<']
    closing = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>')
    completions = []
    for code_line in code
        stack = []
        for c in code_line
            if c in left
                push!(stack, c)
            elseif c == closing[stack[end]]
                pop!(stack)
            end
        end
        push!(completions, [closing[c] for c in reverse(stack)])
    end
    return completions
end

function score_completions(completions)
    points = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)
    scores = []
    for completion in completions
        s = 0
        for c in completion
            s = s * 5 + points[c]
        end
        push!(scores, s)
    end
    return sort(scores)[Int((length(scores) + 1) / 2)]
end

code = [code[i] for i in 1:length(code) if i ∉ idx]
completions = autocomplete(code)

out = score_completions(completions)