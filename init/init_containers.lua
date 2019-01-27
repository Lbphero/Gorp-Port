local _G = GLOBAL
_G.require("vector3")
local containers = _G.require("containers")
local cooking = _G.require("cooking")
local Vector3 = _G.Vector3

local function DefaultItemTestFn(container, item, slot)
    return (cooking.IsCookingIngredient(item.prefab) or item:HasTag("preparedfood") or item.prefab == "wetgoop") and not container.inst:HasTag("burnt")
end

local function SyrupItemTestFn(container, item, slot)
    return (item.prefab == "syrup" or item.prefab == "sap" or item.prefab == "wetgoop") and not container.inst:HasTag("burnt")
end

local cookertypes =
{
    large =
    {
        widget =
        {
            slotpos =
            {
                Vector3(0, 64 + 32 + 8 + 4, 0),
                Vector3(0, 32 + 4, 0),
                Vector3(0, -(32 + 4), 0),
                Vector3(0, -(64 + 32 + 8 + 4), 0),
            },
            animbank = "quagmire_ui_pot_1x4",
            animbuild = "quagmire_ui_pot_1x4",
            pos = Vector3(200, 0, 0),
            side_align_tip = 100,
        },
        acceptsstacks = false,
        type = "cooker",
        itemtestfn = DefaultItemTestFn,
    },
    small =
    {
        widget =
        {
            slotpos =
            {
                Vector3(0, 64 + 8, 0),
                Vector3(0, 0, 0),
                Vector3(0, -(64 + 8), 0),
            },
            animbank = "quagmire_ui_pot_1x3",
            animbuild = "quagmire_ui_pot_1x3",
            pos = Vector3(200, 0, 0),
            side_align_tip = 100,
        },
        acceptsstacks = false,
        type = "cooker",
        itemtestfn = DefaultItemTestFn,
    },
    pot_syrup =
    {
        widget =
        {
            slotpos =
            {
                Vector3(0, 64 + 8, 0),
                Vector3(0, 0, 0),
                Vector3(0, -(64 + 8), 0),
            },
            animbank = "quagmire_ui_pot_1x3",
            animbuild = "quagmire_ui_pot_1x3",
            pos = Vector3(200, 0, 0),
            side_align_tip = 100,
        },
        acceptsstacks = false,
        type = "cooker",
        itemtestfn = SyrupItemTestFn,
    },
}
cookertypes.casseroledish = cookertypes.large
cookertypes.casseroledish_small = cookertypes.small
cookertypes.pot = cookertypes.large
cookertypes.pot_small = cookertypes.small
cookertypes.grill = cookertypes.large
cookertypes.grill_small = cookertypes.small
cookertypes.firepit = cookertypes.large -- Hack

local oldwidgetsetup = containers.widgetsetup
containers.widgetsetup = function(container, prefab, data)
    prefab = prefab or container.inst.prefab
    data = cookertypes[prefab] or data
    oldwidgetsetup(container, prefab, data)
end
