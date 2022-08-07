Config.Filters.Tool = {
	item = {
		-- Food.
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
	},
}

RegisterShop("TOOL_STORE", {
	Name = "Tool Store",
	Clerks = {
		{
			coords = vector4(46.71915, -1749.729, 29.63247, 46.54608),
		},
	},
	Storage = {
		Coords = vector3(44.62896, -1751.712, 29.30393),
		Radius = 2.0,
		Filters = Config.Filters.Tool,
	},
	}
)

