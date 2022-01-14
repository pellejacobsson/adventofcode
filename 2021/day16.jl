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
        i, value = calc_value(i+6, code)
        return i, ver
    else
        length_type = code[i+6]
        if length_type == 0
            subpacket_length = list_to_int(code[i+7:i+21])
            curr_length = 0
            i += 22
            i0 = i
            while curr_length < subpacket_length
                i, sub_ver = parse_packet(code, i)
                ver += sub_ver
                curr_length = i - i0
            end
            return i, ver
        elseif length_type == 1
            n_subpackets = list_to_int(code[i+7:i+17])
            i += 18
            for n = 1:n_subpackets
                i, sub_ver = parse_packet(code, i)
                ver += sub_ver
            end
            return i, ver
        else
            error("Wrong length type id $length_type")
        end
    end     
end

begin
    test_input = String[]
    push!(test_input, "D2FE28")
    push!(test_input, "38006F45291200")
    push!(test_input, "EE00D40C823060")
    push!(test_input, "8A004A801A8002F478")
    push!(test_input, "620080001611562C8802118E34")
    push!(test_input, "C0015000016115A2E0802F182340")
    push!(test_input, "A0016C880162017C3686B18A3D4780")
end

#code = str_to_bin_list(test_input[7])
code = read_input("16_input.txt")
i, ver = parse_packet(code, 1)