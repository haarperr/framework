Config.Filters.Convenience = {
	blip = {
		name = "Convenience Store",
		id = 59,
		scale = 0.5,
		color = 29,
	},
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
		["Sugar"] = true,
		["Salt"] = true,
		["Shredded Cheese"] = true,
		["Cup"] = true,
		["Dough"] = true,
		["Cookie Dough"] = true,
	},
}

RegisterShop("HARMONY_2471", {
	Name = "Harmony 24/7",
	Clerks = {
		{
			coords = vector4(548.6993, 2670.862, 42.15641, 98.72795),
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

RegisterShop("INNOCENCE_2471", {
	Name = "Innocence 24/7",
	Clerks = {
		{
			coords = vector4(24.90272, -1346.925, 29.49698, 270.4617),
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

RegisterShop("PALOMINO_2471", {
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


RegisterShop("CLINTON_2471", {
	Name = "Clinton 24/7",
	Clerks = {
		{
			coords = vector4(373.0437, 326.558, 103.5664, 254.0845),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(377.9404, 333.4799, 103.5664),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(373.7822, 326.6674, 104.0503) },
	},
})

RegisterShop("ROCKFORD_2471", {
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

RegisterShop("SENORA_2471", {
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

RegisterShop("PALETO_2471", {
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

RegisterShop("PALETO2_2471", {
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

RegisterShop("SANDY_2471", {
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

RegisterShop("GOCEAN_2471", {
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

RegisterShop("GROVE_2471", {
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

RegisterShop("SEOUL_2471", {
	Name = "Little Seoul 24/7",
	Clerks = {
		{
			coords = vector4(-706.1124, -914.4959, 19.21559, 93.81121),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(-706.1124, -914.4959, 19.21559),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(-47.92688, -1758.33, 29.5949) },
	},
})

RegisterShop("MIRROR_2471", {
	Name = "Mirror 24/7",
	Clerks = {
		{
			coords = vector4(1164.857, -323.6848, 69.20506, 101.0379),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(1161.052, -313.4174, 69.19912),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(1164.179, -323.7475, 69.26102) },
	},
})

RegisterShop("GRAPE_2471", {
	Name = "Grapeseed 24/7",
	Clerks = {
		{
			coords = vector4(1697.284, 4923.448, 42.06362, 326.3737),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(1707.501, 4918.78, 42.06362),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(1697.611, 4924.043, 42.10943) },
	},
})

RegisterShop("ROCK2_2471", {
	Name = "Rockford 24/7",
	Clerks = {
		{
			coords = vector4(-1422.551, -271.0514, 46.27737, 41.38894),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(-1415.683, -262.3278, 46.37909),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(-1422.958, -270.6406, 46.35056) },
	},
})

RegisterShop("ROCK2_2471", {
	Name = "Rockford 24/7",
	Clerks = {
		{
			coords = vector4(-3242.781, 1000.401, 12.83064, 357.1664),
			model = "s_f_m_sweatshop_01",
		},
	},
	Storage = {
		Coords = vector3(-3250.227, 1003.662, 12.83065),
		Radius = 2.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(-3242.707, 1001.161, 13.04108) },
	},
})