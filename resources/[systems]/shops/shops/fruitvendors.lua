Config.Filters.Fruit = {
	blip = {
		name = "Fruit Stand",
		id = 59,
		scale = 0.5,
		color = 8,
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
        ["Shredded Cheese"] = true,
        ["Tomato Sauce"] = true,
        ["Vegetable Oil"] = true,
        ["Olive Oil"] = true,
        ["Cup"] = true,
	},
}

RegisterShop("FRUIT_0001", {
    Name = "Groceries",
    Clerks = {
        {
            coords = vector4(148.785, 1670.633, 228.6587, 159.8428),
            model = "s_m_m_migrant_01",
        },
    },
    Storage = {
        Coords = vector3(149.289, 1671.305, 228.6349),
        Radius = 2.0,
        Filters = Config.Filters.Fruit,
    },
})

RegisterShop("FRUIT_0002", {
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