import marimo

__generated_with = "0.18.2"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    return


@app.cell
def _():
    def read_input(filename):
        ranges = []
        with open(filename) as f:
            id_ranges, ids = f.read().split("\n\n")
        for line in id_ranges.split("\n"):
            start, end = [int(n) for n in line.strip().split("-")]
            ranges.append([start, end])
        ids = [int(n) for n in ids.strip().split("\n")]

        return ranges, ids

    def merge_ranges(ranges):
        merged_ranges = []
        for start, end in sorted(ranges, key=lambda x: x[0]):
            if not merged_ranges:
                merged_ranges.append([start, end])
                continue
            last_start, last_end = merged_ranges[-1]
            if start <= last_end:
                new_end = max(last_end, end)
                merged_ranges[-1] = [last_start, new_end]
            else:
                merged_ranges.append([start, end])

        return merged_ranges
    return merge_ranges, read_input


@app.function
def part1(ranges, ids):
    count = 0
    for id in ids:
        for start, end in ranges:
            if start <= id <= end:
                count += 1
                break
    return count


@app.cell
def _(merge_ranges, read_input):
    ranges, ids = read_input("2025/input/05_input.txt")
    ranges = merge_ranges(ranges)
    part1(ranges, ids)
    return (ranges,)


@app.function
def part2(ranges):
    count = 0
    for start, end in ranges:
        count += end - start + 1

    return count


@app.cell
def _(ranges):
    part2(ranges)
    return


if __name__ == "__main__":
    app.run()
