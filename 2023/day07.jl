struct Hand
    cards::AbstractArray
end

struct Hand2
    cards::AbstractArray
end

function read_input(filename)
    card_map = Dict('A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10)
    cards = Tuple{Hand, Int}[]
    open(filename) do f
        for line in readlines(f)
            c, b = split(line)
            c = [x in "AKQJT" ? card_map[x] : parse(Int, x) for x in c]
            b = parse(Int, b)
            push!(cards, (Hand(c), b))
        end
    end
    cards
end

function value(h::Hand)
    val = 0
    sorted_cards = sort(h.cards)
    nunique = length(unique(sorted_cards))
    if nunique == 1 # five of a kind
        val = 7
    elseif nunique == 2 # four of a kind or full house
        val = any(length(unique(sorted_cards[i:i+3])) == 1 for i = 1:2) ? 6 : 5
    elseif nunique == 3 # three of a kind or two pair
        val = any(length(unique(sorted_cards[i:i+2])) == 1 for i = 1:3) ? 4 : 3
    elseif nunique == 4 # pair
        val = 2
    else # high card
        val = 1
    end
    val
end

function value(h::Hand2)
    cards = copy(h.cards)
    j_ix = findall(x -> x == 1, cards)
    length(j_ix) == 0 && return value(Hand(h.cards))
    max_val = 0
    for j_vals in vcat(1:10, 12:14)
        cards[j_ix] .= j_vals
        val = 0
        sorted_cards = sort(cards)
        nunique = length(unique(sorted_cards))
        if nunique == 1 # five of a kind
            val = 7
        elseif nunique == 2 # four of a kind or full house
            val = any(length(unique(sorted_cards[i:i+3])) == 1 for i = 1:2) ? 6 : 5
        elseif nunique == 3 # three of a kind or two pair
            val = any(length(unique(sorted_cards[i:i+2])) == 1 for i = 1:3) ? 4 : 3
        elseif nunique == 4 # pair
            val = 2
        else # high card
            val = 1
        end
        if val > max_val
            max_val = val
        end
    end
    max_val
end

function Base.isless(h1::Hand, h2::Hand)
    if value(h1) == value(h2)
        h1.cards < h2.cards
    elseif value(h1) < value(h2)
        true
    else
        false
    end
end

function Base.isless(h1::Hand2, h2::Hand2)
    if value(h1) == value(h2)
        h1.cards < h2.cards
    elseif value(h1) < value(h2)
        true
    else
        false
    end
end

function solve(cards, part)
    if part == 1
        sum(i * b for (i, (_, b)) in enumerate(sort(cards, by=x -> x[1])))
    else
        cards2 = [(Hand2(replace(h.cards, 11 => 1)), b) for (h, b) in cards]
        sum(i * b for (i, (_, b)) in enumerate(sort(cards2, by=x -> x[1])))
    end
end

function runit(filename; part=1)
    cards = read_input(filename)
    solve(cards, part)
end

runit("07_input.txt")
runit("07_input.txt", part=2)