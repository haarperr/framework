Config.Filters.Fish = {
	blip = {
		name = "Deep Water Fish Shop",
		id = 317,
		scale = 0.5,
		color = 29,
	},
	item = {
        ["Albacore"] = true,
        ["Amberjack"] = true,
        ["Barracuda"] = true,
        ["Bigeye Tuna"] = true,
        ["Bluefin Tuna"] = true,
        ["Bonito"] = true,
        ["Chinook Salmon"] = true,
        ["Coho Salmon"] = true,
        ["Mackerel"] = true,
        ["Skipjack Tuna"] = true,
        ["Striped Marlin"] = true,
        ["Swordfish"] = true,
        ["Yellowfin Tuna"] = true,
	},
}

RegisterShop("FISH_SALES04", {
	Name = "Deep Water Fish Shop",
	Clerks = {
		{
			coords = vector4(281.2023, -803.2744, 29.3168, 291.3471),
			model = "cs_omega",
		},
	},
	Storage = {
		Coords = vector3(281.2023, -803.2744, 29.3168),
		Radius = 2.0,
		Filters = Config.Filters.Fish,
	},
    Decorations = {
		["deepfish"] = {
			item = "Deep Water Fish Sales",
			invisible = true,
			coords = vector3(281.2000, -800.6874, 29.3168),
			rotation = vector3(-10.06761, -2.134434e-07, 72.5066),
		},
		},
	}
)