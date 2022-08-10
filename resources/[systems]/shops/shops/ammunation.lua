Config.Filters.Ammunation = {
	item = {
		["Body Armor"] = true,
        ["Flashlight"] = true,
        ["Combat Pistol"] = true,
        ["Pistol"] = true,
        ["9mm Parabellum Box"] = true,
        ["9mm Parabellum"] = true,
        ["9mm Magazine"] = true,
	},
}

RegisterShop("AMMU_1", {
    Name = "Adams Apple Ammunation",
    License = "weapons",
    Clerks = {
        {
            coords = vector4(17.15878, -1107.461, 29.79722, 162.4911),
        },
    },
    Storage = {
        Coords = vector3(18.97532, -1106.468, 29.79721),
        Radius = 2.0,
        Filters = Config.Filters.Ammunation,
    },
})