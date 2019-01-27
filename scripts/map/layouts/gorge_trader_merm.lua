local offsetX = 0
local offsetY = 0


return {
	-- Choose layout type
	type = LAYOUT.STATIC,

	-- layout_position = LAYOUT_POSITION.CENTER,

	-- Add any arguments for the layout function
	args = nil,
	-- Lay the objects in whatever pattern

	ground_types = {GROUND.ROAD},

	--layout_position = LAYOUT_POSITION.CENTER,

	ground = {
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1},
	},

	layout =
		{
			gorge_park_obelisk = {
				{
					x = -3,
					y = -3,
				},
				{
					x = 3,
					y = -3,
				},
				{
					x = -3,
					y = 3,
				},
				{
					x = 3,
					y = 3,
				},
			},
			gorge_park_angel = {
				{
					x = 0,
					y = 0,
				},
			},
			gorge_trader_merm = {
                {
                    x = 0,
                    y = 2,
                },
            },
            gorge_merm_cart1 = {
                {
                    x = 0,
                    y = 1,
                },
            },
		},

	-- Either choose to specify the objects positions or a number of objects
	count = nil,

	-- Choose a scale on which to place everything
	scale = 1,
}
