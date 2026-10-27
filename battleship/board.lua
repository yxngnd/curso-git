local board = {}

local FIRST_LETTER_CODE = string.byte("A")
local CELL = {
    WATER = " ",
    SHIP = "S",
    HIT = "X",
    MISS = "O"
}

local LAYOUT = {
    HEADER_INDENT = string.rep(" ", 4),
    HEADER_GAP = string.rep(" ", 13),
    ROW_GAP = string.rep(" ", 9),
    HEADER_FORMAT = "%2d  ",
    CELL_FORMAT = "%2s | ",
    ROW_PREFIX = " | "
}

local function isInside(grid, row, column)

    if type(grid) ~= "table" or #grid == 0 then
        return false
    end

    if type(row) ~= "number" or math.type(row) ~= "integer" then
        return false
    end

    if type(column) ~= "number" or math.type(column) ~= "integer" then
        return false
    end

    if row < 1 or row > #grid or column < 1 or column > #grid[1] then
        return false
    end

    return true
end

local function getVisibleCell(grid, row, column, hideShips)
    local cell = grid[row][column]

    if hideShips and cell == CELL.SHIP then
        return CELL.WATER
    end

    return cell
end

local function printHeader(grid)
    for col = 1, #grid[1] do
        io.write(string.format("%2d   ", col))
    end
end

local function printRow(grid, row, hideShips)
    io.write(string.char(FIRST_LETTER_CODE + row - 1) .. " | ")

    for col = 1, #grid[row] do
        io.write(string.format("%2s | ", getVisibleCell(grid, row, col, hideShips)))
    end
end

function board.createBoard(rows, columns)
    local newBoard = {}

    if math.type(rows) ~= "integer" or math.type(columns) ~= "integer" then
        return nil, "Quantity of rows and columns must be an integer number."
    end

    if rows <= 1 or columns <= 1 then
        return nil, "Board must have more than 1 row/column."
    end

    for i = 1, rows do
        newBoard[i] = {}
        for j = 1, columns do
            newBoard[i][j] = CELL.WATER
        end
    end

    return newBoard
end

function board.displayBoards(playerBoard, npcBoard)
    if not playerBoard or not npcBoard then
        return false, "Empty boards."
    end

    if #playerBoard ~= #npcBoard then
        return false, "Boards must have the same size."
    end

    io.write("    ")
    printHeader(playerBoard)
    io.write("             ")
    printHeader(npcBoard)
    print()

    for row = 1, #playerBoard do
        printRow(playerBoard, row, false)
        io.write("         ")
        printRow(npcBoard, row, true)
        print()
    end

    return true
end

function board.placeShip(grid, row, column)
    local inside, err = isInside(grid, row, column)

    if not inside then
        return false, err
    end

    if grid[row][column] ~= CELL.WATER then
        return false, "Position already occupied."
    end

    grid[row][column] = CELL.SHIP

    return true
end

function board.placeShipRandom(grid, quantity)
    local rows = #grid
    local columns = #grid[1]

    if quantity <= 0 then
        return false, "Quantity of ships must be greater than 0."
    end

    local free = {}
    for i = 1, rows do
        for j = 1, columns do
            if grid[i][j] == CELL.WATER then
                free[#free + 1] = { i, j }
            end
        end
    end

    if quantity > #free then
        return false, "Too many ships."
    end

    -- Fisher-Yates
    for i = 1, quantity do
        local j = math.random(i, #free)
        free[i], free[j] = free[j], free[i]

        local ok, err = board.placeShip(grid, free[i][1], free[i][2])
        if not ok then
            return false, err, i - 1
        end
    end

    return true, quantity
end

function board.attackBoard(grid, row, column)
    local inside, err = isInside(grid, row, column)

    if not inside then
        return false, err
    end

    local cell = grid[row][column]
    if cell == CELL.SHIP then
        grid[row][column] = CELL.HIT
        return true, "hit"
    end

    if cell == CELL.WATER then
        grid[row][column] = CELL.MISS
        return true, "miss"
    end

    return false, "already_attacked"
end

function board.countShips(grid)
    local counter = 0

    for i = 1, #grid do
        for j = 1, #grid[1] do
            if grid[i][j] == CELL.SHIP then
                counter = counter + 1
            end
        end
    end

    return counter
end

return board
