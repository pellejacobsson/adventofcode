function read_input(filename)
    ffm = Dict()
    cm = Dict()
    bm = Dict()
    open(filename) do f
        for line in readlines(f)
            p_in, p_out = split(line, " -> ")
            if startswith(p_in, "%")
                ffm[p_in[2:end]] = [0, split(p_out, ", ")]
            elseif startswith(p_in, "&")
                cm[p_in[2:end]] = [Dict(), split(p_out, ", ")]
            else
                bm[p_in] = split(p_out, ", ")
            end
        end
    end
    for (ck, cv) in cm
        for (ffk, ffv) in ffm
            if ck in ffv[2]
                cv[1][ffk] = 0
            end
        end
        for (ck2, cv2) in cm
            if ck in cv2[2]
                cv[1][ck2] = 0
            end
        end
    end
    ffm, cm, bm
end

function step(ffm, cm, pulses, cache, i)
    out_pulses = []
    cm_dests = []
    for (source, pulse, dest) in pulses
        if dest in keys(ffm) && pulse == 0
            if ffm[dest][1] == 0
                ffm[dest][1] = 1
                append!(out_pulses, [(dest, 1, out_dest) for out_dest in ffm[dest][2]])
            else
                ffm[dest][1] = 0
                append!(out_pulses, [(dest, 0, out_dest) for out_dest in ffm[dest][2]])
            end
        elseif dest in keys(cm)
            cm[dest][1][source] = pulse
            push!(cm_dests, dest)
        end
    end
    for cm_out in cm_dests
        if all(values(cm[cm_out][1]) .== 1)
            if cm_out in ["bc", "hq", "ql", "hl"]
                push!(cache[cm_out], i)
            end
            append!(out_pulses, [(cm_out, 0, out_dest) for out_dest in cm[cm_out][2]])
        else
            append!(out_pulses, [(cm_out, 1, out_dest) for out_dest in cm[cm_out][2]])
        end
    end
    out_pulses
end

function press_button(ffm, cm, bm, cache, i)
    source = "broadcaster"
    pulses = [(source, 0, dest) for dest in bm[source]]
    n_low = 1 + length(filter(x -> x[2] == 0, pulses))
    n_high = length(filter(x -> x[2] == 1, pulses))
    while true
        pulses = step(ffm, cm, pulses, cache, i)
        n_low += length(filter(x -> x[2] == 0, pulses))
        n_high += length(filter(x -> x[2] == 1, pulses))
        length(pulses) == 0 && break
    end
    n_low, n_high
end

function runit(filename)
    ffm, cm, bm = read_input(filename)
    n_low_tot, n_high_tot = 0, 0
    cache = Dict("bc" => [], "hq" => [], "ql" => [], "hl" => [])
    for i = 1:1000
        n_low, n_high = press_button(ffm, cm, bm, cache, i)
        n_low_tot += n_low
        n_high_tot += n_high
    end
    n_low_tot * n_high_tot
end

function runit2(filename)
    ffm, cm, bm = read_input(filename)
    cache = Dict("bc" => [], "hq" => [], "ql" => [], "hl" => [])
    for i = 1:100000
        press_button(ffm, cm, bm, cache, i)
    end
    cache
end

function calc_part2()
    lcm(3911, 3907, 4057, 3929)
end



runit("20_input.txt")
cache = runit2("20_input.txt")
calc_part2()