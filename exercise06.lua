local users = {}

local CONFIG = {
    MIN_NAME_LENGTH = 4,
    MIN_AGE = 18
}

local function verifyUser(user)

    if type(user.name) ~= "string" then
        return false, "Nome deve ser um texto."
    end

    if type(user.age) ~= "number" then
        return false, "Idade deve ser um número."
    end

    if #user.name < CONFIG.MIN_NAME_LENGTH then
        return false, "Nome deve ter no minimo 4 caracteres."
    end

    if user.age < CONFIG.MIN_AGE then
        return false, "Idade deve ser maior ou igual a 18 anos."
    end

    return true, nil
end

local function addUser(name, age)
    local user = {
        name = name,
        age = age
    }
    local isValid, errorMessage = verifyUser(user)
    if not isValid then
        print("Erro: " .. errorMessage)
        return
    else
        table.insert(users, user)
    end
end

local function showUsers()
    if #users == 0 then
        print("Nenhum usuario cadastrado.")
        return
    end

    print("Usuarios cadastrados:")
    for index, user in ipairs(users) do
        print(index .. " - Nome: " .. user.name .. " - Idade: " .. user.age)
    end
end

local function removeUser(index)
    if(index < 1 or index > #users) then
        print("Indice invalido.")
        return
    end
    local removedUser =table.remove(users, index)
    print("Usuario ".. removedUser.name .. " foi removido com sucesso.")
end

addUser("Joao", 20)
addUser("Maria", 25)
addUser("Jose", 72)
addUser("Pedro", 17)
addUser("Ana", 20)
showUsers()
removeUser(2)
showUsers()
