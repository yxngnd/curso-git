local arena = {}

function arena.createArena(rows, columns)
    local newArena = {}
    for i = 1, rows do
        newArena[i] = {}
        for j = 1, columns do
            newArena[i][j] = " "
        end
    end
    return newArena
end

function arena.displayArena(playerArena, npcArena)
    io.write("    ")
    for col = 1, #playerArena[1] do
        io.write(string.format("%2d   ", col))
    end

    io.write("             ")

    for col = 1, #npcArena[1] do
        io.write(string.format("%2d   ", col))
    end

    print()

    for row = 1, math.max(#playerArena, #npcArena) do
        io.write(string.char(64 + row) .. " | ")
        for col = 1, #playerArena[row] do
            io.write(string.format("%2s | ", playerArena[row][col]))
        end

        io.write("         ")
        io.write(string.char(64 + row) .. " | ")
        for col = 1, #npcArena[row] do
            io.write(string.format("%2s | ", npcArena[row][col]))
        end

        print()
    end
end

return arena
