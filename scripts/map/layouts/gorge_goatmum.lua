local offsetX = 0
local offsetY = 0

local size = 13
local theta = 0.25 * PI
local newsize = math.ceil(math.sqrt(2 * size * size))
local rad = math.floor(size / 2)

local function CreateEmptyGrid()
	local tiles = {}
	for i = 1, newsize do
		table.insert(tiles, {})
		for j = 1, newsize do
			table.insert(tiles[i], 0)
		end
	end
	return tiles
end

local function RotatePoint(x, y)
	local xx = x + math.floor(rad * math.cos(-theta) + rad * math.sin(-theta))
	local yy = y + math.floor(rad * math.cos(theta) - rad * math.sin(-theta))
	return {x = xx, y = yy}
end

local function ComputeGround()
	local tiles = CreateEmptyGrid()
	-- for i = 1, newsize do
	-- 	for j = 1, newsize do
	-- 		local x = i - math.floor(newsize / 2) - 1
	-- 		local y = j - math.floor(newsize / 2) - 1
	-- 		local xx = math.floor(x * math.cos(-theta) + y * math.sin(-theta))
	-- 		local yy = math.floor(y * math.cos(theta) - x * math.sin(-theta))
	-- 		if xx >= 1 and xx <= size and yy >= 1 and yy <= size then
	-- 			tiles[i][j] = 1
	-- 		end
	-- 	end
	-- end
	return tiles
end

return {
	-- Choose layout type
	type = LAYOUT.STATIC,

	-- layout_position = LAYOUT_POSITION.CENTER,

	-- Add any arguments for the layout function
	args = nil,
	-- Lay the objects in whatever pattern

	ground_types = {GROUND.ROAD},

	--layout_position = LAYOUT_POSITION.CENTER,

	ground = ComputeGround(),

	layout =
		{
			gorge_altar = {
				{
					x = 0,
					y = 0,
				},
			},
		},

	-- Either choose to specify the objects positions or a number of objects
	count = nil,

	-- Choose a scale on which to place everything
	scale = 1,
}
