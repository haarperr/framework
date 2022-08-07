Config.Filters.Convenience = {
	item = {
		-- Food.
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
		},
	},
	Storage = {
		Coords = vector3(-1037.249, -1390.696, 5.558081),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
    Decorations = {
		["sales1"] = {
			item = "Fish Sales",
			invisible = true,
			coords = vector3(-1037.064, -1397.899, 5.553192),
			heading = 123.7745,
		},
		},
	}
)

