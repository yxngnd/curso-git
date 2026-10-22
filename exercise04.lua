local numbers = {1, 2, 3, 4, 5}

print("Primeiro valor: " .. numbers[1])
print("Ultimo valor: " .. numbers[#numbers])

numbers[2] = 20
numbers[4] = 40

table.insert(numbers, 6)

print("Valores na lista:")
for _, value in ipairs(numbers) do
    print(value)
end

local number = 7
print("Valor para ser adicionado na ultima posicao: " .. number)

table.insert(numbers, number)
print("Ultima posicao da lista: " ..numbers[#numbers])

number = 8
print("Numero alterado: " .. number)
print("Ultima posicao da lista continua: " .. numbers[#numbers])
