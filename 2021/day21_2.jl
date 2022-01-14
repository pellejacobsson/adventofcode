using OffsetArrays

function get_prev_idx()
    d1 = repeat(1:3, inner = 9)
    d2 = repeat(repeat(1:3, inner = 3), outer = 3)
    d3 = repeat(1:3, outer = 9)
    dsum = d1 + d2 + d3
    return sort(dsum)
end

function update_u(u_prev)
    u = OffsetArray(zeros(Int, 10, 10, 22, 22), (1:10, 1:10, 0:21, 0:21))
    for i = 1:10, j = 1:10, k = i:21, l = j:21
        dice = [3, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 8, 8, 8, 9]
        i_prev = i .- dice
        i_prev[i_prev .< 1] .+= 10
        j_prev = j .- dice
        j_prev[j_prev .< 1] .+= 10
        if k == 21
            k_prev = k-i:20
        else
            k_prev = k - i
        end
        if l == 21
            l_prev = l-j:20
        else
            l_prev = l - j
        end
        u[i, j, k, l] = sum(u_prev[i_prev, j_prev, k_prev, l_prev])
    end
    return u
end

function runit(p1_0, p2_0)
    u = OffsetArray(zeros(Int, 10, 10, 22, 22), (1:10, 1:10, 0:21, 0:21))
    u[p1_0, p2_0, 0, 0] = 1
    p1 = 0
    p2 = 0
    flip = false
    u_tot = 0
    while true
        u = update_u(u)
        if sum(u) == 0
            break
        end
        if !flip
            p1 += sum(u[:, :, 21, :])
            p2 += sum(u[:, :, 0:20, 21])
            flip = true
        else
            p2 += sum(u[:, :, 21, :])
            p1 += sum(u[:, :, 0:20, 21])
            flip = false
        end
        u_tot += sum(u)
    end
    return p1, p2, u_tot
end

p1, p2, u_tot = runit(4, 8)

