Config.Filters.Toolstore = {
	blip = {
		name = "Tool Shop",
		id = 544,
		scale = 0.5,
		color = 29,
	},
	item = {
		["Body Repair Kit"] = true,
		["Wood Axe"] = true,
		["Pickaxe"] = true,
		["Ziptie"] = true,
		["Rag"] = true,
		["Razor Blade"] = true,
		["Fishing Rod"] = true,
		["Wire Cutters"] = true,
		["Screwdriver"] = true,
		["Pliers"] = true,
		["Electrical Tape"] = true,
		["Knife"] = true,
		["Switchblade"] = true,
		["Magnetic Strip"] = true,
		["Scissors"] = true,
		["Paperclip"] = true,
		["Jerry Can"] = true,
	},
}

RegisterShop("TOOL_STORE_001", {
	Name = "Tool Store",
	Clerks = {
		{
			coords = vector4(46.71915, -1749.729, 29.63247, 46.54608),
			model = "mp_m_shopkeep_01",
		},
	},
	Storage = {
		Coords = vector3(45.00289, -1751.625, 29.62973),
		Radius = 2.0,
		Filters = Config.Filters.Toolstore,
	},
	}
)

RegisterShop("TOOL_STORE_002", {
	Name = "You Tool",
	Clerks = {
		{
			coords = vector4(2747.577, 3473.641, 55.67026, 240.63),
			model = "mp_m_shopkeep_01",
		},
	},
	Storage = {
		Coords = vector3(2749.651, 3477.858, 55.67157),
		Radius = 2.0,
		Filters = Config.Filters.Toolstore,
	},
	}
)

RegisterShop("TOOL_STORE_003", {
	Name = "Paleto Tool Store",
	Clerks = {
		{
			coords = vector4(-10.94127, 6499.157, 31.50511, 46.72627),
			model = "mp_m_shopkeep_01",
		},
	},
	Storage = {
		Coords = vector3(-9.822868, 6501.344, 31.50158),
		Radius = 2.0,
		Filters = Config.Filters.Toolstore,
	},
	}
)

