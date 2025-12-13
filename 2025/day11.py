import marimo

__generated_with = "0.18.4"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    from collections import deque
    from functools import cache
    return (cache,)


@app.function
def read_input(filename):
    devices = {}
    with open(filename) as f:
        for line in f:
            input, output = line.strip().split(": ")
            devices[input] = output.split(" ")

    return devices


@app.cell
def _():
    def n_paths(devices, node):
        if node == "out":
            return 1
        else:
            return sum(n_paths(devices, output) for output in devices[node])

    def part1(devices):
        return n_paths(devices, "you")
    return (part1,)


@app.cell
def _(part1):
    _devices = read_input("input/11_input.txt")
    part1(_devices)
    return


@app.cell
def _(cache):
    def part2(devices):
        @cache
        def dfs(node, collected):
            if node in dacfft:
                collected = collected.union(frozenset([node]))
            if node == "out":
                return 1 if collected == dacfft else 0
    
            return sum(dfs(next_node, collected) for next_node in devices[node])
    
        dacfft = set(["dac", "fft"])
        return dfs("svr", frozenset())
    return (part2,)


@app.cell
def _(part2):
    _devices = read_input("input/11_input.txt")
    part2(_devices)
    return


if __name__ == "__main__":
    app.run()
