local _G = GLOBAL

--[[
	New ingredients
--]]
local cookers =
{
	grill = {"grill", "grill_small"},
	oven = {"oven"},
	pot = {"pot"},
}

local function AddCookerRecipeForCookers(recipe, data, cookers)
	for _,cookerprefabs in pairs(cookers) do
		for _,cookerprefab in ipairs(cookerprefabs) do
			AddCookerRecipe(cookerprefab, data)
		end
	end
end

AddIngredientValues({"spotspice_ground"}, {spice=1}, true, false)
AddIngredientValues({"syrup"}, {sweetener=2}, true, false)
AddIngredientValues({"salmon"}, {fish=1}, true, false)
AddIngredientValues({"crabmeat"}, {fish=0.5, crab=1}, true, false)
AddIngredientValues({"tomato", "potato", "turnip", "garlic", "onion"}, {veggie=1}, true, false)
AddIngredientValues({"flour"}, {flour=1}, true, false)
AddIngredientValues({"rocks"}, {rocks=1}, true, false)
AddIngredientValues({"sap"}, {}, true, false)
AddIngredientValues({"gorge_goatmilk"}, {dairy=1}, true, false)
AddIngredientValues({"foliage"}, {}, true, false)
AddIngredientValues({"gorge_mushrooms"}, {mushroom=1, veggie=0.5}, true, false)
UpdateCookingIngredientTags({"red_cap", "green_cap", "blue_cap"}, {mushroom=1})
UpdateCookingIngredientTags({"smallmeat", "smallmeat_dried", "drumstick", "froglegs"}, {smallmeat=1})
UpdateCookingIngredientTags({"meat", "monstermeat"}, {bigmeat=1})

AddCookerRecipe(
	"pot",
	{
		name = "syrup",
		test = function(cooker, names, tags)
			return names.sap and names.sap >= 3
		end,
		priority = 1,
		weight = 1,
		foodtype = "GENERIC",
		health = 10,
		hunger = 5,
		sanity = 10,
		perishtime = TUNING.PERISH_SLOW,
		cooktime = 2,
		tags = {},
	}
)

local preparedFoods = GLOBAL.require("gorge_foods")

AddCookerRecipeForCookers(
	"wetgoop",
	{
		name = "wetgoop",
		test = function(cooker, names, tags)
			return true
		end,
		priority = -1,
		weight = 1,
		foodtype = "GENERIC",
		perishtime = TUNING.PERISH_SLOW,
		cooktime = 2,
		health = 0,
		hunger = 0,
		sanity = 0,
		perishtime = TUNING.PERISH_SLOW,
		cookers = {"grill", "oven", "pot", "pot_syrup"},
		tags = {},
	},
	cookers
)

local GNAW_REWARDS = {}

for k,v in pairs(preparedFoods) do
	GNAW_REWARDS[k] = v.reward
	if v.cookers then
		for i,cookertype in ipairs(v.cookers) do
			for i, cookerprefab in ipairs(cookers[cookertype] or {}) do
				AddCookerRecipe(cookerprefab, v)
			end
		end
	else
		AddCookerRecipe("cookpot", v)
	end
end

_G.GNAW_REWARDS = GNAW_REWARDS
