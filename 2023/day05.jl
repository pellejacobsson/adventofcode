function read_input(filename)
    input = open(filename) do f
        split(read(f, String), "\n\n")
    end
    seeds = parse.(Int, split(input[1])[2:end])
    map_names
    range_maps = (
        seed_to_soil = [parse.(Int, l) for l in split.(split(input[2], "\n")[2:end])],
        soil_to_fertilizer = [parse.(Int, l) for l in split.(split(input[3], "\n")[2:end])],
        fertilizer_to_water = [parse.(Int, l) for l in split.(split(input[4], "\n")[2:end])],
        water_to_light = [parse.(Int, l) for l in split.(split(input[5], "\n")[2:end])],
        light_to_temperature = [parse.(Int, l) for l in split.(split(input[6], "\n")[2:end])],
        temperature_to_humidity = [parse.(Int, l) for l in split.(split(input[7], "\n")[2:end])],
        humidity_to_location = [parse.(Int, l) for l in split.(split(input[8], "\n")[2:end])],
    )
    seeds, range_maps
end

function source_in_range(source, dest_start, source_start, len)
    if source_start <= source <= source_start + len - 1
        return source - source_start + dest_start
    else
        return 0
    end
end



function seed_to_location(seed, range_maps)
