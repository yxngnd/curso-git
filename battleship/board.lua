local board = {}

function board.createBoard(rows, columns)
    local newBoard = {}
    for i = 1, rows do
        newBoard[i] = {}
        for j = 1, columns do
            newBoard[i][j] = " "
        end
    end
    return newBoard
end

function board.displayBoard(playerBoard, npcBoard)
    io.write("    ")
    for col = 1, #playerBoard[1] do
        io.write(string.format("%2d   ", col))
    end

    io.write("             ")

    for col = 1, #npcBoard[1] do
        io.write(string.format("%2d   ", col))
    end

    print()

    for row = 1, math.max(#playerBoard, #npcBoard) do
        io.write(string.char(64 + row) .. " | ")
        for col = 1, #playerBoard[row] do
            io.write(string.format("%2s | ", playerBoard[row][col]))
        end

        io.write("         ")
        io.write(string.char(64 + row) .. " | ")
        for col = 1, #npcBoard[row] do
            io.write(string.format("%2s | ", npcBoard[row][col]))
        end

        print()
    end
end

function board.placeShip(board, row, column)
    if not board.isInside(board, row, column) then
        return false, ""
    end

    board[row][column] = " N "
end

function board.placeShipRandom(board, quantity)
end

function board.attackBoard(board, row, column)
end

function board.countShip(board)
    local count = 0
end

function board.isInside(board, row, column)
    if row > #board then
        return false, ""
    end

    if column > #board[1] then
        return false, ""
    end

    return true, nil

end

return board
