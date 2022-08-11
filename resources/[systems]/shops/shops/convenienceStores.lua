Config.Filters.Convenience = {
	item = {
		-- Food.
		["Choco Rings"] = true,
		["Corn Dog"] = true,
		["Crackles O Dawn"] = true,
		["Cup Noodles"] = true,
		["Ego Chaser"] = true,
		["Fat Chips"] = true,
		["Meteorite Bar"] = true,
		["Peanuts"] = true,
		["Ps & Qs"] = true,
		["Rails"] = true,
		["Release Gum"] = true,
		["Scooby Snacks"] = true,

		-- Drink.
		["Coffee"] = true,
		["E Cola"] = true,
		["Junk Energy Drink"] = true,
		["Milk"] = true,
		["O Rang O Tang"] = true,
		["Sprunk"] = true,
		["Water"] = true,

		-- Ingredients.
		["Baking Soda"] = true,
		["Eggs"] = true,
	},
}

RegisterShop("HARMONY_247", {
	Name = "Harmony 24/7",
	Clerks = {
		{
			coords = vector4(549.2772, 2669.603, 42.15648, 91.24641),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(546.5355, 2662.86, 42.15654),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(548.6461, 2669.562, 42.2) },
	},
})

RegisterShop("INNOCENCE_247", {
	Name = "Innocence 24/7",
	Clerks = {
		{
			coords = vector4(24.49411, -1346.465, 29.49702, 265.8573),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(28.21899, -1339.247, 29.49705),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(25.74687, -1345.332, 29.49702) },
	},
})

RegisterShop("PALOMINO_247", {
	Name = "Palomino 24/7",
	Clerks = {
		{
			coords = vector4(2556.835, 381.2682, 108.6228, 357.5427),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(2549.261, 384.8791, 108.623),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.5, coords = vector3(2555.441, 381.5698, 108.6187) },
	},
})


RegisterShop("CLINTON_247", {
	Name = "Clinton 24/7",
	Clerks = {
		{
			coords = vector4(372.7724, 327.5338, 103.5664, 254.6205),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(377.9404, 333.4799, 103.5664),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(25.08247, -1345.55, 29.68135) },
	},
})

RegisterShop("ROCKFORD_247", {
	Name = "Rockford 24/7",
	Clerks = {
		{
			coords = vector4(-1820.467, 794.5576, 138.0908, 129.331),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(-1828.583, 800.1725, 138.1664),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(-1822.475, 792.7213, 139.4109) },
	},
})

RegisterShop("SENORA_247", {
	Name = "Senora 24/7",
	Clerks = {
		{
			coords = vector4(2676.496, 3280.292, 55.24112, 329.0203),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(2672.76, 3286.728, 55.24112),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(2677.426, 3282.453, 56.82861) },
	},
})

RegisterShop("PALETO_247", {
	Name = "Paleto 24/7",
	Clerks = {
		{
			coords = vector4(1728.386, 6415.51, 35.03712, 241.8797),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(1734.608, 6421.002, 35.03728),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(1730.795, 6417.497, 36.74789) },
	},
})

RegisterShop("PALETO2_247", {
	Name = "Paleto 2 24/7",
	Clerks = {
		{
			coords = vector4(1728.464, 6415.459, 35.03713, 245.5538),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(168.703, 6645.234, 31.6928),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(161.4018, 6641.906, 31.70326) },
	},
})

RegisterShop("SANDY_247", {
	Name = "Sandy 24/7",
	Clerks = {
		{
			coords = vector4(1960.163, 3740.579, 32.34367, 300.1234),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(1959.257, 3748.864, 32.34373),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(1960.369, 3743.369, 34.07462) },
	},
})

RegisterShop("GOCEAN_247", {
	Name = "Great Ocean 24/7",
	Clerks = {
		{
			coords = vector4(-3039.928, 584.6912, 7.904603, 13.52404),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(-3048.018, 585.5446, 7.903237),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(-3040.298, 585.3093, 8.089398) },
	},
})

RegisterShop("GROVE_247", {
	Name = "Grove 24/7",
	Clerks = {
		{
			coords = vector4(-47.32117, -1758.597, 29.421, 44.8899),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(-42.10491, -1748.598, 29.42175),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(-47.92688, -1758.33, 29.5949) },
	},
})