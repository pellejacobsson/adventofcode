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


@app.cell
def _():
    grid, start = read_input("input/07_testinput.txt")
    return grid, start


@app.cell
def _(grid, start):
    i_max = int(max(z.real for z in grid))
    i0 = int(start.real)
    j0 = (start.imag - 1) * 1j
    for i in range(i0, i_max + 1):
        if grid[i0 + j0 + i] == "^":
            print(i0 + j0 + i)
    return


@app.cell
def _(grid):
    grid[12 + 6j]
    return


@app.cell
def _():
    return


if __name__ == "__main__":
    app.run()
