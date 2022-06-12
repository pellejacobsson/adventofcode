function get_boards(filename)
    lines = open(filename) do f
        readlines(f)
    end
    n_boards = Int((length(lines) - 1) / 6)
    draw = [parse(Int, s) for s in split(lines[1], ",")]
    boards = []
    for n = 1:n_boards
        l_start = 3 + (n - 1) * 6
        current_board = zeros(Int, (5, 5))
        for m = 1:5
            line = lines[l_start + m - 1]
            current_board[m, :] = [parse(Int, s) for s in split(line)]
        end
        push!(boards, current_board)
    end
    return draw, boards
end

function check_bingo(board_state)
    vertical = sum(board_state, dims = 1)
    horizontal = sum(board_state, dims = 2)
    if any(vertical .== 5) || any(horizontal .== 5)
        return true
    else
        return false
    end
end

function run_bingo(draw, boards)
    board_states = [falses(5, 5) for n = 1:100]
    bingo = falses(length(boards))
    for (i, number_drawn) in enumerate(draw)
        for (j, (board, board_state)) in enumerate(zip(boards, board_states))
            if number_drawn in board
                idx = findfirst(x -> x == number_drawn, board)
                board_state[idx] = true
            end
            if check_bingo(board_state)
                bingo[j] = true
                if sum(bingo) == length(boards)
                    return i, board, board_state
                end
            end
        end
    end
end

draw, boards = get_boards("4_input.txt")

n_rounds, winning_board, winning_board_state = run_bingo(draw, boards)

out = sum(winning_board[.!winning_board_state]) * draw[n_rounds]