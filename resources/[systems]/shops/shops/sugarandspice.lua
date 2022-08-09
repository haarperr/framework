RegisterShop("SUGAR_AND_SPICE", {
	Name = "Sugar And Spice",
	Storage = {
		Coords = vector3(1114.603, -636.7858, 56.81782),
		Radius = 1.0,
	},
	Decorations = {
		["asaprocessor_1"] = {
			item = "Sugar and Spice Station",
            Radius = 0.1,
			invisible = true,
			coords = vector3(1117.131, -637.5654, 57.77876),
			rotation = vector3(-25.63622, -0, -145.6534),
		},
	},
	Containers = {
		{
			text = "Tray",
			radius = 0.2,
			coords = vector3(1116.837, -640.6771, 57.00419),
		},
		{
			text = "Pass-through",
			radius = 0.5,
			coords = vector3(1116.993, -638.4188, 56.79034),
			discrete = true,
		},
		{
			text = "Ingredients",
			radius = 0.6,
			coords = vector3(-1197.675, -899.3553, 14.09628),
			discrete = true,
			width = 4,
			height = 5,
			filters = {
				category = {
					["Ingredient"] = true,
				}
			},
		},
		{
			text = "Drinks",
			radius = 0.5,
			coords = vector3(1118.819, -638.0433, 56.6766),
			discrete = true,
			width = 4,
			height = 3,
			filters = {
				category = {
					["Drink"] = true,
				}
			},
		},
	},
})