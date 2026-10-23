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

function arena.displayArena(arena)
    io.write("   ")
    for col = 1, #arena[1] do
        io.write(string.format("%2d   ", col))
    end

    print()

    for row = 1, #arena do
        io.write(string.char(64 + row) .. " | ")
        for col = 1, #arena[row] do
            io.write(string.format("%2s | ", arena[row][col]))
        end
        print()
    end
end

return arena
