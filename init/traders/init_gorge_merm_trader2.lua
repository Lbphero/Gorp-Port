local Trader = TraderManager("TRADING_MERM2")

Trader:AddSeedPacket("tomato", 3)
Trader:AddSeedPacket("garlic", 7)
Trader:Add(
    "sapbucket",
    3,
	"Tap sap from saptrees!",
    "images/inventoryimages.xml",
    "quagmire_sapbucket.tex",
    3,
    false,
    true
)
Trader:AddCookerBundle("grill", 10)
Trader:Add(
    "casseroledish",
    5,
    "A larger casseroledish.",
    "images/inventoryimages.xml",
    "quagmire_casseroledish.tex",
    1,
    false,
    true
)
Trader:Add(
    "pot",
    6,
    "Cook larger meals in this pot.",
    "images/inventoryimages.xml",
    "quagmire_pot.tex",
    1,
    false,
    true
)
Trader:Add(
    "pot_syrup",
    5,
    "Brew syrup in this pot.",
    "images/inventoryimages.xml",
    "quagmire_pot_syrup.tex",
    1,
    false,
    true
)
