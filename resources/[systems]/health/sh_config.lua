Config = {
	CheckInjuryDistance = 2.5,
	RespawnTime = 300,
	Spawn = vector4(365.4818115234375, -594.3560791015625, 43.28410339355469, 223.58975219726565),
	Markers = {
		DrawRadius = 5.0,
		Radius = 2.5,
		Blip = {
			name = "Hospital",
			id = 153,
			scale = 1.0,
			color = 1,
		}
	},
	Beds = {
		Duration = 20, -- In seconds.
		CheckInDuration = 10, -- In seconds.
		MaxCost = 500,
		Payout = 100,
		Models = {
			[1631638868] = { Offset = vector3(0.0, 0.0, 1.0) },
			[2117668672] = { Offset = vector3(0.0, 0.0, 1.0) },
		},
		Zones = {
			-- Upper Pillbox.
			{
				Coords = vector3(312.34063720703, -592.78021240234, 43.284061431885),
				Center = vector3(315.71960449219, -582.13665771484, 43.27946472168),
				Radius = 7,
			},
			-- Lower Pillbox.
			{
				Coords = vector3(350.9125671386719, -588.4074096679688, 28.796846389770508),
				Center = vector3(315.71960449219, -582.13665771484, 43.27946472168),
				Radius = 7,
			},
			-- Prison.
			{
				Coords = vector3(1768.552490234375, 2570.618896484375, 45.72985076904297),
				Center = vector3(1766.7633056640625, 2594.682861328125, 45.72985458374023),
				Radius = 12,
			},
			-- Paleto Medical.
			{
				Coords = vector3(-252.1222381591797, 6334.10693359375, 32.42716979980469),
				Center = vector3(-258.7384948730469, 6326.47412109375, 32.42717742919922),
				Radius = 5,
			},
			-- Sandy Medical.
			{
				Coords = vector3(1832.6368408203127, 3676.9501953125, 34.27480697631836),
				Center = vector3(1820.2030029296875, 3675.702392578125, 34.27487564086914),
				Radius = 12,
			},
		},
	},
	Eating = {
		Duration = 6000,
		Label = "Eating...",
		UseWhileDead = false,
		CanCancel = true,
		Disarm = true,
		Anim = {
			Dict = "mp_player_inteat@burger",
			Name = "mp_player_int_eat_burger",
			Flag = 49,
		},
	},
	Drinking = {
		Duration = 6000,
		Label = "Drinking...",
		UseWhileDead = false,
		CanCancel = true,
		Disarm = true,
		Anim = {
			Dict = "amb@world_human_drinking@coffee@male@idle_a",
			Name = "idle_a",
			Flag = 49,
			Props = {
				{ Model = "ba_prop_club_water_bottle", Bone = 28422, Offset = { -0.02, 0.0, -0.07, 0.0, 20.0, 0.0 } },
			},
		},
	},
	Alcohol = {
		Duration = 6000,
		Label = "Drinking...",
		UseWhileDead = false,
		CanCancel = true,
		Disarm = true,
		Anim = {
			Dict = "amb@world_human_drinking@coffee@male@idle_a",
			Name = "idle_a",
			Flag = 49,
			Props = {
				{ Model = "prop_drink_whisky", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 } },
			},
		},
	},
	Effects = {
		Hunger = { Min = -0.5, Max = 1.5, Passive = 1.0 / 3600.0, Afflict = 0.8, DamageAt = 1.25, Damage = { 100, 24817, "WEAPON_DEHYDRATION" }, Notify = "You feel hungry.", Modifier = "BasicEffectModifier" },
		Thirst = { Min = -0.5, Max = 1.5, Passive = 1.0 / 4900.0, Afflict = 0.8, DamageAt = 1.25, Damage = { 50, 24817, "WEAPON_DEHYDRATION" }, Notify = "You feel thirsty.", Modifier = "BasicEffectModifier" },
		Bac = { Min = 0.0, Passive = -1.0 / 300.0, Max = 1.0, DamageAt = 0.9, Damage = { 1, 24817, "WEAPON_DEHYDRATION" }, Notify = "You feel smashed." },
		Drug = { Min = 0.0, Passive = -1.0 / 120.0, Max = 2.0, DamageAt = 0.75, Damage = { 100, 31086, "WEAPON_OPIOIDS" }, Notify = "Your consciousness fades away." },
		Poison = { Min = 0.0, Passive = -1.0 / 300.0, Max = 1.0, DamageAt = 0.25, Damage = { 100, 31086, "WEAPON_POISON" }, Notify = "Your skin feels like it's melting off." },
		Comfort = { Min = 0.0, Passive = -1.0 / 600.0, Max = 1.0 },
		Armor = { Min = 0.0, Passive = -1.0 / 60.0, Max = 1.0 },
		Oxygen = { Min = 0.0, Passive = -1.0 / 60.0, Max = 1.0, DamageAt = 0.95, Damage = { 10, 24818, "WEAPON_DROWNING" }, Notify = "Your lungs start to give out." },
		Scuba = { Min = 0.0, Passive = -1.0 / 180, Max = 1.5 },
	},
	Modifiers = {
		Resistance = { 0.8, 0.9 },
		Healing = { 2.0, 6.0 },
	},
	Healing = {
		MaxDamage = 0.95,
		Amount = 1.0 / 3600.0,
	},
	Bleeding = {
		HealRate = 1.0 / 3600.0,
		ClotRate = 1.0 / 1800.0,
		UnclotRate = 1.0 / 300.0,
	},
	Bandaging = {
		InstantHealth = {0.0, 0.1},
		Action = {
			Duration = 6000,
			Label = "Using Bandage...",
			Anim = {
				Flag = 48,
				Dict = "clothingshirt",
				Name = "try_shirt_neutral_d",
			}
		}
	},
	Gauzing = {
		InstantHealth = {0.0, 0.1},
		Action = {
			Duration = 3000,
			Label = "Using Gauze...",
			Anim = {
				Flag = 48,
				Dict = "clothingshirt",
				Name = "try_shirt_neutral_d",
			}
		}
	},
	IFAK = {
		Action = {
			Duration = 37500,
			Label = "Using IFAK...",
			Anim = {
				Flag = 49,
				Dict = "misslsdhsclipboard@idle_a",
				Name = "idle_b",
			}
		}
	},
	Badge = {
		Action = {
			Duration = 3500,
			Label = "Showing Badge...",
			Anim = {
				Flag = 48,
				Dict = "paper_1_rcm_alt1-9",
				Name = "player_one_dual-9",
				Props = {
					{ Model = "prop_fib_badge", Bone = 58866, Offset = { 0.12, 0.01, 0.01, 93.0, -10.0, 0.0 } },
				},
			}
		}
	},
	Armoring = {
		Action = {
			Duration = 8000,
			Label = "Armoring Up...",
			Anim = {
				Flag = 48,
				Dict = "clothingtie",
				Name = "try_tie_neutral_c",
			}
		}
	},
	Rebreather = {
		Action = {
			Duration = 1200,
			Label = "Equipping...",
			Anim = {
				Flag = 49,
				Dict = "mp_masks@on_foot",
				Name = "put_on_mask",
			}
		}
	},
	Medical = {
		Distance = 2.5,
		Action = {
			Duration = 4000,
			Label = "Performing Medical...",
			Anim = {
				Flag = 48,
				Dict = "missexile3",
				Name = "ex03_dingy_search_case_base_michael",
			}
		}
	},
	Pills = {
		Action = {
			Duration = 2800,
			Label = "Taking Pill...",
			Anim = {
				Dict = "mp_suicide",
				Name = "pill",
				Flag = 48,
				Props = {
					{ Model = "prop_cs_pills", Bone = 58866, Offset = { 0.1, 0.0, 0.001, 0.0, 0.0, 0.0 } },
				},
			},
		},
	},
	Joint = {
		Action = {
			Duration = 8000,
			Label = "Getting high...",
			Anim = {
				Scenario = "WORLD_HUMAN_SMOKING_POT",
			}
		},
	},
	Edible = {
		Action = {
			Duration = 2800,
			Label = "Chewing...",
			Anim = {
				Dict = "mp_suicide",
				Name = "pill",
				Flag = 48,
			},
		},
	},
	Limping = {
		SprintingDamage = 1.0 / 180.0,
		JumpingDamage = 0.5,
		StaggerChance = 0.4,
		InjuredDamage = 0.5,
	},
	Down = {
		Delay = 1000,
		MaxSpeed = 0.1,
		FadeTime = 1000,
		BlendSpeed = 2.0,
		Anim = {
			dict = "Dead",
			name = "dead_%s",
			random = { "a", "b", "c", "d", "e", "f", "g", "h" },
		},
		Water = {
			Anim = {
				dict = "dam_ko",
				name = "drown",
			},
			Buoyancy = 1.2,
		},
		Vehicles = {
			Anim = {
				-- dict = "veh@std@ps@idle_duck", -- Floating hands
				dict = "veh@std@rps@idle_duck", -- Tucked hands
				name = "sit",
				flag = 16,
			},
		},
		Controls = { 8, 9, 21, 22, 23, 24, 25, 30, 31, 55, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 86, 90, 137, 143, 346, 347 }
	},
	Concussions = {
		-- Multiplied by the concussion value (0.0 - 1.0).
		DamageAmount = 0.1,
		PassoutChance = 0.4,
		-- Constants.
		PassoutThreshold = 0.2,
		HealChance = 0.4,
		HealAmount = 0.1,
	},
	Intensities = {
		{ 0.9, "Extreme %s" },
		{ 0.6, "Heavy %s" },
		{ 0.4, "Medium %s" },
		{ 0.0, "Light %s" },
	},
	Injuries = {
		["blunt"] = {
			Name = "Bruising",
			MinSpread = 0.2, Spread = 0.5,
			Concussion = 1.0,
			UseIntensity = true,
		},
		-- ["fracture"] = {
		-- 	Name = "Bruising",
		-- 	MinSpread = 20, Spread = 0.5,
		-- 	Concussion = 1.0,
		-- 	UseIntensity = true,
		-- },
		["burn2"] = {
			Name = "2nd-Degree Burns",
			Spread = 0.4,
			UseIntensity = true,
		},
		["burn3"] = {
			Name = "3rd-Degree Burns",
			Spread = 1.0,
			Bleed = 1.0 / 120.0,
			HemorrhagingChance = 1.0,
			Hemorrhaging = 1.0 / 90.0,
			UseIntensity = true,
		},
		["gas"] = {},
		["gsw"] = {
			Name = "GSW",
			Bleed = 1.0 / 1200.0,
			DamageMultiplier = 1.5,
			HemorrhagingChance = 0.6,
			Hemorrhaging = 1.0 / 900.0
		},
		["scrapes"] = {
			Name = "Scrapes",
			Bleed = 1.0 / 900.0
		},
		["stab"] = {
			Name = "Stab",
			Bleed = 1.0 / 60.0,
			HemorrhagingChance = 0.9,
			Hemorrhaging = 1.0 / 600.0
		},
		["glass"] = {
			Name = "Glass",
			Bleed = 1.0 / 300.0,
			HemorrhagingChance = 0.1,
			Hemorrhaging = 1.0 / 900.0
		},
		["dehydration"] = {
			Name = "Dehydration",
		},
		["malnourishment"] = {
			Name = "Malnourishment",
		},
		["opioids"] = {
			Name = "Opioids",
		},
		["poison"] = {
			Name = "Poison",
		},
	},
	BodyParts = {
		-- Fallbacks.
		[0] = { Name = "SKEL_ROOT", Fallback = 11816 },
		[39317] = { Name = "SKEL_Neck_1", Type = 4103, Fallback = 31086 },
		[24816] = { Name = "SKEL_Spine1", Type = 4103, Fallback = 11816 },
		[23553] = { Name = "SKEL_Spine0", Type = 4103, Fallback = 11816 },
		[57597] = { Name = "SKEL_Spine_Root", Type = 4103, Fallback = 11816 },
		-- Center upper.
		[31086] = { Name = "SKEL_Head", Type = 4103, Nearby = { 10706, 64729 }, Fatal = 0.6, Concussion = true, MaxArmor = 0.1 },
		[24818] = { Name = "SKEL_Spine3", Type = 4103, Nearby = { 10706, 64729, 24817, 45509, 40269 }, Fatal = 0.6 },
		[24817] = { Name = "SKEL_Spine2", Type = 4103, Nearby = { 24818, 24816 }, Fatal = 0.55 },
		[11816] = { Name = "SKEL_Pelvis", Type = 4103, Nearby = { 24817, 51826, 58271 }, Fatal = 0.5, Limp = 0.5, MaxArmor = 0.1 },
		-- Right upper.
		[10706] = { Name = "SKEL_R_Clavicle", Type = 4103, Nearby = { 40269, 31086, 24818 }, Fatal = 0.1 },
		[40269] = { Name = "SKEL_R_UpperArm", Type = 4103, Nearby = { 10706, 28252, 24818 }, Fatal = 0.1, MaxArmor = 0.1 },
		[28252] = { Name = "SKEL_R_Forearm", Type = 4215, Nearby = { 40269, 57005 }, Fatal = 0.08 },
		[57005] = { Name = "SKEL_R_Hand", Type = 4215, Nearby = { 28252 }, Fatal = 0.05 },
		-- Right lower.
		[51826] = { Name = "SKEL_R_Thigh", Type = 4103, Nearby = { 11816, 36864 }, Fatal = 0.12, Limp = 0.5 },
		[36864] = { Name = "SKEL_R_Calf", Type = 4103, Nearby = { 51826, 52301 }, Fatal = 0.08, Limp = 0.5 },
		[52301] = { Name = "SKEL_R_Foot", Type = 4103, Nearby = { 36864 }, Fatal = 0.05, Limp = 0.25 },
		-- Left upper.
		[64729] = { Name = "SKEL_L_Clavicle", Type = 4103, Nearby = { 45509, 31086, 24818 }, Fatal = 0.12 },
		[45509] = { Name = "SKEL_L_UpperArm", Type = 4103, Nearby = { 64729, 61163, 24818 }, Fatal = 0.1, MaxArmor = 0.1 },
		[61163] = { Name = "SKEL_L_Forearm", Type = 4215, Nearby = { 45509, 18905 }, Fatal = 0.08 },
		[18905] = { Name = "SKEL_L_Hand", Type = 4215, Nearby = { 61163 }, Fatal = 0.05 },
		-- Left lower.
		[58271] = { Name = "SKEL_L_Thigh", Type = 4103, Nearby = { 11816, 63931 }, Fatal = 0.12, Limp = 0.5 },
		[63931] = { Name = "SKEL_L_Calf", Type = 4103, Nearby = { 58271, 14201 }, Fatal = 0.08, Limp = 0.5 },
		[14201] = { Name = "SKEL_L_Foot", Type = 4103, Nearby = { 63931 }, Fatal = 0.05, Limp = 0.25 },
	},
}