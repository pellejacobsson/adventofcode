import marimo

__generated_with = "0.18.1"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    return


@app.function
def read_input(filename):
    banks = []
    with open(filename) as f:
        for line in f.readlines():
            banks.append(line.strip())
    return banks


@app.cell
def _():
    banks = read_input("input/03_input.txt")
    return (banks,)


@app.cell
def _():
    def bank_max(bank):
        n_max = 0
        n_first = 0
        for i in range(len(bank)):
            if int(bank[i]) < n_first:
                continue
            for j in range(i + 1, len(bank)):
                n = int(bank[i] + bank[j])
                if n > n_max:
                    n_max = n
        return n_max

    def part1(banks):
        s = 0
        for bank in banks:
            s += bank_max(bank)
        return s
    return (part1,)


@app.cell
def _(banks, part1):
    part1(banks)
    return


@app.cell
def _():
    def bmax(subbank, m):
        if m == 0:
            return ""
        bank_len = len(subbank)
        digmax = max(int(n) for i, n in enumerate(subbank) if bank_len - i >= m)
        digmax_i = subbank.index(str(digmax))
        return str(digmax) + bmax(subbank[digmax_i+1:], m - 1)

    def part2(banks):
        return sum(int(bmax(bank, 12)) for bank in banks)
    return (part2,)


@app.cell
def _(banks, part2):
    part2(banks)
    return


@app.cell
def _():
    return


if __name__ == "__main__":
    app.run()
