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
				coords = vector4(549.1334, 2670.873, 42.15649, 97.7182),
			},
		},
		Storage = {
			Coords = vector3(546.5003, 2662.695, 41.83086),
			Radius = 1.0,
			Filters = Config.Filters.Convenience,
		},
	},
}