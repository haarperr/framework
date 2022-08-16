Config.Filters.Furniture = {
	blip = {
		name = "Furniture",
		id = 151,
		scale = 0.5,
		color = 31,
	},
	item = {
		["Small Storage Container"] = true,
        ["Fridge"] = true,
        ["Potted Plant"] = true,
        ["Television"] = true,
        ["Lamp"] = true,
        ["Shelf"] = true,
        ["Candle"] = true,
        ["Rug"] = true,
        ["Pizza Oven"] = true,
        ["Statue"] = true,
        ["Book"] = true,
        ["Clutter"] = true,
        ["Workbench"] = true,
        ["Sideboard"] = true,
        ["Processor"] = true,
        ["Stove"] = true,
        ["Pot"] = true,
	},
}

RegisterShop("FURNITURE_01", {
    Name = "Los Santos Furniture",
    Clerks = {
        {
            coords = vector4(337.8811, -780.4745, 29.2665, 38.8387),
            model = "s_m_m_cntrybar_01",
        },
    },
    Storage = {
        Coords = vector3(337.6696, -780.3967, 29.26588),
        Radius = 2.0,
        Filters = Config.Filters.Furniture,
    },
})

RegisterShop("FURNITURE_02", {
    Name = "Paleto Furniture",
    Clerks = {
        {
            coords = vector4(-59.41235, 6443.507, 31.48982, 76.99243),
            model = "s_m_m_cntrybar_01",
        },
    },
    Storage = {
        Coords = vector3(-59.41235, 6443.507, 31.48982),
        Radius = 2.0,
        Filters = Config.Filters.Furniture,
    },
})