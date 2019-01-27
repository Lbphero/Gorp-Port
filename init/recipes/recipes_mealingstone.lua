local _G = GLOBAL
local CUSTOM_RECIPETABS = _G.CUSTOM_RECIPETABS
local TECH = _G.TECH

AddRecipeTab(
    "MEALING_STONE",
    10,
    "images/inventoryimages/mealingstone.xml",
    "mealingstone.tex",
    nil,
    true
)
_G.STRINGS.TABS.MEALING_STONE = "Mealing Stone"

local flour = AddItemRecipe(
	"flour",
	{
		ModIngredient("wheat", 3),
	},
	CUSTOM_RECIPETABS.MEALING_STONE,
	TECH.MEALING_STONE_THREE,
	"Ground it to dust.",
    "images/inventoryimages.xml",
    1,
	true
)
flour.image = "quagmire_flour.tex"

local salt = AddItemRecipe(
	"salt",
	{
		ModIngredient("saltrock", 1),
	},
	CUSTOM_RECIPETABS.MEALING_STONE,
	TECH.MEALING_STONE_THREE,
	"Seasoning! Finally!",
    "images/inventoryimages.xml",
    3,
	true
)
salt.image = "quagmire_salt.tex"

local spotspice_ground = AddItemRecipe(
    "spotspice_ground",
    {
        ModIngredient("spotspice_sprig", 3),
    },
    CUSTOM_RECIPETABS.MEALING_STONE,
    TECH.MEALING_STONE_THREE,
    "Spot some Spice on my meals.",
    "images/inventoryimages.xml",
    3,
	true
)
spotspice_ground.image = "quagmire_spotspice_ground.tex"
