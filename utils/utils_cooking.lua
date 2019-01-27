local _G = GLOBAL
_G.require("vector3")
local cooking = _G.require("cooking")
local Vector3 = _G.Vector3

local function DefaultItemTestFn(container, item, slot)
    return cooking.IsCookingIngredient(item.prefab) and not container.inst:HasTag("burnt") and
        not (item.prefab == "spoiled_food" or item:HasTag("preparedfood") or item:HasTag("overcooked") or container.inst:HasTag("takeonly"))
end

local function SyrupItemTestFn(container, item, slot)
    return item.prefab == "sap" and not container.inst:HasTag("takeonly")
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

function _G.GetWidgetData(cookertype)
    return cookertypes[cookertype]
end
