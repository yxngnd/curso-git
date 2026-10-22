local health = 100
local defense = 15

math.randomseed(os.time())

for i = 1, 5 do
    local attackPower = math.random(10, 30)
    local damageReceived = math.max(0, attackPower - defense)

    print("\nAttack " .. i .. ": " .. attackPower)

    if attackPower > 20 then
        print("Critical hit!")
    end

    health = health - damageReceived

    print("Damage received: " .. damageReceived)
    print("Remaining health: " .. health)

    if health <= 0 then
        break
    end
end

if health <= 0 then
    print("The player has died!")
else
    print("The player survived the attacks. Remaining health: " .. health)
end
