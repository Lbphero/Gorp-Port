local AllRecipes = GLOBAL.AllRecipes
local TraderProducts = {}
local cooking = GLOBAL.require("cooking")

--[[
	Other functions
--]]
function AddRecipeWrapped(recipe, ingredients, tab, tech, description, atlas, placer, numtogive)
	description = description or "???"
	atlas = atlas or "images/inventoryimages/" .. recipe .. ".xml"
	placer = placer or nil
	local newRecipe = Recipe(recipe, ingredients, tab, tech, placer)
	newRecipe.atlas = GLOBAL.resolvefilepath(atlas)
	if numtogive then
		newRecipe.numtogive = numtogive
	end
	GLOBAL.STRINGS.RECIPE_DESC[string.upper(recipe)] = description
	return newRecipe
end

function AddItemRecipe(recipe, ingredients, tab, tech, description, atlas, numtogive, nounlock)
	local newRecipe = AddRecipeWrapped(recipe, ingredients, tab, tech, description, atlas, nil, numtogive)
	if nounlock then
		newRecipe.nounlock = true
	end
	return newRecipe
end

function AddStructureRecipe(recipe, ingredients, tab, tech, description, atlas, placer, nounlock)
	placer = placer or (recipe .. "_placer")
	local newRecipe = AddRecipeWrapped(recipe, ingredients, tab, tech, description, atlas, placer)
	if nounlock then
		newRecipe.nounlock = true
	end
	return newRecipe
end

function AddLostRecipe(recipe, ingredients, tab, tech, description, atlas, placer)
	atlas = atlas or "images/inventoryimages/pighouse_gray.xml"
	return AddStructureRecipe(recipe, ingredients, tab, tech, description, atlas, placer)
end

function AddMultiPrefabPostInit(prefabs, fn)
	for i,prefab in ipairs(prefabs) do
		AddPrefabPostInit(prefab, fn)
	end
end

function ModIngredient(prefab, count)
	return Ingredient(prefab, count, "images/inventoryimages/" .. prefab .. ".xml")
end

function AddTraderItem(prefab, cost, tab, tech, description, atlas, image, numtogive)
	local product
	if AllRecipes[prefab] then
		local lastid = TraderProducts[prefab] or 0
		local newid = lastid + 1
		TraderProducts[prefab] = newid
		product = "prefab_" .. tostring(newid)
	else
		product = prefab
	end
	local ingredients = {}
	if type(cost) ~= "table" then
		local currencyitem = "coin1"
		local ingredient
		if currencyitem == "goldnugget" then
			ingredient = Ingredient(currencyitem, cost)
		else
			ingredient = ModIngredient(currencyitem, cost)
		end
		ingredients =
		{
			ingredient,
		}
	else
		for k, v in pairs(cost) do
			local ing = ModIngredient(k, v)
			table.insert(ingredients, ing)
		end
	end


	local recipe = AddItemRecipe(product, ingredients, tab, tech, description, atlas, numtogive, true)
	recipe.product = prefab
	if image then
		recipe.image = image
	end
	return recipe
end

local CHARS = {
	"GENERIC",
	"WILLOW",
	"WENDY",
	"WICKERBOTTOM",
	"WX78",
	"WATHGRITHR",
	"WEBBER",
	"WAXWELL",
	"WOODIE",
	"WINONA",
}

function CopyPrefabDescriptions(oldprefab, newprefab)
	for i,character in ipairs(CHARS) do
		if GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE[string.upper(oldprefab)] ~= nil then
			GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE[string.upper(newprefab)] =
				GLOBAL.STRINGS.CHARACTERS[character].DESCRIBE[string.upper(oldprefab)]
		end
	end
end

function UpdateCookingIngredientTags(names, newtags)
	for _, name in ipairs(names) do
		print(name)
		for tag, value in pairs(newtags) do
			cooking.ingredients[name].tags[tag] = value
			if cooking.ingredients[name .. "_cooked"] ~= nil then
				cooking.ingredients[name .. "_cooked"].tags[tag] = value
			end
		end
	end
end
