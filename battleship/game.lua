local board = require("board")
local parser = require("parser")

local game = {}

local CONFIG = {
    BOARD_ROWS = 10,
    BOARD_COLUMNS = 10,
    SHIP_COUNT = 5
}

local function registerResult(side, result)
    if result == board.RESULT.HIT then
        side.hits = side.hits + 1
    else
        side.misses = side.misses + 1
    end
end

function game.setupPlayer(grid, quantity)
    if math.type(quantity) ~= "integer" or quantity <= 0 then
        return false, "Quantity of ships must be an integer greater than 0."
    end

    local rows, columns = board.getSize(grid)
    if not rows then
        return false, columns
    end

    if quantity > rows * columns then
        return false, "Too many ships."
    end

    local placed = 0
    board.displaySingleBoard(grid)

    while placed < quantity do
        print(string.format("Ship %d of %d.", placed + 1, quantity))
        local row, columnOrError = parser.readCoordinate(rows, columns, "Ship position (e.g., A1): ")

        if not row then
            return false, columnOrError
        end

        local ok, err = board.placeShip(grid, row, columnOrError)

        if ok then
            placed = placed + 1
            board.displaySingleBoard(grid)
        else
            print(err .. " Try again.")
        end
    end

    return true
end

function game.playerTurn(npcGrid, stats)
    if type(stats) ~= "table" or type(stats.player) ~= "table" then
        return false, "Invalid stats."
    end

    local rows, columns = board.getSize(npcGrid)

    if not rows then
        return false, columns
    end

    while true do
        local row, columnOrError = parser.readCoordinate(rows, columns, "Attack coordinate (e.g., A1): ")

        if not row then
            return false, columnOrError
        end

        local column = columnOrError
        local ok, result = board.attackBoard(npcGrid, row, column)

        if ok then
            registerResult(stats.player, result)

            local message
            if result == board.RESULT.HIT then
                message = "You hit an enemy ship!"
            else
                message = "You missed."
            end

            print(message)
            return true, result
        end

        if result == board.RESULT.ALREADY_ATTACKED then
            print("You already attacked this position. Try again.")
        else
            print(result)
        end
    end
end

function game.npcTurn(playerGrid, stats)

end

function game.checkVictory(playerGrid, npcGrid)

end

function game.run()
    local playerBoard = board.createBoard(CONFIG.BOARD_ROWS, CONFIG.BOARD_COLUMNS)
    local npcBoard = board.createBoard(CONFIG.BOARD_ROWS, CONFIG.BOARD_COLUMNS)
    local stats = {
        player = {hits = 0, misses = 0},
        npc = {hits = 0, misses = 0}
    }
end
