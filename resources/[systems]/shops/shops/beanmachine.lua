RegisterShop("BEAN_MACHINE", {
	Name = "Bean Machine",
	Storage = {
		Coords = vector3(-627.4974, 226.0371, 82.68631),
		Radius = 1.0,
	},
	Decorations = {
		["bmprocessor_1"] = {
			item = "Bean Machine Station",
			invisible = true,
			coords = vector3(-629.5922, 222.7952, 81.87758),
			rotation = vector3(-17.93439, -0, -179.8138),
		},
	},
	Containers = {
		{
			text = "Tray",
			radius = 0.2,
			coords = vector3(-634.3727, 235.4191, 82.30943),
		},
		{
			text = "Pass-through",
			radius = 0.5,
			coords = vector3(-635.6472, 233.2834, 81.88647),
			discrete = true,
		},
		{
			text = "Drinks",
			radius = 0.5,
			coords = vector3(-636.8191, 234.463, 81.59695),
			discrete = true,
			width = 4,
			height = 3,
			factions = {
				["beanmachine"] = "restaurant",
			},
			filters = {
				category = {
					["Drink"] = true,
				}
			},
		},
	},
})