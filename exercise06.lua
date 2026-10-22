local users = {}

local function verifyUser(user)
    if #user.name < 4 then
        return false, "Nome deve ter no mínimo 4 caracteres."
    end

    if user.age < 18 then
        return false, "Idade deve ser maior ou igual a 18 anos."
    end

    return true, nil
end

local function addUser(user)
    io.write("Nome: ")
    local name = io.read()
    io.write("Idade: ")
    local age = tonumber(io.read())
    local user = { name = name, age = age }
    local isValid, errorMessage = verifyUser(user)
    if not isValid then
        print("Erro: " .. errorMessage)
        return
    else
        users.insert(user)
    end
end

local function showUsers()

end

local function removeUser(index)
    table.remove(users, index)
end
