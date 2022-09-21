Config.Filters.Vanilla = {
	item = {
		-- Food.
		["Beer"] = true,
		["Tequila"] = true,
		["Vodka"] = true,
		["Water"] = true,
		["Whiskey"] = true,
		["Champagne"] = true,
		["Sangria"] = true,
		["Highway To Hell"] = true,
		["Unicorn Kiss"] = true,
		
		-- Ingredients.
		["Hot Dog"] = true,
		["Fat Chips"] = true,
	},
}

RegisterShop("VANILLA_UNICORN", {
	Name = "Vanilla Unicorn",
	Clerks = {
		{
			coords = vector4(126.9519, -1277.654, 29.26934, 168.3346),
			model = "a_f_y_business_04",
		},
	},
	Storage = {
		Coords = vector3(126.6405, -1278.121, 29.26934),
		Radius = 2.0,
		Filters = Config.Filters.Vanilla,
	},
	Containers = {
		{
			text = "Counter",
			radius = 0.55,
			coords = vector3(129.1372, -1285.1, 29.81767),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
					["Alcohol"] = true,
					["Money"] = true,
				}
			},
		},
		{
			text = "Table",
			radius = 0.55,
			coords = vector3(125.8567, -1286.78, 30.28415),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
					["Alcohol"] = true,
					["Money"] = true,
				}
			},
		},
		{
			text = "Table",
			radius = 0.55,
			coords = vector3(124.2171, -1283.956, 30.55679),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
					["Alcohol"] = true,
					["Money"] = true,
				}
			},
		},
		{
			text = "Table",
			radius = 0.55,
			coords = vector3(115.8907, -1286.793, 28.88405),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
					["Alcohol"] = true,
					["Money"] = true,
				}
			},
		},
		{
			text = "Table",
			radius = 0.55,
			coords = vector3(123.3296, -1294.915, 29.68692),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
					["Alcohol"] = true,
					["Money"] = true,
				}
			},
		},
		{
			text = "Table",
			radius = 0.55,
			coords = vector3(115.8907, -1286.793, 28.88405),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
					["Alcohol"] = true,
					["Money"] = true,
				}
			},
		},
		{
			text = "Table",
			radius = 0.55,
			coords = vector3(119.9847, -1296.81, 29.74035),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
					["Alcohol"] = true,
					["Money"] = true,
				}
			},
		},
		{
			text = "Table",
			radius = 0.55,
			coords = vector3(122.0689, -1286.978, 28.7598),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
					["Alcohol"] = true,
					["Money"] = true,
				}
			},
		},
		{
			text = "Table",
			radius = 0.55,
			coords = vector3(121.0337, -1285.208, 28.67863),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
					["Alcohol"] = true,
					["Money"] = true,
				}
			},
		},
		{
			text = "Table",
			radius = 0.55,
			coords = vector3(117.5475, -1283.063, 28.88425),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
					["Alcohol"] = true,
					["Money"] = true,
				}
			},
		},
		{
			text = "Table",
			radius = 0.55,
			coords = vector3(115.8907, -1286.793, 28.88405),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
					["Alcohol"] = true,
					["Money"] = true,
				}
			},
		},
		{
			text = "Table",
			radius = 0.55,
			coords = vector3(112.8079, -1283.136, 28.88295),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
					["Alcohol"] = true,
					["Money"] = true,
				}
			},
		},
		{
			text = "Stage",
			radius = 0.55,
			coords = vector3(110.0191, -1288.667, 29.25189),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Money"] = true,
				}
			},
		},
		{
			text = "Stage",
			radius = 0.55,
			coords = vector3(106.3664, -1294.381, 29.25908),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Money"] = true,
				}
			},
		},
		{
			text = "Stage",
			radius = 0.55,
			coords = vector3(103.0975, -1289.044, 29.24971),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Money"] = true,
				}
			},
		},
		{
			text = "Table",
			radius = 0.55,
			coords = vector3(113.3361, -1303.029, 29.89293),
			discrete = true,
			width = 4,
			height = 2,
			filters = {
				category = {
					["Food"] = true,
					["Drink"] = true,
					["Beverage"] = true,
					["Alcohol"] = true,
					["Money"] = true,
				}
			},
		},
	},
})

