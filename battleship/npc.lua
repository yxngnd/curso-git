local board = require("board")

local npc = {}

function npc.chooseAttack(grid)
    local attackableCells = board.getAttackableCells(grid)

    if #attackableCells == 0 then
        return false, "No cells left."
    end

    local choice = attackableCells[math.random(#attackableCells)]

    return choice.row, choice.column
end

return npc
