Config = {
	Marking = {
		Item = "Impound Sticker",
		Faction = "mechanic",
		Anim = {
			Dict = "veh@busted_van",
			Name = "issue_ticket_cop",
			Flag = 48,
			Rate = 0.2,
			Duration = 6000,
		},
	},
	Unmarking = {
		Anim = {
			Dict = "missexile3",
			Name = "ex03_dingy_search_case_a_michael",
			Flag = 48,
			Duration = 3000,
		},
	},
	Impounding = {
		Anim = {
			Dict = "missexile3",
			Name = "ex03_dingy_search_case_a_michael",
			Flag = 48,
			Duration = 8000,
		},
		Sites = {
			["rancho"] = {
				Coords = vector3(402.2373352050781, -1631.3709716796875, 30.11182594299316),
				Distance = 10.0,
			},
			["adams"] = {
				Coords = vector3(-239.05601501464844, -1183.728515625, 23.044038772583),
				Distance = 5.0,
			},
			["reds"] = {
				Coords = vector3(-197.8818359375, 6269.130859375, 31.48926925659179),
				Distance = 10.0,
			},
			["sandy"] = {
				Coords = vector3(259.66302490234375, 2578.0302734375, 45.11787796020508),
				Distance = 10.0,
			}
		},
		Reward = 20,
	},
}
