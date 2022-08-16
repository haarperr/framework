Config.Filters.Hotdog = {
	blip = {
		name = "Hotdog Vendor",
		id = 59,
		scale = 0.5,
		color = 29,
	},
	item = {
		-- Food.
		["Hotdog"] = true,
		["Corn Dog"] = true,
		["Pretzel"] = true,
		["Peanuts"] = true,

		-- Drink.
		["Milkshake"] = true,
		["E Cola"] = true,
		["Water"] = true,
	},
}

RegisterShop("HOTDOG_1", {
	Name = "Pier Hot Dogs",
	Clerks = {
		{
			coords = vector4(-1835.02, -1233.633, 13.01744, 31.7009),
			model = "s_f_y_shop_low",
		},
	},
	Storage = {
		Coords = vector3(-1834.863, -1233.41, 13.0218),
		Radius = 2.0,
		Filters = Config.Filters.Hotdog,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(-1835.405, -1232.995, 13.13253) },
	},
})

RegisterShop("HOTDOG_2", {
	Name = "Sandy Shore Hot Dogs",
	Clerks = {
		{
			coords = vector4(1983.364, 3707.171, 32.56671, 8.568855),
			model = "s_f_y_shop_low",
		},
	},
	Storage = {
		Coords = vector3(1983.364, 3707.171, 32.56671),
		Radius = 2.0,
		Filters = Config.Filters.Hotdog,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(1983.355, 3707.872, 32.47383) },
	},
})

RegisterShop("HOTDOG_3", {
	Name = "Paleto Hot Dogs",
	Clerks = {
		{
			coords = vector4(-302.7564, 6113.415, 31.7223, 290.4487),
			model = "s_f_y_shop_low",
		},
	},
	Storage = {
		Coords = vector3(-302.7564, 6113.415, 31.7223),
		Radius = 2.0,
		Filters = Config.Filters.Hotdog,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(-302.1442, 6113.741, 31.7063) },
	},
})
