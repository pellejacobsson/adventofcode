function run_code(input)
    a = [1, 1, 1, 1, 26, 26, 1, 1, 26, 26, 1, 26, 26, 26]
    b = [13, 12, 12, 10, -11, -13, 15, 10, -2, -6, 14, 0, -15, -4]
    c = [8, 13, 8, 10, 12, 1, 13, 5, 10, 3, 2, 2, 12, 7]
    z = 0
    for i = 1:length(input)
        x = z % 26 + b[i]
        if x == input[i]
            z = z ÷ a[i]
        else
            z = 26*(z ÷ a[i]) + input[i] + c[i]
        end
    end
    return z
end

function sweep()
    z = Int64[]
    for i = 1:9
        for j = 1:9
            for k = 1:9
                for l = 1:9
                    for m = 1:9
                        for n = 1:9
                            for p = 1:9
                                input = [5, 9, 9, 9, 8, 4, 2, i, j, k, l, m, n, p]
                                z = run_code(input)
                                if z == 0
                                    @show input
                                    return input
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function sweep2()
    z = Int64[]
    for i = 1:9
        for j = 1:9
            for k = 1:9
                for l = 1:9
                    for m = 1:9
                        for n = 1:9
                            for p = 1:9
                                for q = 1:9
                                    input = [1, 1, 1, 1, 1, 1, i, j, k, l, m, n, p, q]
                                    z = run_code(input)
                                    if z == 0
                                        @show input
                                        return input
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

# Part 1
out = sweep()

# Part 2
out = sweep2()