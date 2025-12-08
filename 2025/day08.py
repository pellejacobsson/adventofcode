import marimo

__generated_with = "0.18.3"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    from math import sqrt, prod
    import networkx as nx
    return nx, prod, sqrt


@app.function
def read_input(filename):
    boxes = []
    with open(filename) as f:
        for line in f:
            boxes.append([int(n) for n in line.strip().split(",")])

    return boxes


@app.cell
def _(sqrt):
    def calc_dist(boxes):
        dist = {}
        for i, (x1, y1, z1) in enumerate(boxes):
            for j, (x2, y2, z2) in enumerate(boxes):
                if i == j or (i, j) in dist or (j, i) in dist:
                    continue
                dist[i, j] = sqrt((x2 - x1)**2 + (y2 - y1)**2 + (z2 - z1)**2)

        return dist
    return (calc_dist,)


@app.cell
def _(calc_dist):
    boxes = read_input("input/08_testinput.txt")
    dist = calc_dist(boxes)
    return boxes, dist


@app.cell
def _(nx, prod):
    def part1(dist, n=1000):
        pairs = [(i, j) for (i, j), d in sorted(dist.items(), key=lambda x: x[1])]
        G = nx.Graph()
        G.add_edges_from(pairs[:n])
        circuits = list(nx.connected_components(G))
        res = prod(sorted(list(set([len(s) for s in circuits])), reverse=True)[:3])

        return res
    return (part1,)


@app.cell
def _(dist, part1):
    part1(dist)
    return


@app.cell
def _(boxes, nx):
    def part2(dist):
        pairs = [(i, j) for (i, j), d in sorted(dist.items(), key=lambda x: x[1])]
        G = nx.Graph()
        first = True
        for pair in pairs:
            G.add_edges_from([pair])
            print(G)
            circuit = list(nx.connected_components(G))
            if not first and len(circuit) == 1:
                break
            first = False
        res = boxes[pair[0]][0] * boxes[pair[0]][0]

        return res
    
    return (part2,)


@app.cell
def _(dist, part2):
    part2(dist)
    return


@app.cell
def _():
    return


if __name__ == "__main__":
    app.run()
