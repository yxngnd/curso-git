local parser = {}

local FIRST_LETTER_CODE = string.byte("A")

local function trim(text)
    return string.match(text, "^%s*(.-)%s*$")
end

function parser.parseCoordinate(input, maxRows, maxColumns)
    if type(input) ~= "string" then
        return false, "Input must be text."
    end

    if math.type(maxRows) ~= "integer" or math.type(maxColumns) ~= "integer" then
        return false, "Invalid board size."
    end

    local text = string.upper(trim(input))
    local letter, digits = string.match(text, "^([A-Z])(%d+)$")

    if not letter then
        return false, "Invalid format. Use a letter + number combination."
    end

    local row = string.byte(letter) - FIRST_LETTER_CODE + 1
    local column = math.tointeger(tonumber(digits))

    if row > maxRows then
        return false, "Row '" .. letter .. "' is outside the board."
    end

    if column < 1 or column > maxColumns then
        return false, "Columns must be between 1 and " .. maxColumns .. "."
    end

    return row, column
end

function parser.readCoordinate(maxRows, maxColumns)
    while true do
        io.write("Enter the coordinate (e.g., A1): ")
        local line = io.read()

        if line == nil then
            return false, "End of input."
        end

        local row, columnOrError = parser.parseCoordinate(line, maxRows, maxColumns)

        if row then
            return row, columnOrError
        end

        print(columnOrError)
    end
end

return parser
