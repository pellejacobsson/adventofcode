import marimo

__generated_with = "0.18.4"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    from shapely import Polygon
    return (Polygon,)


@app.function
def read_input(filename):
    with open(filename) as f:
        tiles = [[int(n) for n in line.strip().split(",")] for line in f]

    return tiles


@app.function
def part1(tiles):
    max_area = 0
    for i in range(len(tiles)):
        for j in range(i+1, len(tiles)):
            area = (abs(tiles[j][0] - tiles[i][0]) + 1) * (abs(tiles[j][1] - tiles[i][1]) + 1)
            if area > max_area:
                max_area = area

    return max_area


@app.cell
def _():
    tiles = read_input("input/09_input.txt")
    part1(tiles)
    return (tiles,)


@app.cell
def _(Polygon):
    def part2(tiles):
        p0 = Polygon(tiles)
        max_area = 0
        for i in range(len(tiles)):
            for j in range(i+1, len(tiles)):
                x1, y1 = tiles[i]
                x2, y2 = tiles[j]
                p1 = Polygon([[x1, y1], [x2, y1], [x2, y2], [x1, y2]])
                if p0.covers(p1):
                    area = (abs(x2 - x1) + 1) * (abs(y2 - y1) + 1)
                    if area > max_area:
                        max_area = area

        return max_area
    return (part2,)


@app.cell
def _(part2, tiles):
    part2(tiles)
    return


if __name__ == "__main__":
    app.run()
