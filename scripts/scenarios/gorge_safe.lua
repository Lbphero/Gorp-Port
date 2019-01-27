chestfunctions = require("scenarios/chestfunctions")

local contents =
{
    {
        "plate_silver",
        "bowl_silver",
        "plate_silver",
        "bowl_silver",
        "casseroledish",
    },
    {
        "plate_silver",
        "bowl_silver",
        "pot_small",
        "pot_syrup",
    },
    {
        "plate_gold",
        "bowl_gold",
        "syrup",
        "syrup",
        "syrup",
    },
}

local leftoverItems =
{
    "plate_silver",
    "bowl_silver",
    "plate_silver",
    "bowl_silver",
}

local function GetItems()
    if #contents == 0 then
        return leftoverItems
    end
    local index = math.random(#contents)
    return table.remove(contents, index)
end

local function OnCreate(inst, scenariorunner)
	local items = GetItems()
	chestfunctions.AddChestItems(inst, items)
end

return
{
	OnCreate = OnCreate
}
