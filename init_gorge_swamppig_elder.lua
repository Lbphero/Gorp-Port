local Trader = TraderManager("TRADING_SWAMPPIG_ELDER")

Trader:Add(
    "axe",
    2   ,
    "Chop down trees!",
    "images/inventoryimages.xml",
    "axe.tex",
    1,
    false,
    true
)

Trader:Add(
    "shovel",
    2,
    "Dig up all sorts of things.",
    "images/inventoryimages.xml",
    "shovel.tex",
    1,
    false,
    true
)

Trader:Add(
    "fertilizer",
    4,
    "Less poop on hands, more poop on plants.",
    "images/inventoryimages.xml",
    "fertilizer.tex",
    1,
    false,
    true
)

Trader:Add(
    "plate_silver",
    {
        coin2 = 2,
    },
	"Make your dish more presentable.",
    "images/quagmire_food_common_inv_images.xml",
    "plate_silver.tex",
    3,
    true,
    true
)

Trader:Add(
    "bowl_silver",
    {
        coin2 = 2,
    },
	"Make your dish more presentable.",
    "images/quagmire_food_common_inv_images.xml",
    "bowl_silver.tex",
    3,
    true,
    true
)

Trader:Add(
    "plate_gold_blueprint",
    {
        coin2 = 5,
    },
	"Make your dish even more presentable.",
    "images/inventoryimages.xml",
    "blueprint.tex",
    1,
    true,
    true
)

Trader:Add(
    "bowl_gold_blueprint",
    {
        coin2 = 5,
    },
	"Make your dish even more presentable.",
    "images/inventoryimages.xml",
    "blueprint.tex",
    1,
	true,
    true
)

Trader:Add(
    "gorge_key",
    {
        coin3 = 1,
    },
	"Open various safes.",
    "images/inventoryimages.xml",
    "quagmire_key.tex",
    1,
	true,
    true
)

if GetModConfigBoolean("Special Safes") then
    Trader:Add(
        "gorge_key_2",
        {
            coin4 = 1,
        },
    	"Open special safes.",
        "images/inventoryimages.xml",
        "quagmire_key_park.tex",
        1,
        true,
        true
    )
end
