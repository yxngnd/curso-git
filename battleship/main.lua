local board = require("board")
local parser = require("parser")

math.randomseed(os.time())

local command = string.upper(io.read())

local column = string.byte(string.sub(command, 1, 1)) - 64
local row = tonumber(string.sub(command, 2))

print("Command: " .. command)
print("Column: " .. column)
print("Row: " .. row)


while true do
    local playerBoard = board.createBoard(10, 10)
    local npcBoard = board.createBoard(10, 10)

    board.displayBoard(playerBoard, npcBoard)
end
