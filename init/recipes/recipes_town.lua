local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

AddStructureRecipe(
    "mealingstone",
    {
        Ingredient("cutstone", 2),
        Ingredient("rocks", 2),
    },
    RECIPETABS.TOWN,
    TECH.SCIENCE_ONE,
    "Grind stuff to make other stuff.",
    "images/inventoryimages/mealingstone.xml",
    "mealingstone_placer"
)

local salt_rack = AddItemRecipe(
	"salt_rack_item",
	{
		Ingredient("boards", 2),
        Ingredient("twigs", 3),
        Ingredient("rope", 1),
	},
	RECIPETABS.TOWN,
	TECH.SCIENCE_ONE,
	"Extract Salt from Salty Ponds.",
    "images/inventoryimages.xml",
    1
)
salt_rack.image = "quagmire_salt_rack_item.tex"
