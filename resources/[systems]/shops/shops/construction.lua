Config.Filters.Construction = {
	item = {
		["Assembly Joint"] = true,
        ["Wood Dye"] = true,
        ["Wooden Dowel"] = true,
        ["Screwdriver"] = true,
        ["White Vinegar"] = true,
        ["Concrete"] = true,
        ["Lead Granules"] = true,
        ["Screws"] = true,
	},
}

RegisterShop("CONSTRUCT_1", {
    Name = "Los Santos Construction",
    Clerks = {
        {
            coords = vector4(160.6125, -563.3377, 22.00956, 249.812),
            model = "s_m_y_construct_01",
        },
    },
    Storage = {
        Coords = vector3(160.6125, -563.3377, 22.00956),
        Radius = 2.0,
        Filters = Config.Filters.Construction,
    },
})
