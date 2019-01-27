function AddRoomWrapped(room, ground, contents, tags, internal_type)
	tags = tags or {"ExitPiece", "Chester_Eyebone"}
	internal_type = internal_type or nil
	AddRoom(room, {
		colour={r=.25,g=.28,b=.25,a=.50},
		value = ground,
		tags = tags,
		contents = contents,
		internal_type = internal_type,
	})
end

function AddStandardRoom(room, ground, distributepercent, distributeprefabs, countprefabs, countstaticlayouts, prefabdata, internal_type, tags)
	countprefabs = countprefabs or {}
	countstaticlayouts = countstaticlayouts or {}
	prefabdata = prefabdata or {}
	AddRoomWrapped(
		room,
		ground,
		{
			countprefabs = countprefabs,
			distributepercent = distributepercent,
			distributeprefabs = distributeprefabs,
			countstaticlayouts = countstaticlayouts,
			prefabdata = prefabdata,
		},
		tags,
		internal_type
	)
end

function GetSizeFn(baseValue)
	return function() return baseValue + math.random(GLOBAL.SIZE_VARIATION) end
end

function GetRandomFn(baseValue, randomValue)
	return function() return baseValue + math.random(0, randomValue) end
end

function AddStandardTerrainFilter(prefab)
	GLOBAL.terrain.filter[prefab] = {
		GROUND.ROAD,
		GROUND.WOODFLOOR,
		GROUND.SCALE,
		GROUND.CARPET,
		GROUND.CHECKER,
	}
end

function AddPlantableTerrainFilter(prefab)
	GLOBAL.terrain.filter[prefab] = {
		GROUND.ROAD,
		GROUND.WOODFLOOR,
		GROUND.SCALE,
		GROUND.CARPET,
		GROUND.CHECKER,
		GROUND.ROCKY,
		GROUND.ICE_LAKE,
	}
end

function AddTreeTerrainFilter(prefab)
	AddPlantableTerrainFilter(prefab)
	AddPlantableTerrainFilter(prefab .. "_tall")
	AddPlantableTerrainFilter(prefab .. "_normal")
	AddPlantableTerrainFilter(prefab .. "_small")
end

function AddPreferredLayout(name, fname)
	local layouts = GLOBAL.require("map/layouts").Layouts
	local layout = GLOBAL.require("map/layouts/"..fname)
	layout.fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN
	layouts[name] = layout
end

function AddRequiredStaticLayout(name, fname, layouts_dir)
	layouts_dir = layouts_dir or "static_layouts"
	local Layouts = GLOBAL.require("map/layouts").Layouts
	local StaticLayout = GLOBAL.require("map/static_layout")
	Layouts[name] = StaticLayout.Get(
		"map/" .. layouts_dir .. "/" .. fname,
		{
			start_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
			fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
			layout_position = GLOBAL.LAYOUT_POSITION.CENTER
		}
	)
end
