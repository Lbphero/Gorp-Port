chestfunctions = require("scenarios/chestfunctions")

local contents =
{
    {
        cutgrass = 20,
        twigs = 20,
        rocks = 20,
        log = 20,
    },
    {
        boards = 5,
        cutstone = 5,
        rope = 5,
        pigskin = 5,
    },
    {
        hambat = 1,
        footballhat = 1,
        amulet = 1,
    },
    {
        redgem = 5,
        bluegem = 5,
        goldnugget = 5,
        moonrockcrater = 1,
    },
    {
        cane = 1,
        tophat = 1,
        sewing_kit = 1,
    },
    {
        plate_gold = 2,
        bowl_gold = 2,
        plate_silver = 2,
        bowl_silver = 2,
    },
    {
        seedpacket_wheat = 1,
        seedpacket_garlic = 1,
        seedpacket_tomato = 1,
        seedpacket_onion = 1,
        seedpacket_carrot = 1,
        seedpacket_potato = 1,
        seedpacket_mix = 1,
        fertilizer = 1,
        strawhat = 1,
    },
    {
        spidereggsack = 1,
        silk = 10,
        spidergland = 10,
        monstermeat = 10,
    },
}

local leftoverItems =
{
    cutgrass = 20,
    twigs = 20,
    rocks = 20,
    log = 20,
}

local function GetItems()
    if #contents == 0 then
        return leftoverItems
    end
    local index = math.random(#contents)
    return table.remove(contents, index)
end

local function OnCreate(inst, scenariorunner)
	local itempairs = GetItems()
    local items = {}
    for k, v in pairs(itempairs) do
        for i=1,v do
            table.insert(items, k)
        end
    end
	chestfunctions.AddChestItems(inst, items)
end

return
{
	OnCreate = OnCreate
}
