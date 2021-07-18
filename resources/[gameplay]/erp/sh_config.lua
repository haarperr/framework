Config = {
	Instance = "lust",
	Beds = {
		vector4(-797.78094482422, 335.61737060547, 221.11340332031, 357.99859619141),
		-- vector4(154.15444946289065, -1004.538818359375, -98.4193115234375, 269.6863708496094),
	},
	Positions = {
		{ -- Standing missionary.
			{ -- Role 1.
				Offset = vector4(0.0, 2.8, -0.3, 180.0),
				Anim = {
					Dict = "rcmpaparazzo_2",
					Name = "shag_loop_a",
					Flag = 1,
				},
			},
			{ -- Role 2.
				Offset = vector4(0.0, 2.4, -0.3, 180.0),
				Anim = {
					Dict = "rcmpaparazzo_2",
					Name = "shag_loop_poppy",
					Flag = 1,
				},
			}
		},
		{ -- Standing missionary.
			{ -- Role 1.
				Offset = vector4(0.0, 1.5, -0.5, 0.0),
				Anim = {
					Dict = "misscarsteal2pimpsex",
					Name = "shagloop_pimp",
					Flag = 1,
				},
			},
			{ -- Role 2.
				Offset = vector4(0.0, 1.8, -0.75, 180.0),
				Anim = {
					Dict = "misscarsteal2pimpsex",
					Name = "shagloop_hooker",
					Flag = 1,
				},
			}
		},
	},
	Distance = 2.0,
}