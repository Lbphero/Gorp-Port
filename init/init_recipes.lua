AddNewTechTree("MEALING_STONE", 3)
AddNewTechTree("TRADING", 3)
AddNewTechTree("TRADING_MERM2", 3)
AddNewTechTree("TRADING_GOATKID", 3)
AddNewTechTree("TRADING_GOATMUM", 3)
AddNewTechTree("TRADING_SWAMPPIG_ELDER", 3)

modimport("init/recipes/recipes_town")
modimport("init/recipes/recipes_farm")
modimport("init/recipes/recipes_mealingstone")
modimport("init/init_traders")
modimport("init/traders/init_gorge_merm_trader")
modimport("init/traders/init_gorge_merm_trader2")
modimport("init/traders/init_gorge_goatkid_trader")
modimport("init/traders/init_gorge_goatmum_trader")
modimport("init/traders/init_gorge_swamppig_elder")

--[[
    Disable the classic cookpot if the option is set to disabled.
--]]
if not GetModConfigBoolean("Classic Cookpot") then
    local _G = GLOBAL
    local AllRecipes = _G.AllRecipes
    AllRecipes["cookpot"] = nil
end
