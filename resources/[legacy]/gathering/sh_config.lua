Config = {
	["Mining"] = {
		Item = "Pickaxe",
		Decay = 0.02,
		QuickTime = {
			goalSize = 0.11,
			speed = 0.4,
			stages = 2,
		},
		Messages = {
			Action = "mine",
			Progress = "Mining...",
			Logging = "mined",
		},
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
			{
				Coords = vector3(2946.599609375, 2793.789306640625, 40.60781478881836), Radius = 100.0, Items = {
					{ "Iron Ore", {1,2}, 0.24 },
					{ "Coal", {1,4}, 0.2 },
					{ "Copper Ore", {1,2}, 0.16 },
					{ "Scrap Aluminum", {1,2}, 0.14 },
					{ "Lead", {1,4}, 0.1 },
					{ "Raw Quartz", {1,2}, 0.09 },
					{ "Sulfur", {1,2}, 0.08 },
					{ "Diamond", {1,2}, 0.006 },
					{ "Emerald", {1,2}, 0.005 },
					{ "Gold Nugget", 1, 0.005 },
					{ "Ruby", {1,2}, 0.004 },
					{ "Sapphire", {1,2}, 0.002 },
					{ "Barma Ruby", 1, 0.001 },
				}
			},
		},
		Materials = {
			[-840216541] = true,
		}
	},
	["Lumberjacking"] = {
		Item = "Wood Axe",
		Decay = 0.02,
		QuickTime = {
			goalSize = 0.11,
			speed = 0.4,
			stages = 2,
		},
		Messages = {
			Action = "chop",
			Progress = "Chopping...",
			Logging = "chopped",
		},
		Anim = {
			Dict = "melee@large_wpn@streamed_core",
			Name = "car_down_attack",
			Flag = 1,
			DisableMovement = true,
			Props = {
				{ Model = "prop_tool_fireaxe", Bone = 28422, Offset = { 0.04, -0.1, 0.0, -90.0, 180.0, 0.0 }},
			},
		},
		Sites = {
			{
				Coords = vector3(-676.63134765625, 5382.01904296875, 58.56132507324219), 
				Radius = 500.0, 
				Items = {
					{ "Wood Log", {1,4}, 1.0 },
					{ "Wood Branch", {1,3}, 0.5 },
					{ "Wood Bark", {1,3}, 0.02 },
				}
			},
		},
		Materials ={
			[-1915425863] = true,
			[581794674] = true, 
		}
	},
}
