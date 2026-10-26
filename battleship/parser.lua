local parser = {}

local FIRST_LETTER_CODE = string.byte("A")

function parser.parseCoordinate(input, maxRows, maxColumns)
    if type(input) ~= "string" then
        return nil
    end

    local letter, digits = string.match(string.upper(input), "^([A-Z])(%d+)$")

    if not letter then
        return nil
    end

    local row = string.byte(letter) - FIRST_LETTER_CODE + 1
    local column = tonumber(digits)

    if row < 1 or row > maxRows or column < 1 or column > maxColumns then
        return nil
    end

    return row, column
end

function parser.readCoordinate(maxRows, maxColumns)
    local row, column

    repeat
        io.write("Enter the coordinate (e.g., A1): ")
        local line = io.read()

        if line == nil then
            return nil
        end

        local input = string.match(line, "^%s*(.-)%s*$")
        row, column = parser.parseCoordinate(input, maxRows, maxColumns)

        if not row then
            print("Invalid coordinate. Use a letter + number combination, within the board.")
        end
    until row

    return row, column
end

return parser
