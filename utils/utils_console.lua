local _G = GLOBAL

local function c_getfirepit()
    local e = _G.FindEntity(_G.ConsoleCommandPlayer(), 20, function(x) return x.prefab == "firepit" end)
    return e
end

local function c_spawnfirepits(distance)
    distance = distance or 5
    local player = _G.ConsoleCommandPlayer()
    local positions =
    {
        {x = distance, y = 0, z = distance,},
        {x = distance, y = 0, z = -distance,},
        {x = -distance, y = 0, z = distance,},
        {x = -distance, y = 0, z = -distance,},
    }
    local x, y, z = player.Transform:GetWorldPosition()
    for _, position in ipairs(positions) do
        local firepit = _G.SpawnPrefab("firepit")
        firepit.Transform:SetPosition(x + position.x, y + position.y, z + position.z)
    end
end

local function c_spawnfoodchest(x, y, z, prefabs)
    if not prefabs then
        return
    end
    local chest = _G.DebugSpawn("treasurechest")
    if x and y and z then
        chest.Transform:SetPosition(x, y, z)
    end

    for _, prefab in ipairs(prefabs) do
        for i = 1, 40, 1 do
            local item = _G.SpawnPrefab(prefab)
            chest.components.container:GiveItem(item)
        end
    end
end

local function c_debugcooking()
    local c_give = _G.c_give
    local chestprefabs =
    {
        "smallmeat",
        "meat",
        "crabmeat",
        "fish",
        "salmon",
    }
    local chestprefabs2 =
    {
        "turnip",
        "tomato",
        "carrot",
        "onion",
        "garlic",
        "potato",
        "flour",
        "gorge_mushrooms",
        "salt",
    }
    local x, y, z = _G.ConsoleCommandPlayer().Transform:GetWorldPosition()
    c_spawnfoodchest(x + 2.5, y, z, chestprefabs)
    c_spawnfoodchest(x + 5, y, z, chestprefabs2)
    c_spawnfirepits(6)
    c_give("grill_small_item")
    c_give("oven_item")
    c_give("pot_hanger_item")
    c_give("casseroledish")
    c_give("pot")
    c_give("flour", 40)
    c_give("syrup", 40)
    c_give("potato", 40)
    c_give("log", 40)
    c_give("gorge_goatmilk", 40)
    c_give("spotspice_ground", 40)
end

_G.c_spawnfirepits = c_spawnfirepits
_G.c_debugcooking = c_debugcooking
_G.c_spawnfoodchest = c_spawnfoodchest
