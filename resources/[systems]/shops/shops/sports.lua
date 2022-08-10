Config.Filters.Sports = {
	item = {
		["Baseball Bat"] = true,
        ["Flashlight"] = true,
        ["Knife"] = true,
        ["Golf Club"] = true,
        ["Pool Cue"] = true,
        ["Parachute"] = true,
        ["Toothbrush"] = true,
	},
}

RegisterShop("SPORTS_1", {
    Name = "Palomino Sports",
    Clerks = {
        {
            coords = vector4(-945.6755, -1191.388, 4.973728, 169.1612),
            model = "a_f_m_bodybuild_01",
        },
    },
    Storage = {
        Coords = vector3(-948.1212, -1190.56, 4.797658),
        Radius = 2.0,
        Filters = Config.Filters.Sports,
    },
})

RegisterShop("SPORTS_2", {
    Name = "Procopio Sports",
    Clerks = {
        {
            coords = vector4(-773.7703, 5598.091, 33.59965, 208.7519),
            model = "a_f_m_bodybuild_01",
        },
    },
    Storage = {
        Coords = vector3(-770.8244, 5597.841, 33.60408),
        Radius = 2.0,
        Filters = Config.Filters.Sports,
    },
})