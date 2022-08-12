Config.Filters.Playpharm = {
	item = {
		["Gauze"] = true,
		["Bandage"] = true,
        ["Acetic Anhydride"] = true,
        ["Ammonium Chloride"] = true,
        ["Bleach"] = true,
        ["Calcium Oxide"] = true,
        ["Calcium Powder"] = true,
        ["Caustic Soda"] = true,
        ["Codeine"] = true,
        ["Hydrochloric Acid"] = true,
        ["Iodine"] = true,
        ["Hydrogen Peroxide"] = true,
        ["Sodium Carbonate"] = true,
        ["Syringe"] = true,
	},
}

RegisterShop("VESPUCCI_PPH1", {
	Name = "Vespucci Pharmacy",
	Clerks = {
		{
			coords = vector4(325.8376, -1074.447, 29.47332, 8.688439),
			model = "s_m_m_doctor_01",
		},
	},
	Storage = {
		Coords = vector3(325.7496, -1074.454, 29.47332),
		Radius = 2.0,
		Filters = Config.Filters.Playpharm,
	},
	}
)

RegisterShop("PALETO_PPH", {
	Name = "Vespucci Pharmacy",
	Clerks = {
		{
			coords = vector4(-172.9113, 6381.258, 31.47294, 222.8688),
			model = "s_m_m_doctor_01",
		},
	},
	Storage = {
		Coords = vector3(-172.9113, 6381.258, 31.47294),
		Radius = 2.0,
		Filters = Config.Filters.Playpharm,
	},
	}
)