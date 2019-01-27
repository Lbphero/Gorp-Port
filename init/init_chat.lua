local _G = GLOBAL
local STRINGS = _G.STRINGS

local CRAVINGS =
{
    snack = "a SNACK",
    bread = "a meal on BREAD",
    soup = "SOUP",
    meat = "MEAT",
    fish = "FISH",
    dessert = "a DESSERT",
    veggie = "a VEGETABLE dish",
    cheese = "a meal with CHEESE",
    pasta = "PASTA",
}

STRINGS.MUMSY_TALK_NOTHING =
{
	"I'll help how I can",
}

local CRAVING_PREFIXES =
{
	"The Gnaw desires",
	"The Gnaw craves",
	"The Gnaw hungers for",
	"The Gnaw wants",
}

local CRAVING_POSTFIXES =
{
	"I can tell, baa.",
	"I'm certain of it.",
	"baa.",
	--"You must oblige."
	"I feel it.",
	--"It's time to cook."
}

for craving, description in pairs(CRAVINGS) do
	local cravingcaps = string.upper(craving)
	local key = "MUMSY_CRAVING_" .. cravingcaps
	STRINGS[key] = {}
	for i=1,4,1 do
		local prefix = CRAVING_PREFIXES[i]
		local postfix = CRAVING_POSTFIXES[i]
		table.insert(STRINGS[key], prefix .. " " .. description .. "... " .. postfix)
	end
end

STRINGS.MUMSY_GNAW_ANGRY =
{
	"The Gnaw is not pleased...",
	"The Gnaw is getting impatient...",
	"The Gnaw will punish us...",
}

STRINGS.MUMSY_GNAW_WRATH =
{
	"Oh no! We've incurred the Gnaw's wrath!",
	"We are in great danger!",
	"We failed,"
}
