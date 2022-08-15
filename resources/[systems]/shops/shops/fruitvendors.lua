Config.Filters.Fruit = {
	blip = {
		name = "Furniture",
		id = 151,
		scale = 0.5,
		color = 31,
	},
	item = {
		["Orange"] = true,
        ["Apple"] = true,
        ["Lemon"] = true,
        ["Lemon Grass"] = true,
        ["Wheat"] = true,
        ["Potatoes"] = true,
        ["Rice"] = true,
        ["Honey"] = true,
        ["Salt"] = true,
        ["Butter"] = true,
        ["Book"] = true,
	},
}

RegisterShop("FRUIT_01", {
    Name = "Groceries",
    Clerks = {
        {
            coords = vector4(149.289, 1671.305, 228.6349, 168.821),
            model = "s_m_m_migrant_01",
        },
    },
    Storage = {
        Coords = vector3(149.289, 1671.305, 228.6349),
        Radius = 2.0,
        Filters = Config.Filters.Fruit,
    },
})

RegisterShop("FRUIT_02", {
    Name = "Groceries",
    Clerks = {
        {
            coords = vector4(-1043.363, 5326.754, 44.57051, 33.04679),
            model = "s_m_m_migrant_01",
        },
    },
    Storage = {
        Coords = vector3(-1043.363, 5326.754, 44.57051),
        Radius = 2.0,
        Filters = Config.Filters.Fruit,
    },
})