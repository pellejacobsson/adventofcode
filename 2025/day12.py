import marimo

__generated_with = "0.18.4"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    import re
    return (re,)


@app.cell
def _(re):
    def read_input(filename):
        with open(filename) as f:
            parts = f.read().split("\n\n")
        shapes = []
        for part in parts[:-1]:
            shapes.append(part.split()[1:])
        areas = [[int(n) for n in re.findall(r"\d+", s)] for s in parts[-1].strip().split("\n")]
    
        return shapes, areas
    return (read_input,)


@app.function
def part1(shapes, areas):
    n_pieces = [sum(s == "#" for ss in shape for s in ss) for shape in shapes]
    count = 0
    for area in areas:
        area_size = area[0] * area[1]
        n_tiles = area[2:]
        area_needed = sum(x * y for x, y in zip(n_tiles, n_pieces))
        if area_needed <= area_size:
            count += 1
    
    return count


@app.cell
def _(read_input):
    shapes, areas = read_input("input/12_input.txt")
    part1(shapes, areas)
    return


if __name__ == "__main__":
    app.run()
