Config.Filters.Vanilla = {
	item = {
		-- Food.
		["Beer"] = true,
		["Tequila"] = true,
		["Vodka"] = true,
		["Water"] = true,
		["Whiskey"] = true,
		["Champagne"] = true,
		["Sangria"] = true,
		["Highway To Hell"] = true,
		["Unicorn Kiss"] = true,
		
		-- Ingredients.
		["Hot Dog"] = true,
		["Fat Chips"] = true,
	},
}

RegisterShop("VANILLA_UNICORN", {
	Name = "Vanilla Unicorn",
	Clerks = {
		{
			coords = vector4(126.9519, -1277.654, 29.26934, 168.3346),
			model = "a_f_y_business_04",
		},
	},
	Storage = {
		Coords = vector3(126.6405, -1278.121, 29.26934),
		Radius = 2.0,
		Filters = Config.Filters.Vanilla,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(548.6461, 2669.562, 42.2) },
	},
})

