local arena = require("arena")

local command = string.upper(io.read())

local column = string.byte(string.sub(command, 1, 1)) - 64
local row = tonumber(string.sub(command, 2))

print("Command: " .. command)
print("Column: " .. column)
print("Row: " .. row)

local playerArena = arena.createArena(10, 10)
local npcArena = arena.createArena(10, 10)

arena.displayArena(playerArena)
print("-----------")
arena.displayArena(npcArena)
