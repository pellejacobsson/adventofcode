function read_input(filename)
    lines = open(filename) do f
        readlines(f)
    end
    m = zeros(Int, length(lines), length(lines[1]))
    for (i, line) in enumerate(lines)
        m[i, [l == '>' for l in line]] .= 1
        m[i, [l == 'v' for l in line]] .= 2
    end
    return m
end

function get_next_pos(m, i, j)
    i_max, j_max = size(m)
    if m[i, j] == 1
        i_new = i
        j_new = j == j_max ? 1 : j + 1
    elseif m[i, j] == 2
        i_new = i == i_max ? 1 : i + 1
        j_new = j
    end
    return i_new, j_new
end

function step(m)
    m_new = copy(m)
    i_max, j_max = size(m)
    movement = false
    for i = 1:size(m, 1), j = 1:size(m, 2)
        if m[i, j] == 1
            j_next = j == j_max ? 1 : j + 1
            if m[i, j_next] == 0
                m_new[i, j_next] = 1
                m_new[i, j] = 0
                movement = true
            end
        end
    end
    m = copy(m_new)
    m_new = copy(m)
    for i = 1:size(m, 1), j = 1:size(m, 2)
        if m[i, j] == 2
            i_next = i == i_max ? 1 : i + 1
            if m[i_next, j] == 0
                m_new[i_next, j] = 2
                m_new[i, j] = 0
                movement = true
            end
        end
    end
    return movement, m_new
end

function runit(filename)
    m = read_input(filename)
    movement = true
    steps = 0
    while movement
        steps += 1
        movement, m = step(m)
    end
    return steps
end

out = runit("25_input.txt")