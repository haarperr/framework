Config = {
	Anim = {
		Dict = "melee@large_wpn@streamed_core",
		Name = "car_down_attack",
		Flag = 1,
		DisableMovement = true,
		Props = {
			{ Model = "prop_tool_pickaxe", Bone = 28422, Offset = { 0.04, -0.1, 0.0, -90.0, 180.0, 0.0 }},
		},
	},
	Sites = {
		{ Coords = vector3(2946.599609375, 2793.789306640625, 40.60781478881836), Radius = 100.0, Items = {
			{ "Copper Ore", {1,2}, 0.2 },
			{ "Iron Ore", {1,2}, 0.18 },
			{ "Scrap Aluminum", {1,2}, 0.19 },
			{ "Coal", {1,4}, 0.24 },
			{ "Lead", {1,4}, 0.15 },
			{ "Raw Quartz", {1,2}, 0.09 },
			{ "Sulfur", {1,2}, 0.18 },
			{ "Diamond", {1,2}, 0.006 },
			{ "Emerald", {1,2}, 0.005 },
			{ "Ruby", {1,2}, 0.004 },
			{ "Sapphire", {1,2}, 0.002 },
			{ "Gold Nugget", 1, 0.005 },
		} },
	},
	Materials = {
		[-840216541] = true,
	}
}