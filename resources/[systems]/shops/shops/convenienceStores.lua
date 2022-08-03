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

		-- Other.
		["Tenga"] = true,
	},
}

RegisterShop("HARMONY_247", {
	Name = "Harmony 24/7",
	Clerks = {
		{
			coords = vector4(549.2772, 2669.603, 42.15648, 91.24641),
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
			coords = vector4(2555.48, 380.8026, 108.6229, 358.1403),
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
			coords = vector4(1728.647, 6416.733, 35.03728, 239.1772),
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

RegisterShop("SANDY_247", {
	Name = "Sandy 24/7",
	Clerks = {
		{
			coords = vector4(1959.326, 3741.4, 32.34373, 300.6078),
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