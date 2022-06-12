function str_to_bin_list(line)
    code = []
    for l in line
        b = reverse(digits(parse(Int, l, base = 16), base = 2, pad = 4))
        code = vcat(code, b)
    end
    return code
end

function read_input(filename)
    line = open(filename) do f
        readline(f)
    end
    return str_to_bin_list(line)
end

list_to_int(l) = parse(Int, join(string.(l)), base = 2)

function calc_value(i, code)
    value = []
    while true
        bit1 = code[i]
        value = vcat(value, code[i+1:i+4])
        i += 5
        if bit1 == 0
            break
        end
    end
    return i, value
end

function parse_packet(code, i)
    ver = list_to_int(code[i:i+2])
    type = list_to_int(code[i+3:i+5])
    if type == 4
        i, val = calc_value(i+6, code)
        return i, list_to_int(val)
    else
        length_type = code[i+6]
        if length_type == 0
            subpacket_length = list_to_int(code[i+7:i+21])
            curr_length = 0
            i += 22
            i0 = i
            if type == 0
                val = 0
                while curr_length < subpacket_length
                    i, sub_val = parse_packet(code, i)
                    val += sub_val
                    curr_length = i - i0
                end
            elseif type == 1
                val = 1
                while curr_length < subpacket_length
                    i, sub_val = parse_packet(code, i)
                    val *= sub_val
                    curr_length = i - i0
                end
            elseif type == 2
                val = typemax(Int64)
                while curr_length < subpacket_length
                    i, sub_val = parse_packet(code, i)
                    val = sub_val < val ? sub_val : val
                    curr_length = i - i0
                end
            elseif type == 3
                val = typemin(Int64)
                while curr_length < subpacket_length
                    i, sub_val = parse_packet(code, i)
                    val = sub_val > val ? sub_val : val
                    curr_length = i - i0
                end
            elseif type == 5
                comp_vals = []
                while curr_length < subpacket_length
                    i, sub_val = parse_packet(code, i)
                    push!(comp_vals, sub_val)
                    curr_length = i - i0
                end
                val = comp_vals[1] > comp_vals[2] ? 1 : 0
            elseif type == 6
                comp_vals = []
                while curr_length < subpacket_length
                    i, sub_val = parse_packet(code, i)
                    push!(comp_vals, sub_val)
                    curr_length = i - i0
                end
                val = comp_vals[1] < comp_vals[2] ? 1 : 0
            elseif type == 7
                comp_vals = []
                while curr_length < subpacket_length
                    i, sub_val = parse_packet(code, i)
                    push!(comp_vals, sub_val)
                    curr_length = i - i0
                end
                val = comp_vals[1] == comp_vals[2] ? 1 : 0
            else
                error("Wrong type: $type")
            end
        elseif length_type == 1
            n_subpackets = list_to_int(code[i+7:i+17])
            i += 18
            if type == 0
                val = 0
                for n = 1:n_subpackets
                    i, sub_val = parse_packet(code, i)
                    val += sub_val
                end
            elseif type == 1
                val = 1
                for n = 1:n_subpackets
                    i, sub_val = parse_packet(code, i)
                    val *= sub_val
                end
            elseif type == 2
                val = typemax(Int64)
                for n = 1:n_subpackets
                    i, sub_val = parse_packet(code, i)
                    val = sub_val < val ? sub_val : val
                end
            elseif type == 3
                val = typemin(Int64)
                for n = 1:n_subpackets
                    i, sub_val = parse_packet(code, i)
                    val = sub_val > val ? sub_val : val
                end
            elseif type == 5
                comp_vals = []
                for n = 1:n_subpackets
                    i, sub_val = parse_packet(code, i)
                    push!(comp_vals, sub_val)
                end
                val = comp_vals[1] > comp_vals[2] ? 1 : 0
            elseif type == 6
                comp_vals = []
                for n = 1:n_subpackets
                    i, sub_val = parse_packet(code, i)
                    push!(comp_vals, sub_val)
                end
                val = comp_vals[1] < comp_vals[2] ? 1 : 0
            elseif type == 7
                comp_vals = []
                for n = 1:n_subpackets
                    i, sub_val = parse_packet(code, i)
                    push!(comp_vals, sub_val)
                end
                val = comp_vals[1] == comp_vals[2] ? 1 : 0
            else
                error("Wrong type: $type")
            end
        else
            error("Wrong length type id $length_type")
        end
        return i, val
    end     
end

begin
    test_input = String[]
    push!(test_input, "C200B40A82")
    push!(test_input, "04005AC33890")
    push!(test_input, "880086C3E88112")
    push!(test_input, "CE00C43D881120")
    push!(test_input, "D8005AC2A8F0")
    push!(test_input, "F600BC2D8F")
    push!(test_input, "9C005AC2F8F0")
    push!(test_input, "9C0141080250320F1802104A08")
end

#code = str_to_bin_list(test_input[8])
code = read_input("16_input.txt")
i, val = parse_packet(code, 1)