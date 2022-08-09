RegisterShop("BURGER_SHOT", {
	Name = "Burger Shot",
	Storage = {
		Coords = vector3(-1196.097, -904.3538, 13.99892),
		Radius = 1.0,
	},
	Decorations = {
		["frier_1"] = {
			item = "Fryer",
			invisible = true,
			coords = vector3(-1201.338, -897.0543, 13.27606),
			rotation = vector3(-26.485, -0, 32.47513),
		},
	},
	Containers = {
		{
			text = "Tray",
			radius = 0.2,
			coords = vector3(-1195.275, -892.303, 14.04083),
		},
		{
			text = "Tray",
			radius = 0.2,
			coords = vector3(-1194.018, -894.209, 14.04083),
		},
		{
			text = "Pass-through",
			radius = 0.5,
			coords = vector3(-1195.649, -896.6133, 14.27252),
			discrete = true,
		},
		{
			text = "Pass-through",
			radius = 0.5,
			coords = vector3(-1194.71, -897.9369, 14.22776),
			discrete = true,
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
			coords = vector3(-1196.916, -895.6237, 14.34702),
			discrete = true,
			width = 4,
			height = 3,
			filters = {
				category = {
					["Drink"] = true,
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
			filters = {
				category = {
					["Drink"] = true,
				}
			},
		},
	},
})