Config.Filters.Ammunation = {
	item = {
		["Body Armor"] = true,
        ["Flashlight"] = true,
        ["Combat Pistol"] = true,
        ["Stun Gun"] = true,
        ["Taser Cartridge"] = true,
        ["SNS Pistol Mk II"] = true,
        ["Vintage Pistol"] = true,
        ["Pistol Mk II"] = true,
        ["9mm Parabellum Box"] = true,
        ["9mm Parabellum"] = true,
        ["9mm Magazine"] = true,
        [".45 ACP Box"] = true,
        [".45 ACP"] = true,
        [".45 Magazine"] = true,
	},
}

RegisterShop("AMMUN_1", {
    Name = "Adams Apple Ammunation",
    License = "weapons",
    Clerks = {
        {
            coords = vector4(17.15878, -1107.461, 29.79722, 162.4911),
            model = "csb_jackhowitzer",
        },
    },
    Storage = {
        Coords = vector3(18.97532, -1106.468, 29.79721),
        Radius = 2.0,
        Filters = Config.Filters.Ammunation,
    },
})