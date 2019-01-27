local _G = GLOBAL
local CUSTOM_RECIPETABS = _G.CUSTOM_RECIPETABS
local TECH = _G.TECH
local STRINGS = _G.STRINGS

TraderManager = Class(function(self, name, atlas, image)
    self.tab = AddRecipeTab(
        name,
        10,
        atlas or "images/inventoryimages.xml",
        image or "quagmire_coin1.tex",
        nil,
        true
    )
    self.tab.shop = true
    -- AddNewTechTree(name, 3)
    self.tech = TECH[name .. "_THREE"]
    _G.STRINGS.TABS[name] = "Trading"
end)

function TraderManager:Add(prefab, cost, description, atlas, image, numtogive, productdescr)
    local recipe = AddTraderItem(
        prefab .. "_trading",
        cost,
        self.tab,
        self.tech,
        description,
        atlas,
        image,
        numtogive,
        true
    )
    recipe.product = prefab

    -- Dirty copy trick. Pretend you didn't see this.
    if productdescr then
        STRINGS.RECIPE_DESC[string.upper(prefab)] = description
        STRINGS.NAMES[string.upper(prefab) .. "_trading"] = STRINGS.NAMES[string.upper(prefab)]
    end
end

function TraderManager:AddSeedPacket(plantable, id)
    local postfix = id and tostring(id) or plantable
    self:Add(
        "seedpacket_" .. plantable,
        1,
        "A packet of " .. plantable .. " seeds",
        "images/inventoryimages.xml",
        "quagmire_seedpacket_" .. postfix .. ".tex",
        1
    )
end

function TraderManager:AddCookerBundle(prefab, cost)
    self:Add(
        "crate_" .. prefab,
        cost,
        "A bundle with cookerware",
        "images/inventoryimages.xml",
        "quagmire_crate_" .. prefab .. ".tex",
        1
    )
end

return TraderManager
