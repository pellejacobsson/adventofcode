import marimo

__generated_with = "0.18.1"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    return


@app.function
def read_input(filename):
    with open(filename, "r") as f:
        input = [[int(n) for n in r.split("-")] for r in f.read().strip().split(",")]
    return input


@app.cell
def _():
    ranges = read_input("input/02_input.txt")
    return (ranges,)


@app.function
def part1(ranges):
    s = 0
    for r1, r2 in ranges:
        for n in range(r1, r2):
            ns = str(n)
            if len(ns) % 2 != 0:
                continue
            l = len(ns) // 2
            if ns[:l] == ns[l:]:
                s += n
    return s


@app.cell
def _(ranges):
    part1(ranges)
    return


@app.function
def part2(ranges):
    s = set()
    for r1, r2 in ranges:
        for n in range(r1, r2 + 1):
            ns = str(n)
            n_len = len(ns)
            n_len2 = n_len // 2
            for step in range(1, n_len2 + 1):
                if n_len % step != 0:
                    continue
                ns_split = [ns[n:n+step] for n in range(0, n_len, step)]
                if all(_s == ns_split[0] for _s in ns_split):
                    s.add(n)
    return s


@app.cell
def _(ranges):
    test_ranges = read_input("input/02_testinput.txt")
    out = part2(ranges)
    sum(out)
    return


if __name__ == "__main__":
    app.run()
