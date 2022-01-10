Config = {}

Config.Filters = {
	Convenience = {
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
	},
}

Config.Shops = {
	{
		Clerks = {
			{
				coords = vector4(549.2772, 2669.603, 42.15648, 91.24641),
			},
		},
		Storage = {
			Coords = vector3(546.5003, 2662.695, 41.83086),
			Radius = 1.0,
			Filters = Config.Filters.Convenience,
		},
		Decorations = {
			-- {
			-- 	coords = vector3(548.6461, 2669.562, 42.2),
			-- 	heading = 96.24641,
			-- 	model = "v_ind_cs_tray03",
			-- }
		},
		Containers = {
			{ text = "Counter", radius = 0.2, coords = vector3(548.6461, 2669.562, 42.2) },
		},
	},
	{
		Clerks = {
			-- {
			-- 	coords = vector4(549.2772, 2669.603, 42.15648, 91.24641),
			-- },
		},
		Storage = {
			Coords = vector3(-1196.097, -904.3538, 13.99892),
			Radius = 1.0,
			Filters = {
				item = {
				},
			},
		},
		Decorations = {
			-- {
			-- 	coords = vector3(-1195.674, -891.7833, 14.02952),
			-- 	heading = 0.0,
			-- }
		},
		Containers = {
			{ text = "Tray", radius = 0.2, coords = vector3(-1195.275, -892.303, 14.04083) }, -- Right tray.
			{ text = "Tray", radius = 0.2, coords = vector3(-1194.018, -894.209, 14.04083) }, -- Left tray.
			{ text = "Pass-through", radius = 0.5, coords = vector3(-1196.916, -895.6237, 14.34702), discrete = true }, -- Left window.
			{ text = "Pass-through", radius = 0.5, coords = vector3(-1197.684, -894.2891, 14.28494), discrete = true }, -- Middle window.
			{ text = "Pass-through", radius = 0.5, coords = vector3(-1198.569, -893.0552, 14.32487), discrete = true }, -- Right window.
		},
	},
}