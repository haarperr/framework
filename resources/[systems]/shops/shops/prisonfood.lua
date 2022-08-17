Config.Filters.Prisonfood = {
	item = {
		["Prison Food"] = true,
        ["Water"] = true,
	},
}

RegisterShop("PRISON_FOOD_001", {
	Name = "Prison Canteen",
	Clerks = {
		{
			coords = vector4(1779.604, 2591.35, 45.79767, 180.726),
			model = "s_m_y_cop_01",
		},
	},
	Storage = {
		Coords = vector3(1778.876, 2591.442, 45.79801),
		Radius = 2.0,
		Filters = Config.Filters.Prisonfood,
	},
    Decorations = {
		["pfryer_1"] = {
			item = "Fryer",
			invisible = true,
			coords = vector3(1778.546, 2596.499, 46.11757),
			rotation = vector3(-13.64706, -0, -89.88343),
		},
        ["pstove_1"] = {
			item = "Stove",
			invisible = true,
			coords = vector3(1778.774, 2599.368, 46.70929),
			rotation = vector3(-15.64664, -0, -93.90154),
		},
	},
    Containers = {
		{
			text = "Tray",
			radius = 0.2,
            coords = vector3(1779.278, 2590.368, 46.05474)
        },
        {
			text = "Ingredients",
			radius = 0.4,
			coords = vector3(1779.689, 2598.058, 46.07841),
			discrete = true,
			width = 5,
			height = 20,
			filters = {
				category = {
					["Ingredient"] = true,
				}
			},
		},
        {
			text = "Storage",
			radius = 0.4,
			coords = vector3(1781.377, 2599.725, 45.85766),
			discrete = true,
			width = 5,
			height = 20,
		},
        {
			text = "Drinks",
			radius = 0.5,
			coords = vector3(1777.61, 2593.037, 45.78243),
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