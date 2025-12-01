import marimo

__generated_with = "0.18.1"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    return


@app.function
def get_input(filename):
    with open(filename, "r") as _f:
        moves = []
        for line in _f.readlines():
            moves.append([line[0], int(line[1:])])
    return moves


@app.function
def part1(moves, pos=50):
    n_zeros = 0
    for dir, n_steps in moves:
        if dir == "R":
            pos = (pos + n_steps) % 100
        else:
            pos = (pos - n_steps) % 100
        if pos == 0:
            n_zeros += 1
    return n_zeros


@app.cell
def _():
    _moves = get_input("input/01_input.txt")
    part1(_moves)
    return


@app.function
def part2(moves, pos=50):
    n_zeros = 0
    for dir, n_steps in moves:
        if dir == "R":
            new_pos = (pos + n_steps)
        else:
            new_pos = (pos - n_steps)
        if new_pos > 99:
            n_zeros += new_pos // 100
            if new_pos % 100 == 0:
                n_zeros -= 1
        elif new_pos < 0:
            n_zeros += -(new_pos // 100)
            if pos == 0:
                n_zeros -= 1
        pos = new_pos % 100
        if pos == 0:
            n_zeros += 1
    return n_zeros


@app.cell
def _():
    _moves = get_input("input/01_input.txt")
    part2(_moves)
    return


@app.cell
def _():
    return


if __name__ == "__main__":
    app.run()
