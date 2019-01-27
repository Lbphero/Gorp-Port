local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

local grill_small = AddItemRecipe(
    "grill_small_item",
    {
        Ingredient("rocks", 3),
        Ingredient("twigs", 2),
        Ingredient("charcoal", 3),
    },
    RECIPETABS.FARM,
    TECH.SCIENCE_ONE,
    "A small grill.",
    "images/inventoryimages.xml",
    1
)
grill_small.image = "quagmire_grill_small_item.tex"

local grill = AddItemRecipe(
    "grill_item",
    {
        Ingredient("cutstone", 2),
        Ingredient("charcoal", 9),
		Ingredient("goldnugget", 2),
    },
    RECIPETABS.FARM,
    TECH.SCIENCE_TWO,
    "A bigger grill.",
    "images/inventoryimages.xml",
    1
)
grill.image = "quagmire_grill_item.tex"

local oven = AddItemRecipe(
    "oven_item",
    {
        Ingredient("cutstone", 1),
        Ingredient("charcoal", 8),
    },
    RECIPETABS.FARM,
    TECH.SCIENCE_ONE,
    "A Fired Oven.",
    "images/inventoryimages.xml",
    1
)
oven.image = "quagmire_oven_item.tex"

local casseroledish_small = AddItemRecipe(
    "casseroledish_small",
    {
        Ingredient("cutstone", 1),
    },
    RECIPETABS.FARM,
    TECH.SCIENCE_ONE,
    "A Cozy Casserole Dish.",
    "images/inventoryimages.xml",
    1
)
casseroledish_small.image = "quagmire_casseroledish_small.tex"

local casseroledish = AddItemRecipe(
    "casseroledish",
    {
        Ingredient("cutstone", 2),
    },
    RECIPETABS.FARM,
    TECH.SCIENCE_ONE,
    "A Big Casserole Dish.",
    "images/inventoryimages.xml",
    1
)
casseroledish.image = "quagmire_casseroledish.tex"

local pot_hanger = AddItemRecipe(
    "pot_hanger_item",
    {
        Ingredient("cutstone", 2),
        Ingredient("charcoal", 2),
        Ingredient("rocks", 2),
    },
    RECIPETABS.FARM,
    TECH.SCIENCE_ONE,
    "A Hanger, For Pots.",
    "images/inventoryimages.xml",
    1
)
pot_hanger.image = "quagmire_pot_hanger_item.tex"

local pot_small = AddItemRecipe(
    "pot_small",
    {
        Ingredient("rocks", 3),
        Ingredient("twigs", 2),
    },
    RECIPETABS.FARM,
    TECH.SCIENCE_ONE,
    "A Cozy Lil' Cookpot.",
    "images/inventoryimages.xml",
    1
)
pot_small.image = "quagmire_pot_small.tex"

local pot = AddItemRecipe(
    "pot",
    {
        Ingredient("rocks", 4),
        Ingredient("log", 2),
    },
    RECIPETABS.FARM,
    TECH.SCIENCE_TWO,
    "A Big Pot.",
    "images/inventoryimages.xml",
    1
)
pot.image = "quagmire_pot.tex"

local pot_syrup = AddItemRecipe(
    "pot_syrup",
    {
        Ingredient("rocks", 4),
        Ingredient("goldnugget", 1),
    },
    RECIPETABS.FARM,
    TECH.SCIENCE_ONE,
    "A Pot, For Syrup!",
    "images/inventoryimages.xml",
    1
)
pot_syrup.image = "quagmire_pot_syrup.tex"

local sapbucket = AddItemRecipe(
	"sapbucket",
	{
		Ingredient("goldnugget", 1),
        Ingredient("houndstooth", 3),
	},
	RECIPETABS.FARM,
	TECH.SCIENCE_ONE,
	"Tap Sap from Sugary Trees.",
    "images/inventoryimages.xml",
    3
)
sapbucket.image = "quagmire_sapbucket.tex"