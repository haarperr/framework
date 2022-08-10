Config.Filters.Fish = {
	item = {
		["Dogfish"] = true,
		["Flounder"] = true,
		["Halibut"] = true,
		["Queenfish"] = true,
		["Ray"] = true,
		["Sand Bass"] = true,
		["Seaweed"] = true,
		["Black Rockfish"] = true,
		["Sheephead"] = true,
		["Sculpin"] = true,
		["Skipjack Tuna"] = true,
	},
}

RegisterShop("FISH_SALES", {
	Name = "Fish Shop",
	Clerks = {
		{
			coords = vector4(-1037.698, -1394.182, 5.553192, 107.7845),
			model = "cs_omega",
		},
	},
	Storage = {
		Coords = vector3(-1037.249, -1390.696, 5.558081),
		Radius = 2.0,
		Filters = Config.Filters.Fish,
	},
    Decorations = {
		["fish1"] = {
			item = "Fish Sales",
			invisible = true,
			coords = vector3(-1037.424, -1397.887, 5.557446),
			rotation = vector3(-10.06761, -2.134434e-07, -104.5066),
		},
		},
	}
)

RegisterShop("FISH_SALES2", {
	Name = "Highway Fish Shop",
	Clerks = {
		{
			coords = vector4(-2191.833, 4284.876, 49.18159, 99.87895),
			model = "cs_omega",
		},
	},
	Storage = {
		Coords = vector3(-2194.729, 4287.366, 49.17432),
		Radius = 2.0,
		Filters = Config.Filters.Fish,
	},
    Decorations = {
		["fish2"] = {
			item = "Fish Sales",
			invisible = true,
			coords = vector3(-2192.006, 4282.477, 49.17653),
			rotation = vector3(-8.729517, -0, -106.6504),
		},
		},
	}
)

