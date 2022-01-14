function read_input(filename)
    lines = open(filename) do f
        readlines(f)
    end
    code = Int8.([l == '#' for l in lines[1]])
    image = zeros(Int8, (length(lines) - 2, length(lines[3])))
    for i in 1:length(lines)-2, j in 1:length(lines[3])
        image[i, j] = lines[i+2][j] == '#'
    end
    return code, image
end

function pad_image(image; value = 0)
    if value == 0
        new_image = zeros(Int8, size(image, 1) + 4, size(image, 2) + 4)
    else
        new_image = ones(Int8, size(image, 1) + 4, size(image, 2) + 4)
    end
    new_image[3:end-2, 3:end-2] = image
    return new_image
end

function matrix_to_int(m)
    flat = collect(vec(m'))
    value = parse(Int, join(string.(flat)), base = 2)
    return value
end

function step(image, code, n)
    if n % 2 == 0
        image = pad_image(image, value = 1)
        new_image = zeros(Int8, size(image))
    else
        image = pad_image(image)
        new_image = ones(Int8, size(image))
    end
    for i in 2:size(new_image, 1)-1, j in 2:size(new_image, 2)-1
        val = matrix_to_int(image[i-1:i+1, j-1:j+1])
        new_image[i, j] = code[val + 1]
    end
    new_image = new_image[2:end-1, 2:end-1]
    return new_image
end

function runit(filename, n_steps)
    code, image = read_input(filename)
    for n = 1:n_steps
        image = step(image, code, n)
    end
    return image
end

image = runit("20_input.txt", 50)

out = sum(image)