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
			DamageType = "Firearm",
			Items = {
				{ "Raw Pork", {1,3}, 1.0 },
				{ "Large Bones", {1,2}, 0.2 },
				{ "Animal Fat", {1,2}, 1.0 },
			},
		},
		[GetHashKey("a_c_pig")] = {
			Name = "Pig",
			DamageType = "Firearm",
			Items = {
				{ "Raw Pork", {1,2}, 1.0 },
				{ "Large Bones", {1,3}, 0.6 },
				{ "Animal Fat", {1,2}, 1.0 },
			},
		},
		[GetHashKey("a_c_cow")] = {
			Name = "Cow",
			DamageType = "Firearm",
			Items = {
				{ "Raw Beef", {1,2}, 1.0 },
				{ "Large Bones", {2,3}, 0.8 },
				{ "Cow Hide", {1,1}, 1.0 },
			},
		},
		[GetHashKey("a_c_hen")] = {
			Name = "Cock",
			DamageType = "Knife",
			Items = {
				{ "Raw Chicken", {1,2}, 1.0 },
				{ "Small Bones", {1,3}, 0.8 },
				{ "Chicken Feather", {2,5}, 1.0 },
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
			DamageType = "Firearm",
			Items = {
				{ "Raw Venison", {1,3}, 1.0 },
				{ "Large Bones", {1,4}, 1.0 },
				{ "Deer Skin", {1,1}, 1.0 },
			},
		},
		[GetHashKey("a_c_mtlion")] = {
			Name = "Mountain Lion",
			DamageType = "Firearm",
			Items = {
				{ "Lion Hide", 1, 1.0 },
				{ "Large Bones", {1,3}, 1.0 },
				{ "Lion Meat", {1,3}, 1.0 },
				{ "Diamond Ring", {0,1}, 0.001 },
			},
		},
	},
	Zones = {
		["CANNY"] = { Max = 3, Spawns = { "a_c_deer", "a_c_boar" }, Nerfed = true, minZ = 88.0, maxZ = 102.0 },
		["CCREAK"] = { Max = 3, Spawns = { "a_c_deer", "a_c_boar" }, Nerfed = true, minZ = 88.0, maxZ = 102.0 },
		["MTCHIL"] = { Max = 4, Spawns = { "a_c_deer" } },
		["SANCHIA"] = { Max = 2, Spawns = { "a_c_deer" } },
		["DESRT"] = { Max = 6, Spawns = { "a_c_hen" } },
	},
	Blacklist = {
		"CCREAK",
		"CANNY"
	},
}
