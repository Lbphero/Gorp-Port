AddTask("Gorge saptree forest", {
	locks={LOCKS.TIER1, LOCKS.AXE},
	keys_given={KEYS.TIER2},
	room_choices={
		["SapTreeForest"] = GetSizeFn(1),
		["SapTreeForestTraders"] = 1,
		["SapTreeForestCore"] = 1,
	},
	room_bg=GROUND.QUAGMIRE_PARKFIELD,
	background_room="BGSapTreeForest",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Gorge saptree forest 2", {
	locks={LOCKS.TIER1, LOCKS.AXE},
	keys_given={KEYS.TIER2},
	room_choices={
		["SapTreeForest"] = GetSizeFn(1),
		["SapTreeForestTraders2"] = 1,
	},
	room_bg=GROUND.QUAGMIRE_PARKFIELD,
	background_room="BGSapTreeForest",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Gorge saltponds", {
	locks={LOCKS.TIER2},
	keys_given={KEYS.TIER3},
	room_choices={
		["ParkStone"] = GetSizeFn(1),
		["ParkStoneCrabs"] = 2,
		["ParkStoneTraders"] = 1,
	},
	room_bg=GROUND.QUAGMIRE_PARKSTONE,
	background_room="BGParkStone",
	colour={r=1,g=0.6,b=1,a=1},
})

AddTask("Gorge swamp", {
	locks={LOCKS.TIER2},
	keys_given={KEYS.TIER3},
	room_choices={
		["GorgeSwamp"] = GetSizeFn(2),
		["GorgeSwampElder"] = 1,
	},
	room_bg=GROUND.QUAGMIRE_PEATFOREST,
	background_room="BGGorgeSwamp",
	colour={r=1,g=0.6,b=1,a=1},
})
