-- This information tells other players more about the mod
name = "[m] Garage Port"
description = "Porting The Gorge to DST"
author = "Joachim and Snook-8, and Mahskie"
version = "0.6.3"
forumthread = ""
api_version = 10

-- This guarantees that it will be loaded after some (optional) character mods
priority = -1

icon_atlas = "modicon.xml"
icon = "modicon.tex"

dst_compatible = true
dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true

all_clients_require_mod = true
client_only_mod = false

server_filter_tags = {"environment","worldgen","creature"}

configuration_options = {

			{
        name = "Classic Cookpot",
		label = "Classic Cookpot",
        options = 
        {
            {description = "Enable", data = "1"},
        },
        default = "Enable"
    },
			{
        name = "Special Safes",
		label = "Special Safes",
        options = 
        {
            {description = "Disable", data = "1"},
        },
        default = "1"
    },
				{
        name = "Sugarwood Biome",
		label = "Sugarwood Biome",
        options = 
        {
            {description = "Enable", data = "1"},
        },
        default = "Enable"
    },
					{
        name = "Salt Biome",
		label = "Salt Biome",
        options = 
        {
            {description = "Enable", data = "1"},
        },
        default = "Enable"
    },
						{
        name = "Swamp Pig Biome",
		label = "Swamp Pig Biome",
        options = 
        {
            {description = "Enable", data = "1"},
        },
        default = "Enable"
    }
}
