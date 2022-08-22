RegisterShop("BEANIES_1", {
	Name = "Beanies",
	Storage = {
		Coords = vector3(-590.0597, -1068.249, 22.3442),
		Radius = 1.0,
	},
	Decorations = {
		["bestation_1"] = {
			item = "Beanies Station",
			invisible = true,
			coords = vector3(-591.1956, -1055.682, 23.253),
			rotation = vector3(-20.14697, -0, 89.45664),
		},
        ["beproc_1"] = {
			item = "Beanies Processor",
			invisible = true,
			coords = vector3(-591.1241, -1061.965, 23.5137),
			rotation = vector3(-22.48709, 5.336085e-08, 88.60995),
		},
	},
	Containers = {
		{
			text = "Tray",
			radius = 0.2,
			coords = vector3(-584.0643, -1062.136, 22.50887),
		},
		{
			text = "Tray",
			radius = 0.2,
			coords = vector3(-583.9957, -1059.267, 22.482),
		},
		{
			text = "Pass-through",
			radius = 0.5,
			coords = vector3(-587.3622, -1059.752, 22.83947),
			discrete = true,
			factions = {
				["beanies"] = "restaurant",
			},
		},
		{
			text = "Ingredients",
			radius = 0.4,
			coords = vector3(-590.5562, -1059.079, 22.74407),
			discrete = true,
			width = 5,
			height = 15,
			factions = {
				["beanies"] = "restaurant",
			},
			filters = {
				category = {
					["Ingredient"] = true,
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
				}
			},
		},
        {
			text = "Ingredients",
			radius = 0.3,
			coords = vector3(-588.059, -1067.827, 22.79908),
			discrete = true,
			width = 5,
			height = 15,
			factions = {
				["beanies"] = "restaurant",
			},
			filters = {
				category = {
					["Ingredient"] = true,
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
				}
			},
		},
        {
			text = "Ingredients",
			radius = 0.3,
			coords = vector3(-590.6215, -1068.192, 22.71411),
			discrete = true,
			width = 5,
			height = 15,
			factions = {
				["beanies"] = "restaurant",
			},
			filters = {
				category = {
					["Ingredient"] = true,
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
				}
			},
		},
		{
			text = "Drinks",
			radius = 0.5,
			coords = vector3(-586.8005, -1061.889, 22.54438),
			discrete = true,
			width = 4,
			height = 3,
			factions = {
				["beanies"] = "restaurant",
			},
			filters = {
				category = {
					["Drink"] = true,
					["Beverage"] = true,
				}
			},
		},
	},
})