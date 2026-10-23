while true do
    print("Digite um email:")
    local email = io.read()
    email = string.gsub(email, "%s+", "")
    email = string.lower(email)
    local at = string.find(email, "@", 1, true)

    if at == nil or at == 1 or at == #email or string.find(email, "@", at + 1, true) then
       print("Email invalido")
    else
        print("Email valido")
        local user = string.sub(email, 1, at - 1)
        local domain = string.sub(email, at + 1)
        print("Usuario: " .. user)
        print("Dominio: " .. domain)
    end

    print("Email normalizado: " .. email .. "\n")
end
