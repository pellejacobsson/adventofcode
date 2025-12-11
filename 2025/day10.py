import marimo

__generated_with = "0.18.4"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    import numpy as np
    from itertools import combinations
    from ortools.sat.python import cp_model
    return combinations, cp_model


@app.function
def read_input(filename):
    lights = []
    buttons = []
    voltages = []
    with open(filename) as f:
        for line in f:
            parts = line.strip().split(" ")
            l = [0 if s == "." else 1 for s in parts[0][1:-1]]
            b = [[int(n) for n in s.split(",")] for s in [s[1:-1] for s in parts[1:-1]]]
            v = [int(n) for n in parts[-1][1:-1].split(",")]
            lights.append(l)
            buttons.append(b)
            voltages.append(v)

    return lights, buttons, voltages


@app.cell
def _(combinations):
    def solve1(light, button):
        n_buttons = len(button)
        n_lights = len(light)
        for n_pressed in range(n_buttons + 1):
            for pressed in combinations(range(n_buttons), n_pressed):
                valid = True
                for i in range(n_lights):
                    s = 0
                    for j in pressed:
                        if i in button[j]:
                            s += 1
                    if s % 2 != light[i]:
                        valid = False
                        break
                if valid:
                    return n_pressed

        return None

    def part1(lights, buttons):
        tot = 0
        for light, button in zip(lights, buttons):
            tot += solve1(light, button)

        return tot
    return (part1,)


@app.cell
def _(part1):
    _lights, _buttons, _ = read_input("input/10_input.txt")
    part1(_lights, _buttons)
    return


@app.cell
def _(cp_model):
    def solve_min2(button, joltage):
        num_constraints = len(joltage)
        num_vars = len(button)
        model = cp_model.CpModel()
        max_number = max(joltage)
        x = [model.new_int_var(0, max_number, f'n{i}') for i in range(num_vars)]

        for i in range(num_constraints):
            vars_in_eqn = [x[j] for j in range(num_vars) if i in button[j]]
            model.add(sum(vars_in_eqn) == joltage[i])

        model.minimize(sum(x))
        solver = cp_model.CpSolver()
        status = solver.solve(model)

        return [solver.value(var) for var in x]


    def part2(buttons, joltages):
        tot = 0
        for button, joltage in zip(buttons, joltages):
            res = solve_min2(button, joltage)
            tot += sum(res)

        return tot
    return (part2,)


@app.cell
def _(part2):
    _, _buttons, _joltages = read_input("input/10_input.txt")
    part2(_buttons, _joltages)
    return


if __name__ == "__main__":
    app.run()
