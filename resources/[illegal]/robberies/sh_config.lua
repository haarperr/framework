Config = {
	EnableDebug = false,
	ResetTime = 30,
	Messages = {
		Cooldown = "On temporary lockdown for %s minutes!",
		InsufficientPresence = "There is an increase in security right now... (%s/%s)",
	},
	Robbables = {
		["register"] = {
			Stages = {
				{
					Anim = {
						Dict = "missmechanic",
						Name = "work2_base",
						Flag = 49,
						Props = {
							{ Model = "prop_tool_screwdvr01", Bone = 60309, Offset = { 0.0, 0.0, -0.1, 0.0, 0.0, 0.0 }},
						},
						DisableMovement = true,
					},
					Label = "Lockpicking",
					Duration = 5000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
				{
					Anim = {
						Dict = "oddjobs@shop_robbery@rob_till",
						Name = "loop",
						Flag = 17,
						DisableMovement = true,
					},
					Label = "Taking",
					Duration = 30000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
			},
			Items = {
				"Lockpick",
			},
			Output = {
				{ Name = "Bills", Amount = {1250, 2000}, Chance = 1.0 },
				{ Name = "Lockpick", Amount = 1, Chance = 0.06 },
				{ Name = "Joint", Amount = 1, Chance = 0.03 },
				{ Name = "Weed", Amount = {1,2}, Chance = 0.03 },
			},
			Models = {
				["prop_till_01"] = { Offset = vector3(0.0, -0.6, 0.0) },
				["p_till_01_s"] = { Offset = vector3(0.0, -0.6, 0.0) },
				["prop_till_01_dam"] = { Offset = vector3(0.0, -0.6, 0.0) },
				["prop_till_01"] = { Offset = vector3(0.0, -0.6, 0.0) },
				["prop_till_02"] = { Offset = vector3(0.0, -0.6, 0.0) },
			}
		},
		["jewelstorage"] = {
			Stages = {
				{
					Anim = {
						Dict = "anim@heists@humane_labs@emp@hack_door",
						Name = "hack_loop",
						Flag = 49,
						Props = {
							{ Model = "p_amb_phone_01", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }},
						},
					},
					Label = "Hacking...",
					Duration = 140000,
					UseWhileDead = false,
					DisableMovement = true,
					CanCancel = false,
					Disarm = true,
				},
				{
					Anim = {
						Dict = "anim@heists@money_grab@duffel",
						Name = "loop",
						Flag = 1,
						DisableMovement = true,
					},
					Label = "Taking...",
					Duration = 120000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
			},
			Items = {
				"Diamond Keycard",
			},
			Output = {
				{ Name = "Marked Bills", Amount = {10500, 14600}, Chance = 1.0 },
				{ Name = "Gold Bar", Amount = 1, Chance = 1.0 },
			},
		},
		["safe"] = {
			Stages = {
				{
					Anim = {
						Dict = "mini@safe_cracking",
						Name = "dial_turn_anti_fast_1",
						Flag = 49,
					},
					Label = "Cracking",
					Duration = 60000,
					UseWhileDead = false,
					DisableMovement = true,
					CanCancel = false,
					Disarm = true,
				},
				{
					Anim = {
						Dict = "anim@heists@money_grab@duffel",
						Name = "loop",
						Flag = 1,
						DisableMovement = true,
					},
					Label = "Taking",
					Duration = 90000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
			},
			Items = {
				"Safe Cracking Tool",
			},
			Output = {
				{ Name = "Marked Bills", Amount = {3000, 5000}, Chance = 1.0 },
				{ Name = "Red Keycard", Amount = 1, Chance = 0.20 },
				{ Name = "Lockpick", Amount = {1,2}, Chance = 0.25 },
				{ Name = "Joint", Amount = {2,6}, Chance = 0.40 },
				{ Name = "Weed", Amount = {4,12}, Chance = 0.40 },
				{ Name = "Diamond", Amount = {3,6}, Chance = 0.70 },
			},
		},
		["safe2"] = {
			Stages = {
				{
					Anim = {
						Dict = "anim@heists@humane_labs@emp@hack_door",
						Name = "hack_loop",
						Flag = 49,
						Props = {
							{ Model = "p_amb_phone_01", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }},
						},
					},
					Label = "Hacking...",
					Duration = 60000,
					UseWhileDead = false,
					DisableMovement = true,
					CanCancel = false,
					Disarm = true,
				},
				{
					Anim = {
						Dict = "anim@heists@money_grab@duffel",
						Name = "loop",
						Flag = 1,
						DisableMovement = true,
					},
					Label = "Taking...",
					Duration = 90000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
			},
			Items = {
				"Hacking Tool",
			},
			Output = {
				{ Name = "Marked Bills", Amount = {3000, 5000}, Chance = 1.0 },
				{ Name = "Green Keycard", Amount = 1, Chance = 0.2 },
				{ Name = "Lockpick", Amount = {1,2}, Chance = 0.50 },
				{ Name = "Joint", Amount = {2,6}, Chance = 0.40 },
				{ Name = "Weed", Amount = {4,12}, Chance = 0.40 },
				{ Name = "Diamond", Amount = {3,6}, Chance = 0.70 },
			},
		},
		["keypad"] = {
			Stages = {
				{
					Anim = {
						Dict = "anim@heists@humane_labs@emp@hack_door",
						Name = "hack_loop",
						Flag = 49,
						Props = {
							{ Model = "p_amb_phone_01", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }},
						},
					},
					Hack = {
						Length = {7, 6, 5, 4, 3, 2, 1},
						Duration = 600,
					},
				},
			},
		},
		["keypad_swipe"] = {
			Stages = {
				{
					Anim = {
						Dict = "mp_common_miss",
						Name = "card_swipe",
						Flag = 48,
						DisableMovement = true,
					},
					QTE = { 60.0 },
				},
			},
		},
		["electrical"] = {
			Stages = {
				{
					Anim = {
						Dict = "misstrevor2ig_7",
						Name = "plant_bomb",
						Flag = 1,
						DisableMovement = true,
					},
					QTE = {
						80.0, 70.0, 60.0, 50.0, 40.0, 30.0, 20.0, 10.0
					},
				},
			},
			Items = {
				"Thermite",
			},
		},
		["lockbox"] = {
			Stages = {
				{
					Anim = {
						Dict = "misstrevor2ig_7",
						Name = "plant_bomb",
						Flag = 1,
						DisableMovement = true,
					},
					Label = "Planting...",
					Duration = 10000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
				{
					Anim = {
						Dict = "anim@heists@ornate_bank@grab_cash",
						Name = "grab",
						Flag = 0,
						DisableMovement = true,
					},
					Label = "Taking Goods...",
					Duration = 10000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
			},
			Items = {
				"Thermite",
			},
			Output = {
				{ Name = "Valuable Goods", Amount = 1, Chance = 0.6 },
				{ Name = "Marked Bills", Amount = {5000, 7500}, Chance = 1.0 },
				{ Name = "Blue Keycard", Amount = 1, Chance = 0.10 },
				{ Name = "Green Keycard", Amount = 1, Chance = 0.10 },
				{ Name = "Barma Ruby", Amount = 1, Chance = 0.02 },
				{ Name = "Red Keycard", Amount = 1, Chance = 0.15 },
				{ Name = "Black Keycard", Amount = 1, Chance = 0.05 },
			},
		},
		["drillbox"] = {
			Stages = {
				{
					Anim = {
						Dict = "anim@heists@fleeca_bank@drilling",
						Name = "drill_right",
						Flag = 1,
						Props = {
							{ Model = "hei_prop_heist_drill", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }},
						},
					},
					Drill = {

					},
				},
			},
			Items = {
				"Drill",
			},
		},
		["crate"] = {
			Stages = {
				{
					Anim = {
						Dict = "missmechanic",
						Name = "work2_base",
						Flag = 1,
						Props = {
							{ Model = "prop_tool_screwdvr01", Bone = 60309, Offset = { 0.0, 0.0, -0.1, 0.0, 0.0, 0.0 }},
						},
						DisableMovement = true,
					},
					Label = "Lockpicking",
					Duration = 5000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
				{
					Anim = {
						Dict = "anim@heists@ornate_bank@grab_cash",
						Name = "grab",
						Flag = 0,
						DisableMovement = true,
					},
					Label = "Taking Goods...",
					Duration = 10000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
			},
			Items = {
				"Lockpick",
			},
			Output = {
				{ Name = "Gold Bar", Amount = 1, Chance = 1.9 },
				{ Name = "Marked Bills", Amount = {1500, 3000}, Chance = 0.1 },
			},
		},
		["cabinet"] = {
			Stages = {
				{
					Anim = {
						Dict = "missmechanic",
						Name = "work2_base",
						Flag = 1,
						Props = {
							{ Model = "prop_tool_screwdvr01", Bone = 60309, Offset = { 0.0, 0.0, -0.1, 0.0, 0.0, 0.0 }},
						},
					},
					Label = "Lockpicking...",
					Duration = 10000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
					DisableMovement = true,
				},
				{
					Anim = {
						Dict = "anim@heists@ornate_bank@grab_cash",
						Name = "grab",
						Flag = 0,
						DisableMovement = true,
					},
					Label = "Rummaging...",
					Duration = 10000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
			},
			Items = {
				"Lockpick",
			},
		},
		["computer"] = {
			Stages = {
				{
					Anim = {
						Dict = "anim@gangops@morgue@office@laptop@",
						Name = "enter",
						Flag = 1,
						Props = {
							{ Model = "hei_prop_hst_usb_drive", Bone = 60309, Offset = { 0.0, 0.0, -0.1, 0.0, 0.0, 0.0 }},
						},
						DisableMovement = true,
					},
					Label = "Entering Device...",
					Duration = 2000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
				{
					Anim = {
						Dict = "anim@gangops@morgue@office@laptop@",
						Name = "idle",
						Flag = 49,
						DisableMovement = true,
					},
					Label = "Running Programs...",
					Duration = 30000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
				{
					Anim = {
						Dict = "anim@gangops@morgue@office@laptop@",
						Name = "exit",
						Flag = 49,
						DisableMovement = true,
					},
					Label = "Finishing Up...",
					Duration = 2000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
			},
		},
		["jewelry"] = {
			Stages = {
				{
					Anim = {
						Dict = "melee@small_wpn@streamed_core",
						Name = "car_down_attack",
						Flag = 48,
						DisableMovement = true,
						Props = {
							{ Model = "v_ind_cs_mallet", Bone = 6286, Offset = { 0.05, 0.1, 0.02, 24.0, 0.0, -18.0 }},
						},
					},
					Duration = 8000,
					Label = "Smashing...",
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
				{
					Anim = {
						Dict = "oddjobs@shop_robbery@rob_till",
						Name = "loop",
						Flag = 1,
						DisableMovement = true,
					},
					Label = "Stealing...",
					Duration = 27000,
					UseWhileDead = false,
					CanCancel = false,
					Disarm = true,
				},
			},
			Items = {
				"Diamond Hammer",
			},
			Output = {
				{ Name = "Diamond", Amount = {2,4}, Chance = 1.0 },
				{ Name = "Ruby", Amount = {1,3}, Chance = 1.0 },
				{ Name = "Saphire", Amount = {1,4}, Chance = 1.0 },
				{ Name = "Emerald", Amount = {0,3}, Chance = 1.0 },
				{ Name = "Barma Ruby Ring", Amount = {0,1}, Chance = 0.006 },
			},
		},
		["key"] = {
			Stages = {
				{
					Anim = {
						Dict = "anim@heists@keypad@",
						Name = "enter",
						Flag = 2,
					},
					Label = "Starting...",
					Duration = 2000,
				},
				{
					Anim = {
						Dict = "anim@heists@keypad@",
						Name = "idle_a",
						Flag = 1,
					},
					Label = "Unlocking...",
					Duration = 10000,
					UseWhileDead = false,
					DisableMovement = true,
					CanCancel = false,
					Disarm = true,
				},
				{
					Anim = {
						Dict = "anim@heists@keypad@",
						Name = "exit",
						Flag = 1,
					},
					Label = "Finishing...",
					Duration = 2000,
				},
			},
		},
	},
	Robberies = {
		Categories = {
			["small"] = {
				Cooldown = 20,
			},
			["medium"] = {
				Cooldown = 60,
			},
			["large"] = {
				Cooldown = 360,
			},
		},
		Types = {
			["Convenience Store"] = {
				Category = "small",
				MinPresence = 2,
				InformPolice = true,
			},
			["Liquor Store"] = {
				Category = "small",
				MinPresence = 2,
				InformPolice = true,
			},
			["Bank"] = {
				Category = "medium",
				MinPresence = 4,
				InformPolice = true,
			},
			["Jewelry"] = {
				Category = "large",
				MinPresence = 6,
				InformPolice = true,
			},
			["Humane"] = {
				Category = "large",
				MinPresence = 6,
				InformPolice = true,
			},
			["BigBank"] = {
				Category = "large",
				MinPresence = 6,
				InformPolice = true,
			},
		},
		Sites = {
			--[[ Convenience ]]--
			{
				Name = "Downtown Vinewood",
				Type = "Convenience Store",
				Center = vector3(377.9775390625, 326.87213134766, 103.56639099121),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(380.7575073242188, 332.58349609375, 103.56636810302736, 257.50408935546875),
					}},
				},
			},
			{
				Name = "Chiliad",
				Type = "Convenience Store",
				Center = vector3(1733.0947265625, 6415.427734375, 35.162433624268),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(1737.136962890625, 6419.5361328125, 35.03720092773437, 241.68966674804688),
					}},
				},
			},
			{
				Name = "Banham Canyon",
				Type = "Convenience Store",
				Center = vector3(-3043.2700195313, 588.60424804688, 7.9089293479919),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(-3048.479248046875, 588.248779296875, 7.90885543823242, 17.62711715698242),
					}},
				},
			},
			{
				Name = "Grapeseed",
				Type = "Convenience Store",
				Center = vector3(1702.4029541016, 4926.0805664063, 42.063629150391),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(1707.9051513672, 4920.4638671875, 42.063629150391, 335.17602539063),
					}},
				},
			},
			{
				Name = "Sandy Shores",
				Type = "Convenience Store",
				Center = vector3(1963.2877197266, 3744.7551269531, 32.343738555908),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(1961.5955810546875, 3750.0478515625, 32.3437271118164, 301.6848449707031),
					}},
				},
			},
			{
				Name = "Harmony",
				Type = "Convenience Store",
				Center = vector3(544.38342285156, 2668.4165039063, 42.156490325928),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(543.8250732421875, 2662.6123046875, 42.15647506713867, 94.3043975830078),
					}},
				},
			},
			{
				Name = "Senora Fwy",
				Type = "Convenience Store",
				Center = vector3(2678.2565917969, 3285.1193847656, 55.241123199463),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(2672.75390625, 3286.7185058594, 55.24112701416, 59.721073150635),
					}},
				},
			},
			{
				Name = "Palomino Fwy",
				Type = "Convenience Store",
				Center = vector3(2555.1096191406, 386.06909179688, 108.62293243408),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(2549.4736328125, 387.4703063964844, 108.62297058105467, 356.7353820800781),
					}},
				},
			},
			{
				Name = "Palomino Fwy",
				Type = "Convenience Store",
				Center = vector3(2555.1096191406, 386.06909179688, 108.62293243408),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(2549.1882324219, 384.95104980469, 108.62293243408, 90.071022033691),
					}},
				},
			},
			{
				Name = "Richman Glen",
				Type = "Convenience Store",
				Center = vector3(-1825.4011230469, 792.63500976563, 138.19227600098),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(-1829.2590332031, 798.82141113281, 138.19187927246, 139.10377502441),
					}},
				},
			},
			{
				Name = "Mirror Park",
				Type = "Convenience Store",
				Center = vector3(1159.365234375, -321.47192382813, 69.205047607422),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(1159.5002441406, -313.97952270508, 69.205047607422, 112.25310516357),
					}},
				},
			},
			{
				Name = "Grove Street",
				Type = "Convenience Store",
				Center = vector3(-48.604434967041, -1753.2189941406, 29.421014785767),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(-43.508350372314, -1748.3840332031, 29.421020507813, 50.213455200195),
					}},
				},
			},
			{
				Name = "Little Seoul",
				Type = "Convenience Store",
				Center = vector3(-711.10052490234, -911.84265136719, 19.215585708618),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(-709.68237304688, -904.16809082031, 19.215585708618, 87.91544342041),
					}},
				},
			},
			{
				Name = "Innocence Blvd",
				Type = "Convenience Store",
				Center = vector3(29.453075408936, -1344.6448974609, 29.497024536133),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(30.88002586364746, -1339.3118896484375, 29.49697303771972, 270.672119140625),
					}},
				},
			},
			{
				Name = "Chumash",
				Type = "Convenience Store",
				Center = vector3(-3244.5666503906, 1004.6326904297, 12.830706596375),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(-3249.68017578125, 1007.0509643554688, 12.83064842224121, 354.0852661132813),
					}},
				},
			},
			{
				Name = "Paleto",
				Type = "Convenience Store",
				Center = vector3(166.17381286621097, 6640.14208984375, 31.71062850952148),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(170.58346557617188, 6642.67578125, 31.69890785217285, 226.49822998046875),
					}},
				},
			},
			{
				Name = "Morningwood",
				Type = "Convenience Store",
				Center = vector3(-1423.608154296875, -265.1828308105469, 46.3504409790039),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe2", Coords = {
						vector4(-1417.0916748046875, -261.4761047363281, 46.3790168762207, 40.2485122680664),
					}},
				},
			},
			--[[ Liquor Store ]]--
			{
				Name = "Prosperity",
				Type = "Liquor Store",
				Center = vector3(-1483.0372314453, -376.53033447266, 40.163425445557),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe", Coords = {
						vector4(-1478.9112548828, -375.37426757813, 39.16340637207, -134.67640686035),
					}}
				},
			},
			{
				Name = "Great Ocean Highway",
				Type = "Liquor Store",
				Center = vector3(-2966.4519042969, 390.80426025391, 15.043314933777),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe", Coords = {
						vector4(-2959.6799316406, 387.05981445313, 14.043293952942, 177.80445861816),
					}}
				},
			},
			{
				Name = "El Rancho Blvd",
				Type = "Liquor Store",
				Center = vector3(1134.2449951172, -982.60424804688, 46.415798187256),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe", Coords = {
						vector4(1126.7998046875, -980.05847167969, 45.415832519531, 12.381150245667),
					}}
				},
			},
			{
				Name = "Vespucci Canals",
				Type = "Liquor Store",
				Center = vector3(-1222.0015869141, -908.29229736328, 12.326356887817),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe", Coords = {
						vector4(-1220.8616943359, -916.07708740234, 11.326334953308, 125.43096923828),
					}}
				},
			},
			{
				Name = "Route 68",
				Type = "Liquor Store",
				Center = vector3(1166.4122314453, 2710.94140625, 38.157699584961),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe", Coords = {
						vector4(1168.8485107422, 2717.859375, 37.157562255859, 264.60321044922),
					}}
				},
			},
			{
				Name = "Paleto",
				Type = "Liquor Store",
				Center = vector3(-159.1403350830078, 6324.2421875, 31.58688354492187),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe", Coords = {
						vector4(-168.46701049804688, 6318.78564453125, 30.58686256408691, 42.65053558349609),
					}}
				},
			},
			{
				Name = "Sandy",
				Type = "Liquor Store",
				Center = vector3(1393.63427734375, 3608.193359375, 34.98088455200195),
				Robbables = {
					{ Id = "register" },
					{ Id = "safe", Coords = {
						vector4(1394.966552734375, 3613.950439453125, 34.9809341430664, 20.08716773986816),
					}}
				},
			},
			--[[ Banks ]]--
			{
				Name = "Pacific Standard",
				Type = "BigBank",
				Center = vector3(251.68597412109, 220.39694213867, 107.4554901123),
				Radius = 50.0,
				RegisterDoors = true,
				Robbables = {
					-- First stage: top doors.
					{
						Id = "keypad",
						Coords = {
							vector4(261.94366455078, 223.14025878906, 106.28412628174, 253.68258666992)
						},
						Unlocks = {
							vector3(262.19808959961, 222.51879882813, 106.42955780029),
							vector3(256.31155395508, 220.65785217285, 106.42955780029),
						},
						Items = { "Brown Keycard" },
					},
					-- Second stage: vault door.
					{
						Id = "keypad",
						Coords = { vector4(253.24989318848, 228.38319396973, 101.68328094482, 69.527816772461) },
						Unlocks = { vector3(255.22825622559, 223.97601318359, 102.39321899414) },
						Items = { "Brown Keycard" },
					},
					-- Final stage: loot.
					{
						Id = "lockbox",
						Coords = {
							vector4(258.17916870117, 218.10890197754, 101.68346405029, 342.15524291992),
							vector4(259.59515380859, 217.49711608887, 101.68346405029, 340.09521484375),
							vector4(261.09252929688, 217.11462402344, 101.68346405029, 349.02883911133),
							vector4(263.34353637695, 216.32708740234, 101.68346405029, 347.9567565918),
							vector4(264.60192871094, 215.78988647461, 101.68346405029, 346.51644897461),
							vector4(266.06744384766, 215.23239135742, 101.68346405029, 356.45422363281),
							vector4(266.10479736328, 214.73373413086, 101.68346405029, 256.79290771484),
							vector4(265.71151733398, 213.4893951416, 101.68346405029, 258.72463989258),
							vector4(265.30511474609, 212.37396240234, 101.68346405029, 253.91473388672),
							vector4(264.61572265625, 212.26393127441, 101.68346405029, 158.12306213379),
							vector4(263.43124389648, 212.58543395996, 101.68346405029, 176.6276550293),
							vector4(262.21124267578, 213.1026763916, 101.68346405029, 158.48345947266),
							vector4(259.837890625, 213.98301696777, 101.68346405029, 165.41535949707),
							--vector4(258.37365722656, 214.53475952148, 101.68346405029, 161.1852722168),
							--vector4(256.83331298828, 215.05879211426, 101.68346405029, 171.20146179199),
						},
					},
				},
			},
			{
				Name = "Blaine County Savings",
				Type = "Bank",
				Center = vector3(-108.1021194458, 6471.7890625, 31.626708984375),
				Radius = 40.0,
				RegisterDoors = true,
				Robbables = {
					{
						Id = "keypad",
						Coords = {
							vector4(-105.6590423584, 6471.8740234375, 31.626710891724, 44.672233581543)
						},
						Unlocks = {
							vector3(-104.60489654541, 6473.4438476563, 31.795324325562),
						},
						Items = { "Red Keycard" },
					},
					{
						Id = "lockbox",
						Coords = {
							vector4(-106.83989715576, 6473.7822265625, 31.62671661377, 129.49356079102),
							vector4(-107.54365539551, 6475.4375, 31.62671661377, 44.569351196289),
							vector4(-105.64981842041, 6478.2983398438, 31.626724243164, 42.255214691162),
							vector4(-104.14318847656, 6478.65625, 31.626714706421, 317.42749023438),
							vector4(-102.8226776123, 6477.3671875, 31.648992538452, 313.60803222656),
							vector4(-103.23392486572, 6475.8081054688, 31.650077819824, 226.50801086426),
						},
					},
				},
			},
			--[[{
				Name = "Legion Square Fleeca",
				Type = "Bank",
				Center = vector3(146.76416015625, -1042.3675537109, 29.35502243042),
				Radius = 20.0,
				RegisterDoors = true,
				Robbables = {
					{
						Id = "keypad",
						Coords = {
							vector4(146.65238952637, -1045.9155273438, 29.368062973022, 237.57504272461)
						},
						Unlocks = {
							vector3(148.02661132813, -1044.3638916016, 29.506931304932),
						},
						Items = { "Green Keycard" },
					},
					{
						Id = "lockbox",
						Coords = {
							vector4(150.45735168457, -1049.0686035156, 29.346368789673, 251.63217163086),
							vector4(150.03422546387, -1050.2464599609, 29.346395492554, 245.88400268555),
							vector4(149.00352478027, -1050.4237060547, 29.346382141113, 161.39410400391),
							vector4(147.64898681641, -1050.1656494141, 29.346380233765, 156.41217041016),
							vector4(147.09817504883, -1049.2528076172, 29.346334457397, 70.42049407959),
							vector4(147.44898986816, -1048.1478271484, 29.346305847168, 70.905654907227),
							vector4(150.86470031738, -1046.4660644531, 29.346321105957, 248.17013549805),
							vector4(149.79965209961, -1045.1959228516, 29.346292495728, 337.58755493164),
						},
					},
				},
			},]]--
			{
				Name = "Great Ocean Highway Fleeca",
				Type = "Bank",
				Center = vector3(-2960.1005859375, 481.53509521484, 15.694672584534),
				Radius = 30.0,
				RegisterDoors = true,
				Robbables = {
					{
						Id = "keypad",
						Coords = {
							vector4(-2956.8181152344, 481.52600097656, 15.69704914093, 325.39584350586)
						},
						Unlocks = {
							vector3(-2958.5385742188, 482.27056884766, 15.83594417572),
						},
						Items = { "Green Keycard" },
					},
					{
						Id = "lockbox",
						Coords = {
							vector4(-2958.1977539063, 484.18240356445, 15.675290107727, 88.88117980957),
							vector4(-2957.3857421875, 485.54675292969, 15.675330162048, 4.1140117645264),
							vector4(-2954.6391601563, 486.0475769043, 15.675391197205, 0.35716944932938),
							vector4(-2953.3537597656, 486.06213378906, 15.675423622131, 346.54940795898),
							vector4(-2952.7182617188, 485.13607788086, 15.675386428833, 280.10342407227),
							vector4(-2952.8420410156, 483.36663818359, 15.675375938416, 262.89129638672),
							vector4(-2953.4077148438, 482.64279174805, 15.675329208374, 178.95722961426),
							vector4(-2954.9208984375, 482.74066162109, 15.675303459167, 192.57048034668),
						},
					},
				},
			},
			{
				Name = "Route 68 Fleeca",
				Type = "Bank",
				Center = vector3(1177.2100830078, 2713.5444335938, 38.066242218018),
				Radius = 30.0,
				RegisterDoors = true,
				Robbables = {
					{
						Id = "keypad",
						Coords = {
							vector4(1175.9929199219, 2712.7785644531, 38.088035583496, 64.560249328613)
						},
						Unlocks = {
							vector3(1175.5421142578, 2710.861328125, 38.226890563965),
						},
						Items = { "Green Keycard" },
					},
					{
						Id = "lockbox",
						Coords = {
							vector4(1173.7165527344, 2711.0847167969, 38.066242218018, 184.42008972168),
							vector4(1172.2393798828, 2712.0085449219, 38.066253662109, 94.273643493652),
							vector4(1171.4698486328, 2714.439453125, 38.066314697266, 101.4554977417),
							vector4(1171.6336669922, 2716.0073242188, 38.066349029541, 92.728149414063),
							vector4(1172.3608398438, 2716.5727539063, 38.066345214844, 353.20568847656),
							vector4(1174.1638183594, 2716.6079101563, 38.066345214844, 14.104368209839),
							vector4(1174.9188232422, 2715.8000488281, 38.066299438477, 267.8542175293),
							vector4(1174.9547119141, 2714.2900390625, 38.066265106201, 273.181640625),
						},
					},
				},
			},
			--[[{
				Name = "Hawick Alta Fleeca",
				Type = "Bank",
				Center = vector3(310.90866088867, -284.16845703125, 54.164768218994),
				Radius = 30.0,
				RegisterDoors = true,
				Robbables = {
					{
						Id = "keypad",
						Coords = {
							vector4(310.90866088867, -284.16845703125, 54.164768218994, 234.42242431641)
						},
						Unlocks = {
							vector3(312.35800170898, -282.73013305664, 54.303646087646),
						},
						Items = { "Green Keycard" },
					},
					{
						Id = "lockbox",
						Coords = {
							vector4(314.00421142578, -283.51763916016, 54.142993927002, 339.26080322266),
							vector4(315.21215820313, -284.92947387695, 54.143009185791, 254.87409973145),
							vector4(314.94000244141, -287.47549438477, 54.143070220947, 259.13903808594),
							vector4(314.40521240234, -288.8176574707, 54.143100738525, 258.46829223633),
							vector4(313.54635620117, -289.19934082031, 54.143100738525, 164.82737731934),
							vector4(311.68103027344, -288.42895507813, 54.143081665039, 166.41595458984),
							vector4(311.25888061523, -287.63150024414, 54.143054962158, 80.424499511719),
							vector4(311.72146606445, -286.26651000977, 54.143020629883, 68.955718994141),
						},
					},
				},
			},]]--
			{
				Name = "Boulevard Del Perro Fleeca",
				Type = "Bank",
				Center = vector3(-1211.0947265625, -336.43792724609, 37.781017303467),
				Radius = 30.0,
				RegisterDoors = true,
				Robbables = {
					{
						Id = "keypad",
						Coords = {
							vector4(-1211.0947265625, -336.43792724609, 37.781017303467, 273.5866394043),
						},
						Unlocks = {
							vector3(-1211.2609863281, -334.55960083008, 37.919891357422),
						},
						Items = { "Green Keycard" },
					},
					{
						Id = "lockbox",
						Coords = {
							vector4(-1209.4451904297, -333.88812255859, 37.759254455566, 23.263771057129),
							vector4(-1207.7529296875, -333.98846435547, 37.759258270264, 309.41271972656),
							vector4(-1206.0979003906, -335.83090209961, 37.759311676025, 309.61437988281),
							vector4(-1205.3218994141, -337.37734985352, 37.759346008301, 304.36184692383),
							vector4(-1205.7510986328, -338.0583190918, 37.759346008301, 197.81100463867),
							vector4(-1207.623046875, -338.98324584961, 37.759330749512, 212.63702392578),
							vector4(-1208.3920898438, -338.61978149414, 37.759300231934, 122.75311279297),
							vector4(-1209.0201416016, -337.46514892578, 37.759273529053, 114.67604064941),
						},
					},
				},
			},
			{
				Name = "Hawick Burton Fleeca",
				Type = "Bank",
				Center = vector3(-354.10775756836, -55.036827087402, 49.036552429199),
				Radius = 30.0,
				RegisterDoors = true,
				Robbables = {
					{
						Id = "keypad",
						Coords = {
							vector4(-354.10775756836, -55.036827087402, 49.036552429199, 233.99066162109)
						},
						Unlocks = {
							vector3(-352.7364807128906, -53.57247543334961, 49.17543411254883),
						},
						Items = { "Green Keycard" },
					},
					{
						Id = "lockbox",
						Coords = {
							vector4(-350.94677734375, -54.46981048584, 49.014789581299, 343.78894042969),
							vector4(-349.96099853516, -55.579711914063, 49.014793395996, 258.28460693359),
							vector4(-350.13784790039, -58.35179901123, 49.01485824585, 261.11868286133),
							vector4(-350.75845336914, -59.694267272949, 49.014877319336, 254.62622070313),
							vector4(-351.4665222168, -59.964466094971, 49.014877319336, 169.87905883789),
							vector4(-353.44491577148, -59.279731750488, 49.014869689941, 168.26387023926),
							vector4(-353.79632568359, -58.557247161865, 49.014835357666, 79.18229675293),
							vector4(-353.23724365234, -57.21964263916, 49.014820098877, 74.189987182617),
						},
					},
				},
			},
			{
				Name = "Humane Labs",
				Type = "Humane",
				Center = vector3(3531.77294921875, 3687.8955078125, 29.36885452270508),
				Radius = 500.0,
				RegisterDoors = {
					{ coords = vector3(3594.728759765625, 3704.839599609375, 29.83962440490722), ignore = true },
					{ coords = vector3(3555.947509765625, 3685.547607421875, 27.12180519104004), ignore = true },
					{ coords = vector3(3545.258544921875, 3646.557861328125, 28.27183532714843), ignore = true },
					{ coords = vector3(3544.806884765625, 3643.996337890625, 28.27183532714843), ignore = true },
					{ coords = vector3(3549.014404296875, 3658.79248046875, 27.12139701843261), ignore = true },
					{ coords = vector3(3551.5751953125, 3658.3408203125, 27.12139701843261), ignore = true },
					{ coords = vector3(3565.073974609375, 3684.739990234375, 27.12139701843261), ignore = true },
					{ coords = vector3(3567.634765625, 3684.28857421875, 27.12139701843261), ignore = true },
				},
				Robbables = {
					-- Exterior transformers.
					{
						Id = "electrical",
						Coords = {
							vector4(3619.92529296875, 3723.604248046875, 35.79479217529297, 323.2267150878906),
							vector4(3590.76708984375, 3695.9306640625, 36.642784118652344, 167.9230499267578),
							vector4(3582.07470703125, 3648.4560546875, 33.88861465454102, 253.255859375),
							vector4(3452.578125, 3710.704345703125, 31.42776489257813, 348.7597961425781),
						},
						OnFinish = function(robbable, site, robbableSettings, siteSettings, coords)
							-- Increment.
							site.electricalBoxes = (site.electricalBoxes or 0) + 1

							-- Wait for all boxes to be hit.
							if site.electricalBoxes < 4 then return end

							-- Find door group.
							local group = exports.doors:GetGroupFromCoords(siteSettings.Center)

			 				-- Unlock doors.
							for _, _coords in ipairs({
								vector3(3620.8427734375, 3751.527099609375, 27.69008636474609),
								vector3(3627.713134765625, 3746.71630859375, 27.69008636474609)
							}) do
								exports.doors:SetState(group, _coords, false)
							end
						end,
					},
					-- Interior transformer.
					{
						Id = "electrical",
						Coords = {
							vector4(3611.345947265625, 3728.4091796875, 29.68941688537597, 321.579833984375),
						},
						OnFinish = function(robbable, site, robbableSettings, siteSettings, coords)
							-- Find door group.
							local group = exports.doors:GetGroupFromCoords(siteSettings.Center)

							-- Unlock doors.
							for _, _coords in ipairs({
								vector3(3601.999755859375, 3717.883544921875, 29.83962440490722),
								vector3(3599.868896484375, 3719.37548828125, 29.83962440490722),
								vector3(3584.158935546875, 3700.946533203125, 28.97143936157226),
								vector3(3586.289794921875, 3699.45458984375, 28.97143936157226),
								vector3(3596.380615234375, 3690.468505859375, 28.97162437438965),
								vector3(3598.511474609375, 3688.9765625, 28.97162437438965),
								vector3(3568.70947265625, 3693.308837890625, 28.27154922485351),
								vector3(3569.1611328125, 3695.870361328125, 28.27154922485351),
							}) do
								exports.doors:SetState(group, _coords, false)
							end
						end,
					},
					-- Test chamber to elevator.
					{
						Id = "keypad_swipe",
						Coords = {
							vector4(3533.5673828125, 3671.277099609375, 28.12114143371582, 171.32508850097656),
							vector4(3532.75, 3670.12353515625, 28.12176132202148, 284.2310180664063),
						},
						Items = { "Blue Keycard" },
						Unlocks = {
							vector3(3533.093017578125, 3670.61279296875, 27.12124252319336),
							vector3(3530.5322265625, 3671.064453125, 27.12123870849609),
						},
					},
					-- Test chamber.
					{
						Id = "keypad_swipe",
						Coords = { vector4(3532.06396484375, 3666.68505859375, 28.1218318939209, 258.2201843261719) },
						Items = { "Blue Keycard" },
						Unlocks = {
							vector3(3532.972412109375, 3665.867919921875, 27.12178039550781),
							vector3(3532.52099609375, 3663.30712890625, 27.12177848815918),
						},
					},
					-- To chest chamber.
					{
						Id = "keypad_swipe",
						Coords = {
							vector4(3538.114501953125, 3644.908935546875, 28.12186431884765, 259.32666015625),
							vector4(3539.542236328125, 3644.681884765625, 28.12186050415039, 81.64305877685547),
						},
						Items = { "Blue Keycard" },
						Unlocks = {
							vector3(3538.757568359375, 3645.062744140625, 28.27183151245117),
							vector3(3539.209228515625, 3647.624267578125, 28.27183151245117),
						},
					},
					-- Airlock going out.
					{
						Id = "keypad_swipe",
						Coords = {
							vector4(3555.53369140625, 3663.8603515625, 28.12189102172851, 350.8825378417969),
							vector4(3555.789794921875, 3665.592529296875, 28.12189102172851, 171.24574279785156),
						},
						Items = { "Blue Keycard" },
						Unlocks = {
							vector3(3555.43505859375, 3664.80224609375, 27.12139701843261),
							vector3(3552.874267578125, 3665.253662109375, 27.12139701843261),
						},
					},
					-- Airlock coming in.
					{
						Id = "keypad_swipe",
						Coords = {
							vector4(3558.411376953125, 3680.230224609375, 28.12189102172851, 349.3704223632813),
							vector4(3558.7373046875, 3681.899658203125, 28.12186622619629, 169.6219940185547),
						},
						Items = { "Blue Keycard" },
						Unlocks = {
							vector3(3558.306640625, 3681.088134765625, 27.12139701843261),
							vector3(3555.745849609375, 3681.53955078125, 27.12139701843261),
						},
					},
					{
						Id = "computer",
						Coords = {
							vector4(3537.014404296875, 3668.533447265625, 28.12188720703125, 351.4415283203125),
							vector4(3536.087646484375, 3659.389892578125, 28.12188720703125, 167.8724822998047),
						},
						Items = {
							"Black Keycard",
						},
						OnFinish = function(robbable, site, robbableSettings, siteSettings, coords)
							-- Increment.
							site.computers = (site.computers or 0) + 1

							-- Wait for all computers to be hit.
							if site.computers < 1 then return end

							-- Find door group.
							local group = exports.doors:GetGroupFromCoords(siteSettings.Center)

							-- Unlock doors.
							exports.doors:SetState(group, vector3(3557.55322265625, 3669.194091796875, 27.12158203125), false)
						end,
					},
					{
						Id = "cabinet",
						Coords = {
							vector4(3558.81396484375, 3672.44091796875, 28.121885299682617, 346.55413818359375),
							vector4(3560.097412109375, 3672.232666015625, 28.12187957763672, 344.65667724609375),
							vector4(3559.185791015625, 3674.543701171875, 28.12187957763672, 169.7593536376953),
							vector4(3560.3603515625, 3674.370361328125, 28.12187957763672, 169.15362548828125),
						},
						Condition = function(source, robbable, site)
							if (site.computers or 0) < 2 then
								exports.sv_test:Report(source, "robbing Humane's cabinets without hitting the doors", false)
								return false
							else
								return true
							end
						end,
						Output = {
							{ Name = "Marked Bills", Amount = {6969, 11111}, Chance = 0.6 },
							{ Name = "Plastic Explosive", Amount = {6, 8}, Chance = 0.6 },
							{ Name = "Detonater", Amount = 1, Chance = 0.4 },
							{ Name = "Ketamine", Amount = {2, 4}, Chance = 0.02 },
							{ Name = "IFAK", Amount = {2, 4}, Chance = 0.3 },
							{ Name = "Gold Bar", Amount = 1, Chance = 0.05 },
							{ Name = "Heavy Armor", Amount = {1, 2}, Chance = 0.15 },
							{ Name = "Ballistic Helmet", Amount = {1, 2}, Chance = 0.15 },
							{ name = "Ammonium Ferric Citrate", Amount = {1, 7}, Chance = 0.05 },
							{ name = "Bleach", Amount = {1, 7}, Chance = 0.15 },
							{ name = "Phosphorus", Amount = {1, 7}, Chance = 0.05 },
							{ name = "Caustic Soda", Amount = {1, 7}, Chance = 0.05 },
							{ name = "Iodine", Amount = {1, 7}, Chance = 0.1 },
							{ name = "Sulphuric Acid", Amount = {1, 7}, Chance = 0.05 },
							{ name = "Calcium Powder", Amount = {1, 7}, Chance = 0.05 },
							{ name = "Hydrochloric Acid", Amount = {1, 7}, Chance = 0.05 },
							{ name = "Calcium Oxide", Amount = {1, 7}, Chance = 0.05 },
							{ name = "Acetic Anhydride", Amount = {1, 7}, Chance = 0.05 },
							{ name = "Ammonium Chloride", Amount = {1, 7}, Chance = 0.05 },
						},
					},
				},
				OnReset = function(self)
					self.electricalBoxes = nil
				end,
			},
			 {
			 	Name = "Vangelico",
			 	Type = "Jewelry",
			 	Center = vector3(-623.96948242188, -232.09579467773, 38.057037353516),
			 	Radius = 40.0,
			 	RegisterDoors = true,
			 	Robbables = {
					{
			 			Id = "jewelstorage",
			 			Coords = {
			 				vector4(-619.9500122070312, -224.41525268554688, 38.05692291259765, 39.28162384033203),
						},
					},
			 		{
			 			Id = "jewelry",
			 			Coords = {
			 				vector4(-626.9197998046875, -233.16104125976565, 38.05704498291016, 216.8294219970703),
			 				vector4(-627.9242553710938, -233.89730834960935, 38.05704498291016, 216.02381896972656),
			 				vector4(-626.848388671875, -235.3447418212891, 38.05704498291016, 38.32915115356445),
			 				vector4(-625.8085327148438, -234.58763122558597, 38.05704498291016, 35.10360336303711),
			 				vector4(-626.6967163085938, -238.60891723632812, 38.05704498291016, 215.9998321533203),
			 				vector4(-625.6502685546875, -237.85205078125, 38.05704498291016, 214.2256317138672),
			 				vector4(-624.415771484375, -231.0875244140625, 38.05704498291016, 304.737548828125),
							vector4(-623.9989013671875, -228.1798095703125, 38.05704498291016, 216.6409912109375),
			 				vector4(-624.9755859375, -227.8553009033203, 38.05704498291016, 34.24013137817383),
			 				vector4(-623.868896484375, -227.04055786132812, 38.05704498291016, 35.07495880126953),
			 				vector4(-620.3972778320312, -226.58685302734375, 38.05696105957031, 305.0174560546875),
			 				--vector4(-619.6622924804688, -227.63717651367188, 38.05698394775391, 303.6870422363281),
			 				vector4(-621.055908203125, -228.56036376953128, 38.05702209472656, 126.8014678955078),
			 				vector4(-618.3072509765625, -229.466064453125, 38.05699157714844, 304.24554443359375),
			 				vector4(-617.5529174804688, -230.5140380859375, 38.0569953918457, 306.9455261230469),
			 				--vector4(-619.7383422851562, -230.41958618164065, 38.05702209472656, 127.64775848388672),
			 				vector4(-619.1544799804688, -233.6974639892578, 38.05702209472656, 218.47662353515625),
							vector4(-620.171875, -233.3416290283203, 38.05702209472656, 36.390899658203125),
			 				--vector4(-620.2523193359375, -234.4741363525391, 38.05702209472656, 215.91946411132812),
			 				vector4(-623.050048828125, -232.95025634765625, 38.05702209472656, 303.85205078125),
			 			},
			 		},
			 	},
			},
		},
	},
}

for robbableId, robbable in pairs(Config.Robbables) do
	if robbable.Models then
		for model, settings in pairs(robbable.Models) do
			robbable.Models[GetHashKey(model)] = settings
		end
	end
end

--[[for k, site in ipairs(Config.Robberies.Sites) do
	if site.RegisterDoors then
		local overrides = nil
		if type(site.RegisterDoors) == "table" then
			overrides = site.RegisterDoors
		end
		exports.doors:RegisterGroup({
			id = "robbery-"..tostring(k),
			name = site.Name,
			coords = site.Center,
			radius = site.Radius or 15.0,
			overrides = overrides,
			locked = true,
			factions = { "lspd", "dps", "paramedic", "sasp", "bcso" },
		})
	end
end]]
