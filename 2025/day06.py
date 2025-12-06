import marimo

__generated_with = "0.18.2"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    from math import prod
    import re
    return (prod,)


@app.function
def read_input(filename):
    with open(filename) as f:
        lines = f.readlines()
    numbers = [[int(n) for n in line.strip().split()] for line in lines[:-1]]
    operations = lines[-1].strip().split()
    return numbers, operations


@app.cell
def _(prod):
    def part1(numbers, operations):
        s = 0
        for ns, op in zip(list(zip(*numbers)), operations):
            if op == "+":
                s += sum(ns)
            elif op == "*":
                s += prod(ns)
            else:
                print(f"Wrong operator: {op}")

        return s
    return (part1,)


@app.cell
def _(part1):
    numbers, operations = read_input("input/06_input.txt")
    part1(numbers, operations)
    return


@app.cell
def _(prod):
    def read_input2(filename):
        grid = {}
        all_empties = []
        with open(filename) as f:
            for i, line in enumerate(f.readlines()):
                empties = []
                for j, s in enumerate(line.strip("\n")):
                    grid[i, j] = s
                    if s == " ":
                        empties.append(j)
                all_empties.append(empties)

        seps = set.intersection(*[set(l) for l in all_empties[:-1]])

        return grid, seps

    def part2(grid, seps):
        j_max = max(grid, key=lambda x: x[1])[1]
        i_max = max(grid, key=lambda x: x[0])[0]
        sseps = [-1] + sorted(list(seps)) + [j_max + 1]
        operations = [grid[i_max, j] for j in range(j_max) if grid[i_max, j] != " "]
    
        s = 0
        for op, sep1, sep2 in zip(operations, sseps, sseps[1:]):
            numbers = []
            for j in range(sep2 - 1, sep1, -1):
                numbers.append(int("".join(grid[i, j] for i in range(i_max))))
            if op == "+":
                s += sum(numbers)
            elif op == "*":
                s += prod(numbers)
            else:
                print(f"Wrong operator: {op}")

        return s
    return part2, read_input2


@app.cell
def _(part2, read_input2):
    grid, seps = read_input2("input/06_input.txt")
    part2(grid, seps)
    return


if __name__ == "__main__":
    app.run()
