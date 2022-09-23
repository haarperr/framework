Config = {
	Actions = {
		["Cigarette"] = {
			Duration = 200000,
			Label = "Smoking...",
			Anim = {
				Scenario = "WORLD_HUMAN_SMOKING",
			}
		},
		["Cigar"] = {
			Duration = 120000,
			Label = "Smoking...",
			Anim = {
				Dict = "timetable@gardener@smoking_joint",
				Name = "smoke_idle",
				Duration = 120000,
				Flag = 49,
				Props = {
					{ Model = "prop_sh_cigar_01", Bone = 57005, Offset = { 0.14, 0.06, -0.05, 0.0, -180.0, 60.0 } },
				},
			},
		},
		["Vape Pen"] = {
			Duration = 30000,
			Label = "Vaping...",
			Anim = {
				Dict = "timetable@gardener@smoking_joint",
				Name = "smoke_idle",
				Duration = 30000,
				Flag = 49,
				Props = {
					{ Model = "ba_prop_battle_vape_01", Bone = 57005, Offset = { 0.12, 0.0, -0.05, -172.0, 50.0, 0.0 } },
				},
			},
		},
		["Joint"] = {
			Duration = 120000,
			Label = "Getting high...",
			Anim = {
				Scenario = "WORLD_HUMAN_SMOKING_POT",
			}
		},
		["Bong"] = {
			Duration = 11000,
			Label = "Getting high...",
			Anim = {
				Dict = "anim@safehouse@bong",
				Name = "bong_stage4",
				Duration = 11000,
				Flag = 49,
				Props = {
					{ Model = "prop_bong_01", Bone = 18905, Offset = { 0.10,-0.25,0.0,95.0,190.0,180.0 } },
				},
			},
		},
		["Cocaine"] = {
			Duration = 6000,
			Label = "Snorting up...",
			Anim = {
				Dict = "move_p_m_two_idles@generic",
				Name = "fidget_sniff_fingers",
				Flag = 48,
			}
		},
		["Cocaine Grenada"] = {
			Duration = 6000,
			Label = "Snorting up...",
			Anim = {
				Dict = "move_p_m_two_idles@generic",
				Name = "fidget_sniff_fingers",
				Flag = 48,
			}
		},
		["Cocaine Compact"] = {
			Duration = 6000,
			Label = "Snorting up...",
			Anim = {
				Dict = "move_p_m_two_idles@generic",
				Name = "fidget_sniff_fingers",
				Flag = 48,
			}
		},
		["Peyote Chunk"] = {
			Duration = 2800,
			Label = "Chewing...",
			Anim = {
				Dict = "mp_suicide",
				Name = "pill",
				Flag = 2,
				Props = {
					{ Model = "prop_peyote_chunk_01", Bone = 58866, Offset = { 0.1, 0.0, 0.001, 0.0, 0.0, 0.0 } },
				},
			}
		},
		["Tasty Lion Steak"] = {
			Duration = 3800,
			Label = "Chewing...",
			Anim = {
				Dict = "mp_suicide",
				Name = "pill",
				Flag = 2,
			}
		},
		["Ketamine Syringe"] = {
			Duration = 32000,
			Label = "Shooting up...",
			Anim = {
				Dict = "rcmpaparazzo1ig_4",
				Name = "miranda_shooting_up",
				Duration = 32000,
				Flag = 48,
				Props = {
					{ Model = "p_syringe_01_s", Bone = 58868, Offset = { 0.1, 0.02, 0.0, 0.0, -60.0, 0.0 } },
				},
			},
		},
		["Heroin Syringe"] = {
			Duration = 32000,
			Label = "Shooting up...",
			Anim = {
				Dict = "rcmpaparazzo1ig_4",
				Name = "miranda_shooting_up",
				Duration = 32000,
				Flag = 48,
				Props = {
					{ Model = "p_syringe_01_s", Bone = 58868, Offset = { 0.1, 0.02, 0.0, 0.0, -60.0, 0.0 } },
				},
			},
		},
		["China White Syringe"] = {
			Duration = 32000,
			Label = "Shooting up...",
			Anim = {
				Dict = "rcmpaparazzo1ig_4",
				Name = "miranda_shooting_up",
				Duration = 32000,
				Flag = 48,
				Props = {
					{ Model = "p_syringe_01_s", Bone = 58868, Offset = { 0.1, 0.02, 0.0, 0.0, -60.0, 0.0 } },
				},
			},
		},
		["Crack Pipe"] = {
			Duration = 60000,
			Label = "Cracking up...",
			Anim = {
				Dict = "timetable@gardener@smoking_joint",
				Name = "smoke_idle",
				Duration = 60000,
				Flag = 49,
				Props = {
					{ Model = "prop_cs_crackpipe", Bone = 57005, Offset = { 0.12, -0.06, -0.05, 8.0, 50.0, 0.0 } },
				},
			},
		},
		["Crack Cocaine"] = {
			Duration = 60000,
			Label = "Cracking up...",
			Anim = {
				Dict = "timetable@gardener@smoking_joint",
				Name = "smoke_idle",
				Duration = 60000,
				Flag = 49,
				Props = {
					{ Model = "prop_cs_crackpipe", Bone = 57005, Offset = { 0.12, -0.06, -0.05, 8.0, 50.0, 0.0 } },
				},
			},
		},
		["Lean"] = {
			Duration = 8000,
			Label = "Sipping lean...",
			Anim = {
				Dict = "amb@world_human_drinking@coffee@male@idle_a",
				Name = "idle_b",
				Duration = 8000,
				Flag = 49,
				Props = {
					{ Model = "prop_plastic_cup_02", Bone = 28422, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 } },
				},
			},
		},
		["LSD"] = {
			Duration = 2800,
			Label = "Going on a trip...",
			Anim = {
				Dict = "mp_suicide",
				Name = "pill",
				Flag = 48,
			},
		},
		["Powdered Fentanyl"] = {
			Duration = 6000,
			Label = "Snorting up...",
			Anim = {
				Dict = "move_p_m_two_idles@generic",
				Name = "fidget_sniff_fingers",
				Flag = 48,
			}
		},
	},
	Slinging = {
		Cooldown = 30, -- In seconds.
		Distance = 1.5,
		DrawDistance = 15.0,
		MaxRange = 40.0,
		SpawnCooldown = 5000, -- In milliseconds.
		-- TerritoryBonus = 1.05, -- Multiplier for controlled territory.
		Anim = {
			Dict = "mp_common",
			Name = "givetake1_a",
			Flag = 16,
			Props = {
				{ Model = "prop_paper_bag_small", Bone = 28422, Offset = { 0.0, -0.05, 0.02, -90.0, 0.0, 0.0 } },
			},
		},
	},
	Items = { "Cocaine Grenada", "Cocaine Compact", "Weed", "Heroin", "Crack Cocaine" },
	Prices = {
		--[[
			Min: minimum cash per item,
			Max: maximum cash per item,
			Cap: maximum amount of items per sale,
			Hotspot: cash multiplier in hotspots
		]]

		["Weed"] = { Min = 12, Max = 27, Cap = 4, Hotspot = 2.0, MaxCops = 6, CopRate = 0.3 },
		["Cocaine Compact"] = { Min = 30, Max = 60, Cap = 1, Hotspot = 1.5, MaxCops = 6, CopRate = 0.3 },
		["Cocaine Grenada"] = { Min = 25, Max = 55, Cap = 1, Hotspot = 1.5, MaxCops = 6, CopRate = 0.3 },
		["Heroin"] = { Min = 50, Max = 80, Cap = 2, Hotspot = 1.5, MaxCops = 6, CopRate = 0.3 },
		["Laced Heroin"] = { Min = 55, Max = 105, Cap = 3, Hotspot = 1.5, MaxCops = 6, CopRate = 0.3 },
		["Crack Cocaine"] = { Min = 40, Max = 75, Cap = 2, Hotspot = 1.5, MaxCops = 6, CopRate = 0.3 },
	},
	HotSpots = {
		Duration = 30, -- In minutes.
		Max = 3, -- Number of hotspots.
	},
	Zones = {
		--[[
			The chance that the zone is a hotspot.
			A value of -1.0 won't allow the zone to sell.
		]]

		["AIRP"] = { ["Cocaine Grenada"] = -1.0, ["Cocaine Compact"] = -1.0, ["Weed"] = -1.0, ["Heroin"] = -1.0, ["Crack Cocaine"] = -1.0 }, -- Los Santos International Airport.
		["ALAMO"] = { ["Cocaine Grenada"] = -1.0, ["Cocaine Compact"] = -1.0, ["Weed"] = -1.0, ["Heroin"] = -1.0, ["Crack Cocaine"] = -1.0 }, -- Alamo Sea.
		["ALTA"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Alta.
		["ARMYB"] = { ["Cocaine Grenada"] = -1.0, ["Cocaine Compact"] = -1.0, ["Weed"] = -1.0, ["Heroin"] = -1.0, ["Crack Cocaine"] = -1.0 }, -- Fort Zancudo.
		["BANHAMC"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Banham Canyon Dr.
		["BANNING"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Banning.
		["BEACH"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Vespucci Beach.
		["BHAMCA"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Banham Canyon.
		["BRADP"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Braddock Pass.
		["BRADT"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Braddock Tunnel.
		["BURTON"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Burton.
		["CALAFB"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Calafia Bridge.
		["CANNY"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Raton Canyon.
		["CCREAK"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Cassidy Creek.
		["CHAMH"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 1.0, ["Crack Cocaine"] = 1.0 }, -- Chamberlain Hills.
		["CHIL"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Vinewood Hills.
		["CHU"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Chumash.
		["CMSW"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Chiliad Mountain State Wilderness.
		["CYPRE"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Cypress Flats.
		["DAVIS"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 1.0, ["Crack Cocaine"] = 1.0 }, -- Davis.
		["DELBE"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 1.0, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Del Perro Beach.
		["DELPE"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 1.0, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Del Perro.
		["DELSOL"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- La Puerta.
		["DESRT"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Grand Senora Desert.
		["DOWNT"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Downtown.
		["DTVINE"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 1.0, ["Heroin"] = 1.0, ["Crack Cocaine"] = 1.0 }, -- Downtown Vinewood.
		["EAST_V"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 1.0, ["Heroin"] = 1.0, ["Crack Cocaine"] = 1.0 }, -- East Vinewood.
		["EBURO"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- El Burro Heights.
		["ELGORL"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- El Gordo Lighthouse.
		["ELYSIAN"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Elysian Island.
		["GALFISH"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Galilee.
		["GOLF"] = { ["Cocaine Grenada"] = 1.0, ["Cocaine Compact"] = 1.0, ["Weed"] = 1.0, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- GWC and Golfing Society.
		["GRAPES"] = { ["Cocaine Grenada"] = 1.0, ["Cocaine Compact"] = 1.0, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Grapeseed.
		["GREATC"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Great Chaparral.
		["HARMO"] = { ["Cocaine Grenada"] = 1.0, ["Cocaine Compact"] = 1.0, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Harmony.
		["HAWICK"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Hawick.
		["HORS"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Vinewood Racetrack.
		["HUMLAB"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = -1.0, ["Crack Cocaine"] = -1.0 }, -- Humane Labs and Research.
		["JAIL"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = -1.0, ["Crack Cocaine"] = -1.0 }, -- Bolingbroke Penitentiary.
		["KOREAT"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 1.0, ["Crack Cocaine"] = 0.5 }, -- Little Seoul.
		["LACT"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Land Act Reservoir.
		["LAGO"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Lago Zancudo.
		["LDAM"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Land Act Dam.
		["LEGSQU"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Legion Square.
		["LMESA"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- La Mesa.
		["LOSPUER"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- La Puerta.
		["MIRR"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Mirror Park.
		["MORN"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Morningwood.
		["MOVIE"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Richards Majestic.
		["MTCHIL"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Mount Chiliad.
		["MTGORDO"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Mount Gordo.
		["MTJOSE"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Mount Josiah.
		["MURRI"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Murrieta Heights.
		["NCHU"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- North Chumash.
		["NOOSE"] = { ["Cocaine Grenada"] = -1.0, ["Cocaine Compact"] = -1.0, ["Weed"] = -1.0, ["Heroin"] = -1.0, ["Crack Cocaine"] = -1.0 }, -- N.O.O.S.E.
		["OBSERV"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 1.0, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Observatory.
		["OCEANA"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Pacific Ocean.
		["PALCOV"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Paleto Cove.
		["PALETO"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Paleto Bay.
		["PALFOR"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Paleto Forest.
		["PALHIGH"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Palomino Highlands.
		["PALMPOW"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Palmer-Taylor Power Station.
		["PBLUFF"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Pacific Bluffs.
		["PBOX"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Pillbox Hill.
		["PROCOB"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Procopio Beach.
		["RANCHO"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Rancho.
		["RGLEN"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Richman Glen.
		["RICHM"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Richman.
		["ROCKF"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 1.0, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Rockford Hills.
		["RTRAK"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Redwood Lights Track.
		["SANAND"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- San Andreas.
		["SANCHIA"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- San Chianski Mountain Range.
		["SANDY"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 1.0, ["Crack Cocaine"] = 1.0 }, -- Sandy Shores.
		["SKID"] = { ["Cocaine Grenada"] = -1.0, ["Cocaine Compact"] = -1.0, ["Weed"] = -1.0, ["Heroin"] = -1.0, ["Crack Cocaine"] = -1.0 }, -- Mission Row.
		["SLAB"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Stab City.
		["STAD"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Maze Bank Arena.
		["STRAW"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Strawberry.
		["TATAMO"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Tataviam Mountains.
		["TERMINA"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Terminal.
		["TEXTI"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Textile City.
		["TONGVAH"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Tongva Hills.
		["TONGVAV"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Tongva Valley.
		["VCANA"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 1.0, ["Crack Cocaine"] = 0.5 }, -- Vespucci Canals.
		["VESP"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 1.0, ["Heroin"] = 1.0, ["Crack Cocaine"] = 0.5 }, -- Vespucci.
		["VINE"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 1.0, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Vinewood.
		["WINDF"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Ron Alternates Wind Farm.
		["WVINE"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 1.0, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- West Vinewood.
		["ZANCUDO"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Zancudo River.
		["ZP_ORT"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 0.5, ["Heroin"] = 0.5, ["Crack Cocaine"] = 0.5 }, -- Port of South Los Santos.
		["ZQ_UAR"] = { ["Cocaine Grenada"] = 0.5, ["Cocaine Compact"] = 0.5, ["Weed"] = 1.0, ["Heroin"] = 1.0, ["Crack Cocaine"] = 1.0 }, -- Davis Quartz.
	},
	DisabledInteriors = {
		-- In case we find a need later on.
	},
	DisabledInteriorGroups = {
		-- In case we want to use.
	},
}
