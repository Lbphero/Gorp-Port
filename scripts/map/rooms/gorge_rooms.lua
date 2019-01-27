AddPreferredLayout("GorgeTraderMerm", "gorge_trader_merm")
AddPreferredLayout("GorgeTraderMerm2", "gorge_trader_merm2")
AddPreferredLayout("GorgeTraderGoatkid", "gorge_trader_goatkid")
AddPreferredLayout("GorgeGoatmum", "gorge_goatmum")
AddPreferredLayout("GorgeSafe", "gorge_safe")

AddStandardRoom(
	"BGSapTreeForest",
	GROUND.QUAGMIRE_PARKFIELD,
	0.23,
	{
		spotspice_shrub = 0.02,
		sapling = 0.1,
		grass = 0.1,
		cave_fern = 0.25,
		molehill = 0.02,
		turnip_planted = 0.01,
		saptree_small = 0.05,
	}
)

AddStandardRoom(
	"SapTreeForest",
	GROUND.QUAGMIRE_PARKFIELD,
	0.35,
	{
		saptree_small = 0.1,
		saptree_normal = 0.13,
		saptree_tall = 0.08,
		spotspice_shrub = 0.1,
		sapling = 0.05,
		twiggytree = 0.05,
		grass = 0.05,
		cave_fern = 0.05,
		rabbithole = 0.02,
		berrybush = 0.1,
		berrybush_juicy = 0.1,
		turnip_planted = 0.02,
	}
)

AddStandardRoom(
	"SapTreeForestTraders",
	GROUND.QUAGMIRE_PARKFIELD,
	0.2,
	{
		spotspice_shrub = 0.15,
		sapling = 0.05,
		twiggytree = 0.05,
		grass = 0.05,
		cave_fern = 0.05,
		rabbithole = 0.02,
		berrybush = 0.1,
		berrybush_juicy = 0.1,
		turnip_planted = 0.02,
	},
	{},
	{
		["GorgeTraderMerm"] = 1,
		["GorgeSafe"] = 1,
	}
)

AddStandardRoom(
	"SapTreeForestTraders2",
	GROUND.QUAGMIRE_PARKFIELD,
	0.2,
	{
		spotspice_shrub = 0.07,
		sapling = 0.06,
		twiggytree = 0.06,
		grass = 0.05,
		cave_fern = 0.08,
		rabbithole = 0.04,
		berrybush = 0.12,
		berrybush_juicy = 0.11,
		turnip_planted = 0.03,
	},
	{
		gorge_altar = 1,
	},
	{
		["GorgeTraderMerm2"] = 1,
		["GorgeSafe"] = 1,
	}
)

AddStandardRoom(
	"SapTreeForestCore",
	GROUND.QUAGMIRE_PARKFIELD,
	0.55,
	{
		saptree_small = 0.2,
		saptree_normal = 0.15,
		saptree_tall = 0.12,
		cave_fern = 0.1,
	},
	{
		catcoonden = 1,
	},
	{
		["GorgeSafe"] = 1,
	}
)

AddStandardRoom(
	"BGParkStone",
	GROUND.QUAGMIRE_PARKSTONE,
	0.1,
	{
		rock = 0.02,
		rock_flintless = 0.02,
		rock2 = 0.01,
		-- grassgekko = 0.07,
		marsh_bush = 0.05,
		pebblecrab = 0.01,
		flint = 0.01,
		rocks = 0.01,
	}
)

AddStandardRoom(
	"ParkStone",
	GROUND.QUAGMIRE_PARKSTONE,
	0.23,
	{
		rock = 0.03,
		rock2 = 0.01,
		rocks = 0.03,
		rock_flintless = 0.01,
		pond_salt = 0.06,
		-- grass = 0.03,
		flint = 0.02,
		-- grassgekko = 0.25,
		-- buzzardspawner = .02,
		garlic_planted = 0.06,
		marsh_bush = 0.06,
		pebblecrab = 0.04,
	}
)

AddStandardRoom(
	"ParkStoneCrabs",
	GROUND.QUAGMIRE_PARKSTONE,
	0.15,
	{
		rock = 0.01,
		rock2 = 0.02,
		rock_flintless = 0.06,
		garlic_planted = 0.02,
		marsh_bush = 0.04,
		pebblecrab = 0.1,
		flint = 0.04,
		rocks = 0.04,
		pond_salt = 0.04,
	}
)

AddStandardRoom(
	"ParkStoneTraders",
	GROUND.QUAGMIRE_PARKSTONE,
	0.12,
	{
		rock_flintless = 0.1,
	},
	{
		pond_salt = GetRandomFn(2, 1),
	},
	{
		["GorgeTraderGoatkid"] = 1,
		["GorgeSafe"] = 1,
	}
)

AddStandardRoom(
	"BGGorgeSwamp",
	GROUND.QUAGMIRE_PEATFOREST,
	0.2,
	{
		evergreen_sparse = 2,
		marsh_bush = 0.07,
		sapling = 0.03,
		twiggytree = 0.03,
		gorge_mushrooms_stump = 0.03,
	}
)

AddStandardRoom(
	"GorgeSwamp",
	GROUND.QUAGMIRE_PEATFOREST,
	0.6,
	{
		evergreen_sparse = 3,
		marsh_bush = 0.08,
		sapling = 0.1,
		twiggytree = 0.08,
		gorge_swamppig_house = 0.03,
		gorge_swamppig_house_rubble = 0.02,
		potato_planted = 0.03,
		gorge_mushrooms_stump = 0.1,
	}
)

AddStandardRoom(
	"GorgeSwampElder",
	GROUND.QUAGMIRE_PEATFOREST,
	0.5,
	{
		evergreen_sparse = 5,
		marsh_bush = 0.07,
		sapling = 0.03,
		twiggytree = 0.03,
	},
	{
		gorge_swamppig_elder = 1,
		gorge_swamppig_house = 5,
		gorge_swamppig_house_rubble = 7,
		potato_planted = 12,
	}
)
