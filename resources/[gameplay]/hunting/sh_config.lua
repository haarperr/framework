Config = {
	Distance = 1.5,
	Action = {
		Anim = {
			Dict = "anim@treasurehunt@hatchet@action",
			Name = "hatchet_pickup",
			Flag = 0,
			DisableMovement = true,
		},
		Label = "Harvesting...",
		Duration = 10000,
		UseWhileDead = false,
		CanCancel = true,
		Disarm = true,
	},
	Tracking = {
		Effect = {
			Dict = "core",
			Name = "veh_respray_smoke",
			-- Dict = "weap_xs_weapons",
			-- Name = "exp_xs_ray",
			-- Name = "muz_xs_sr_raygun",
		},
	},
	Animals = {
		-- [-173013091] = {
		-- 	Name = "Human",
		-- 	Items = {
		-- 		{ "Mysterious Meat", {1,2}, 1.0 },
		-- 		{ "Large Bones", {1,2}, 0.2 },
		-- 	},
		-- },
		[GetHashKey("a_c_boar")] = {
			Name = "Boar",
			Items = {
				{ "Raw Pork", {2,4}, 1.0 },
				{ "Large Bones", {1,2}, 0.2 },
			},
		},
		[GetHashKey("a_c_pig")] = {
			Name = "Pig",
			Items = {
				{ "Raw Pork", {1,3}, 1.0 },
				{ "Large Bones", {1,2}, 0.2 },
			},
		},
		[GetHashKey("a_c_cow")] = {
			Name = "Cow",
			Items = {
				{ "Raw Beef", {3,4}, 1.0 },
				{ "Large Bones", {2,3}, 0.2 },
			},
		},
		[GetHashKey("a_c_hen")] = {
			Name = "Cock",
			Items = {
				{ "Raw Chicken", {1,3}, 1.0 },
				{ "Small Bones", {2,3}, 0.2 },
			},
		},
		-- [GetHashKey("a_c_pigeon")] = {
		-- 	Name = "Pigeon",
		-- 	Items = {
		-- 		{ "Raw Squab", {1,2}, 1.0 },
		-- 		{ "Small Bones", {2,3}, 0.2 },
		-- 	},
		-- },
		[GetHashKey("a_c_deer")] = {
			Name = "Deer",
			Items = {
				{ "Raw Venison", {1,3}, 1.0 },
				{ "Large Bones", {2,3}, 0.2 },
			},
		},
	},
	Zones = {
		["CANNY"] = { Max = 10, Spawns = { "a_c_deer", "a_c_boar" } },
		["CCREAK"] = { Max = 10, Spawns = { "a_c_deer", "a_c_boar" } },
		["CMSW"] = { Max = 10, Spawns = { "a_c_deer", "a_c_boar" } },
		["RTRAK"] = { Max = 4, Spawns = { "a_c_cow", "a_c_hen" } },
		["GRAPES"] = { Max = 4, Spawns = { "a_c_cow", "a_c_deer" } },
		["HARMO"] = { Max = 6, Spawns = { "a_c_deer" } },
		["MTCHIL"] = { Max = 6, Spawns = { "a_c_deer" } },
		["MTGORDO"] = { Max = 6, Spawns = { "a_c_deer" } },
		["PAL"] = { Max = 6, Spawns = { "a_c_deer" } },
		["SANCHIA"] = { Max = 10, Spawns = { "a_c_deer" } },
		["SANDY"] = { Max = 6, Spawns = { "a_c_deer" } },
		["TONGVAV"] = { Max = 6, Spawns = { "a_c_deer" } },
		["WINDF"] = { Max = 4, Spawns = { "a_c_cow", "a_c_deer" } },
	},
}