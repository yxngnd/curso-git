local matrix = {
    {".", ".", "."},
    {".", ".", "."},
    {".", ".", "."}
}

local player = {
    playerName = "Jogador",
    posX = 2,
    posY = 2
}

while true do
    matrix[player.posX][player.posY] = "P"

    for i = 1, #matrix do
        for j = 1, #matrix[i] do
            io.write(matrix[i][j] .. " ")
        end
        io.write("\n")
    end

    io.write("Mover para x = ")
    local newPosX = tonumber(io.read())
    io.write("Mover para y = ")
    local newPosY = tonumber(io.read())

    if newPosX and newPosY
        and newPosX >= 1 and newPosX <= #matrix
        and newPosY >= 1 and newPosY <= #matrix[1] then

        matrix[player.posX][player.posY] = "."
        player.posX = newPosX
        player.posY = newPosY
    else
        print("Posicao invalida! Tente novamente.")
    end
end
