local board = {}

local FIRST_LETTER_CODE = string.byte("A")
board.CELL = {
    WATER = " ",
    SHIP = "S",
    HIT = "X",
    MISS = "O"
}

board.RESULT = {
    HIT = "hit",
    MISS = "miss",
    ALREADY_ATTACKED = "already_attacked"
}

local LAYOUT = {
    HEADER_INDENT = string.rep(" ", 4),
    HEADER_GAP = string.rep(" ", 9 + 4),
    ROW_GAP = string.rep(" ", 9),
    HEADER_FORMAT = "%2d   ",
    CELL_FORMAT = "%2s | ",
    ROW_PREFIX = " | "
}

local CONFIG = {
    MIN_BOARD_SIZE = 1,
    MAX_BOARD_SIZE = 10
}

local function isValidGrid(grid)
    return type(grid) == "table" and #grid > 0 and type(grid[1]) == "table" and #grid[1] > 0
end

local function isInside(grid, row, column)
    if not isValidGrid(grid) then
        return false, "Invalid grid."
    end

    if math.type(row) ~= "integer" or math.type(column) ~= "integer" then
        return false, "Row and column must be integers."
    end

    if row < 1 or row > #grid or column < 1 or column > #grid[1] then
        return false, "Position out of bounds."
    end

    return true
end

local function getVisibleCell(grid, row, column, hideShips)
    local cell = grid[row][column]

    if hideShips and cell == board.CELL.SHIP then
        return board.CELL.WATER
    end

    return cell
end

local function printHeader(grid)
    for col = 1, #grid[1] do
        io.write(string.format(LAYOUT.HEADER_FORMAT, col))
    end
end

local function printRow(grid, row, hideShips)
    io.write(string.char(FIRST_LETTER_CODE + row - 1) .. LAYOUT.ROW_PREFIX)

    for col = 1, #grid[1] do
        io.write(string.format(LAYOUT.CELL_FORMAT, getVisibleCell(grid, row, col, hideShips)))
    end
end

function board.createBoard(rows, columns)
    if math.type(rows) ~= "integer" or math.type(columns) ~= "integer" then
        return nil, "Quantity of rows and columns must be an integer number."
    end

    if rows < CONFIG.MIN_BOARD_SIZE or columns < CONFIG.MIN_BOARD_SIZE or
        rows > CONFIG.MAX_BOARD_SIZE or columns > CONFIG.MAX_BOARD_SIZE then
        return nil, "Board size must be between " .. CONFIG.MIN_BOARD_SIZE .. " and " .. CONFIG.MAX_BOARD_SIZE .. "."
    end

    local newBoard = {}

    for i = 1, rows do
        newBoard[i] = {}
        for j = 1, columns do
            newBoard[i][j] = board.CELL.WATER
        end
    end

    return newBoard
end

function board.displayBoards(playerBoard, npcBoard)
    if not isValidGrid(playerBoard) or not isValidGrid(npcBoard) then
        return false, "Invalid grid."
    end

    if #playerBoard ~= #npcBoard or #playerBoard[1] ~= #npcBoard[1] then
        return false, "Boards must have the same size."
    end

    io.write(LAYOUT.HEADER_INDENT)
    printHeader(playerBoard)
    io.write(LAYOUT.HEADER_GAP)
    printHeader(npcBoard)
    print()

    for row = 1, #playerBoard do
        printRow(playerBoard, row, false)
        io.write(LAYOUT.ROW_GAP)
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

    if grid[row][column] ~= board.CELL.WATER then
        return false, "Position already occupied."
    end

    grid[row][column] = board.CELL.SHIP

    return true
end

function board.placeShipsRandom(grid, quantity)
    if not isValidGrid(grid) then
        return false, "Invalid grid."
    end

    if math.type(quantity) ~= "integer" or quantity <= 0 then
        return false, "Quantity of ships must be an integer greater than 0."
    end

    local rows = #grid
    local columns = #grid[1]

    local free = {}
    for i = 1, rows do
        for j = 1, columns do
            if grid[i][j] == board.CELL.WATER then
                free[#free + 1] = { i, j }
            end
        end
    end

    local total = #free
    if quantity > total then
        return false, "Too many ships."
    end

    for i = 1, quantity do
        local j = math.random(i, total)
        free[i], free[j] = free[j], free[i]

        local row, column = free[i][1], free[i][2]
        grid[row][column] = board.CELL.SHIP
    end

    return true
end

function board.attackBoard(grid, row, column)
    local inside, err = isInside(grid, row, column)

    if not inside then
        return false, err
    end

    local cell = grid[row][column]
    if cell == board.CELL.SHIP then
        grid[row][column] = board.CELL.HIT
        return true, board.RESULT.HIT
    end

    if cell == board.CELL.WATER then
        grid[row][column] = board.CELL.MISS
        return true, board.RESULT.MISS
    end

    return false, board.RESULT.ALREADY_ATTACKED
end

function board.countShips(grid)
    if not isValidGrid(grid) then
        return 0
    end

    local counter = 0

    for i = 1, #grid do
        for j = 1, #grid[i] do
            if grid[i][j] == board.CELL.SHIP then
                counter = counter + 1
            end
        end
    end

    return counter
end

function board.getAttackableCells(grid)
    if not isValidGrid(grid) then
        return {}
    end

    local cells = {}

    for i = 1, #grid do
        local line = grid[i]
        for j = 1, #line do
            local cell = line[j]
            if cell == board.CELL.WATER or cell == board.CELL.SHIP then
                cells[#cells + 1] = { row = i, column = j }
            end
        end
    end

    return cells
end

return board
