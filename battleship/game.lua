local board = require("board")
local parser = require("parser")
local npc = require("npc")

local game = {}

local CONFIG = {
    BOARD_ROWS = 10,
    BOARD_COLUMNS = 10,
    SHIP_COUNT = 5
}

local WINNER = {
    PLAYER = "player",
    NPC = "npc"
}

local function checkVictory(playerBoard, npcBoard)
    if not board.getSize(playerBoard) or not board.getSize(npcBoard) then
        return false, "Invalid grid."
    end

    if board.countShips(npcBoard) == 0 then
        return WINNER.PLAYER
    end

    if board.countShips(playerBoard) == 0 then
        return WINNER.NPC
    end

    return nil
end

local function findWinner(playerBoard, npcBoard)
    local winner, err = checkVictory(playerBoard, npcBoard)

    if winner == false then
        error(err)
    end

    return winner
end

local function printSummary(stats, playerBoard, npcBoard)
    print("--Summary--")
    print(string.format("Player: %d hits, %d misses, %d ships remaining.",
        stats.player.hits, stats.player.misses, board.countShips(playerBoard)))
    print(string.format("NPC: %d hits, %d misses, %d ships remaining.",
        stats.npc.hits, stats.npc.misses, board.countShips(npcBoard)))
end

local function registerResult(side, result)
    if result == board.RESULT.HIT then
        side.hits = side.hits + 1
    else
        side.misses = side.misses + 1
    end
end

local function setupPlayer(grid, quantity)
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

local function playerTurn(npcBoard, stats)
    if type(stats) ~= "table" or type(stats.player) ~= "table" then
        return false, "Invalid stats."
    end

    local rows, columns = board.getSize(npcBoard)
    if not rows then
        return false, columns
    end

    while true do
        local row, columnOrError = parser.readCoordinate(rows, columns, "Attack coordinate (e.g., A1): ")

        if not row then
            return false, columnOrError
        end

        local column = columnOrError
        local ok, result = board.attackBoard(npcBoard, row, column)

        if ok then
            registerResult(stats.player, result)

            local coordinate = board.formatCoordinate(row, column)
            local message
            if result == board.RESULT.HIT then
                message = "You hit an enemy ship at " .. coordinate .. "!"
            else
                message = "You missed at " .. coordinate .. "."
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

local function npcTurn(playerBoard, stats)
    if type(stats) ~= "table" or type(stats.npc) ~= "table" then
        return false, "Invalid stats."
    end

    local row, columnOrError = npc.chooseAttack(playerBoard)

    if not row then
        error("NPC could not choose an attack: " .. columnOrError)
    end

    local column = columnOrError
    local ok, result = board.attackBoard(playerBoard, row, column)

    if not ok then
        error("NPC attack failed: " .. result)
    end

    registerResult(stats.npc, result)

    local coordinate = board.formatCoordinate(row, column)
    local message
    if result == board.RESULT.HIT then
        message = "The NPC attacked " .. coordinate .. " and hit one of your ships!"
    else
        message = "The NPC attacked " .. coordinate .. " and missed."
    end

    print(message)
    return true, result
end

function game.run()
    math.randomseed(os.time())

    local playerBoard, err = board.createBoard(CONFIG.BOARD_ROWS, CONFIG.BOARD_COLUMNS)
    if not playerBoard then
        print(err)
        return false
    end

    local npcBoard
    npcBoard, err = board.createBoard(CONFIG.BOARD_ROWS, CONFIG.BOARD_COLUMNS)
    if not npcBoard then
        print(err)
        return false
    end

    local stats = {
        player = {hits = 0, misses = 0},
        npc = {hits = 0, misses = 0}
    }

    local ok
    ok, err = board.placeShipsRandom(npcBoard, CONFIG.SHIP_COUNT)
    if not ok then
        print(err)
        return false
    end

    ok, err = setupPlayer(playerBoard, CONFIG.SHIP_COUNT)
    if not ok then
        print(err)
        return false
    end

    local winner
    while not winner do
        print()
        printSummary(stats, playerBoard, npcBoard)
        ok, err = board.displayBoards(playerBoard, npcBoard)
        if not ok then
            print(err)
            return false
        end

        ok, err = playerTurn(npcBoard, stats)
        if not ok then
            print(err)
            return false
        end

        winner = findWinner(playerBoard, npcBoard)

        if not winner then
            ok, err = npcTurn(playerBoard, stats)
            if not ok then
                print(err)
                return false
            end

            winner = findWinner(playerBoard, npcBoard)
        end
    end

    print()
    local revealNpcShips = true
    ok, err = board.displayBoards(playerBoard, npcBoard, revealNpcShips)
    if not ok then
        print(err)
        return false
    end

    if winner == WINNER.PLAYER then
        print("You won! All enemy ships were destroyed.")
    else
        print("The NPC won! All your ships were destroyed.")
    end

    printSummary(stats, playerBoard, npcBoard)

    return true
end

return game
