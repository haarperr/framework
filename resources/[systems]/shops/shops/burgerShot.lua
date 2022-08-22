RegisterShop("BURGER_SHOT", {
	Name = "Burger Shot",
	Storage = {
		Coords = vector3(-1196.097, -904.3538, 13.99892),
		Radius = 1.0,
	},
	Decorations = {
		["frier_1"] = {
			item = "Burger Shot Fryer",
			invisible = true,
			coords = vector3(-1201.338, -897.0543, 13.27606),
			rotation = vector3(-26.485, -0, 32.47513),
		},
		["bsproc_1"] = {
			item = "Burger Shot Processor",
			invisible = true,
			coords = vector3(-1196.124, -898.8571, 14.88577),
			rotation = vector3(-19.92715, -0, 34.49049),
		},
	},
	Containers = {
		{
			text = "Tray",
			radius = 0.2,
			coords = vector3(-1194.645, -893.71, 14.35167),
		},
		{
			text = "Tray",
			radius = 0.2,
			coords = vector3(-1193.448, -895.2433, 14.31095),
		},
		{
			text = "Pass-through",
			radius = 0.5,
			coords = vector3(-1195.649, -896.6133, 14.27252),
			discrete = true,
			factions = {
				["burgershot"] = "restaurant",
			},
		},
		{
			text = "Pass-through",
			radius = 0.5,
			coords = vector3(-1194.71, -897.9369, 14.22776),
			discrete = true,
			factions = {
				["burgershot"] = "restaurant",
			},
		},
		{
			text = "Window",
			radius = 0.5,
			coords = vector3(-1193.818, -906.8685, 14.10615),
			discrete = true,
		},
		{
			text = "Ingredients",
			radius = 0.6,
			coords = vector3(-1197.675, -899.3553, 14.09628),
			discrete = true,
			width = 4,
			height = 15,
			factions = {
				["burgershot"] = "restaurant",
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
			radius = 0.6,
			coords = vector3(-1200.743, -902.5356, 14.47068),
			discrete = true,
			width = 4,
			height = 15,
			factions = {
				["burgershot"] = "restaurant",
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
			radius = 0.6,
			coords = vector3(-1201.873, -900.5848, 14.50276),
			discrete = true,
			width = 4,
			height = 15,
			factions = {
				["burgershot"] = "restaurant",
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
			coords = vector3(-1196.916, -895.6237, 14.34702),
			discrete = true,
			width = 4,
			height = 3,
			factions = {
				["burgershot"] = "restaurant",
			},
			filters = {
				category = {
					["Drink"] = true,
					["Beverage"] = true,
				}
			},
		},
		{
			text = "Drinks",
			radius = 0.5,
			coords = vector3(-1197.684, -894.2891, 14.28494),
			discrete = true,
			width = 4,
			height = 3,
			factions = {
				["burgershot"] = "restaurant",
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