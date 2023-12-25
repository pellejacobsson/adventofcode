function read_input(filename)
    open(filename) do f
        split.(split(read(f, String), "\n\n"), "\n", keepempty=false)
    end
end

function translate_workflow(workflow_raw)
    conditions = []
    for m in eachmatch(r"(\w+[=<>]\d+):(\w+)", workflow_raw)
        push!(conditions, [m[1], m[2]])
    end
    base_case = match(r",(\w+)}$", workflow_raw)[1]
    workflow_name = match(r"^(\w+){", workflow_raw)[1]
    workflow_name, conditions, base_case
end

function translate_workflow2(workflow_raw)
    var_map = Dict("x" => 1, "m" => 2, "a" => 3, "s" => 4)
    conditions = []
    for m in eachmatch(r"(\w+)([<>])(\d+):(\w+)", workflow_raw)
        push!(conditions, [var_map[m[1]], m[2], parse(Int, m[3]), m[4]])
    end
    base_case = match(r",(\w+)}$", workflow_raw)[1]
    workflow_name = match(r"^(\w+){", workflow_raw)[1]
    workflow_name, conditions, base_case
end

function get_workflows(workflows_raw; ver=1)
    wf_conditions = Dict()
    wf_base_case = Dict()
    for workflow_raw in workflows_raw
        if ver == 1
            workflow_name, conditions, base_case = translate_workflow(workflow_raw)
        else
            workflow_name, conditions, base_case = translate_workflow2(workflow_raw)
        end
        wf_conditions[workflow_name] = conditions
        wf_base_case[workflow_name] = base_case
    end
    wf_conditions, wf_base_case
end

function translate_part(part)
    for p in eachmatch(r"([xmas]=\d+)", part)
        eval(Meta.parse(p[1]))
    end
    [x, m, a, s]
end

function run_workflow(wf_conditions, wf_base_case, part)
    x, m, a, s = part
    wf = "in"
    while true
        found = false
        for (condition, res) in wf_conditions[wf]
            if eval(Meta.parse(replace(condition, "x" => "$x", "m" => "$m", "a" => "$a", "s" => "$s")))
                wf = res
                found = true
                break
            end
        end
        wf in ["A", "R"] && break
        if !found
            wf = wf_base_case[wf]
        end
        wf in ["A", "R"] && break
    end
    wf
end

function test_parts(workflows_raw, parts_raw)
    wf_conditions, wf_base_case = get_workflows(workflows_raw)
    parts = translate_part.(parts_raw)
    s = 0
    for part in parts
        classification = run_workflow(wf_conditions, wf_base_case, part)
        if classification == "A"
            s += sum(part)
        end
    end
    s
end

function test_all_parts(wf_conditions, wf_base_case)
    q = [("in", [collect(1:4000) for _ in 1:4])]
    a_list = []
    while !isempty(q)
        wf, parts = pop!(q)
        if wf == "A"
            push!(a_list, parts)
            continue
        elseif wf == "R"
            continue
        end
        cparts = copy(parts)
        for (i, op, n, to_wf) in wf_conditions[wf]
            parts_true = copy(cparts)
            ix = op == "<" ? cparts[i] .< n : cparts[i] .> n
            parts_true[i] = cparts[i][ix]
            push!(q, (to_wf, parts_true))
            cparts[i] = cparts[i][.~ix]
        end
        push!(q, (wf_base_case[wf], cparts))
    end
    a_list
end

function runit(filename; part2=false)
    ver = part2 ? 2 : 1
    workflows_raw, parts_raw = read_input(filename)
    wf_conditions, wf_base_case = get_workflows(workflows_raw, ver=ver)
    if !part2
        test_parts(workflows_raw, parts_raw)
    else
        a_list = test_all_parts(wf_conditions, wf_base_case)
        sum([prod([length(p) for p in part]) for part in a_list])
    end
end

runit("19_input.txt")
runit("19_input.txt", part2=true)
