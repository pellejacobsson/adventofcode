import marimo

__generated_with = "0.18.3"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    return


@app.function
def read_input(filename):
    grid = {}
    with open(filename) as f:
        for row, line in enumerate(f):
            for col, s in enumerate(line.strip()):
                grid[row + col * 1j] = s
                if s == "S":
                    start = row + col * 1j

    return grid, start


@app.function
def part1(grid, start):
    beams = set([start])
    i_max = int(max(z.real for z in grid))
    changed = True
    split = 0
    while changed:
        changed = False
        new_beams = set()
        for beam in beams:
            next_pos = beam + 1
            if next_pos.real > i_max:
                continue
            if grid[next_pos] == ".":
                new_beams.add(next_pos)
                changed = True
            elif grid[next_pos] == "^":
                split += 1
                new_beams.add(next_pos + 1j)
                new_beams.add(next_pos - 1j)
                changed = True
            else:
                print("Wrong character!")
        beams = new_beams

    return split


@app.cell
def _():
    _grid, _start = read_input("input/07_input.txt")
    part1(_grid, _start)
    return


@app.function
def n_paths(grid, i_max, pos, cache):
    if pos in cache:
        return cache[pos]
    for i in range(1, i_max - int(pos.real) + 1):
        if grid[pos + i] == "^":
            l_pos = pos + i - 1j
            r_pos = pos + i + 1j
            res = n_paths(grid, i_max, l_pos, cache) + n_paths(grid, i_max, r_pos, cache)
            cache[pos] = res
            return res
    return 1


@app.cell
def _():
    grid, start = read_input("input/07_input.txt")
    i_max = int(max(z.real for z in grid))
    cache = {}
    n_paths(grid, i_max, start, cache)
    return


if __name__ == "__main__":
    app.run()
