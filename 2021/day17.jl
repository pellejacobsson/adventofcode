using OffsetArrays
using Colors

function get_target(;test = false)
    if test
        return 20, 30, -10, -5
    else
        return 169, 206, -108, -68
    end
end


function step!(x, y, vx, vy)
    x += vx
    y += vy
    if vx < 0
        vx += 1
    elseif vx > 0
        vx -= 1
    end
    vy -= 1
    return x, y, vx, vy
end

function hit(vx0, vy0, target)
    tx_min, tx_max, ty_min, ty_max = target
    x, y = 0, 0
    vx = vx0
    vy = vy0
    y_max = 0
    while true
        x, y, vx, vy = step!(x, y, vx, vy)
        y_max = y > y_max ? y : y_max
        if tx_min ≤ x ≤ tx_max && ty_min ≤ y ≤ ty_max
            return true, y_max
        elseif x > tx_max || (y < ty_min && vy < 0)
            return false, y_max
        end
    end
end

function hit_matrix(vx0_min, vx0_max, vy0_min, vy0_max, target)
    ncols = vx0_max - vx0_min + 1
    nrows = vy0_max - vy0_min + 1
    m = OffsetArray(zeros(nrows, ncols), vy0_min:vy0_max, vx0_min:vx0_max)
    h = OffsetArray(falses(nrows, ncols), vy0_min:vy0_max, vx0_min:vx0_max)
    for vx0 = vx0_min:vx0_max, vy0 = vy0_min:vy0_max
        did_hit, y_max = hit(vx0, vy0, target)
        if did_hit
            h[vy0, vx0] = true
            m[vy0, vx0] = y_max
        end
    end
    return h, m
end

target = get_target(test = false)

h, m = hit_matrix(-2000, 2000, -2000, 2000, target)

# Part 1
argmax(m)

# Part 2
sum(h)