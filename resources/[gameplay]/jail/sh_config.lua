Config = {
	Breakout = {
		Time = 15, -- In minutes.
		MinPresence = 6,
		Message = "You've escaped the walls, but the guards are still after you! Get away in the next %s minutes or risk being sent back!",
		Cannot = "You can't escape without somebody to escape from!<br>Presence: %s/%s",
		Failed = "You've failed to escape...",
		Success = "You've escaped!",
	},
	Types = {
		["prison"] = true,
		["parsons"] = true,
		["cayo"] = true,
	},
	TimeLeft = {
		Coords = {
			["prison"] = vector3(1753.59619140625, 2474.3193359375, 45.73986053466797),
			["parsons"] = vector3(-1528.5972900391, 835.80096435547, 181.59468078613),
			["cayo"] = vector3(4501.49267578125, -4555.51220703125, 4.17193603515625),
		},
		Markers = {
			Text = "Check time",
			DrawRadius = 5.0,
			Radius = 2.0,
		},
		Message = "You have %s months remaining!",
	},
	Spawn = {
		Coords = {
			["prison"] = {
				vector4(1767.611328125, 2500.941162109375, 45.74489593505859, 209.7182159423828),
				vector4(1758.415771484375, 2495.137939453125, 49.69305419921875, 208.17526245117188),
				vector4(1758.342529296875, 2472.7158203125, 45.74065399169922, 33.20377349853515),
				vector4(1767.499755859375, 2478.29931640625, 49.6931037902832, 27.89394950866699),
			},
			["parsons"] = vector4(-1515.3767089844, 851.15087890625, 181.59484863281, 26.634798049927),
			["cayo"] = vector4(4506.49658203125, -4554.39111328125, 4.17192363739013, 58.62303161621094),
		},
		Message = "You have been imprisoned for %s months!",
	},
	Exit = {
		Coords = {
			["prison"] = vector4(1849.9930419922, 2585.8337402344, 45.672019958496, 267.89682006836),
			["parsons"] = vector4(-1467.8068847656, 871.98559570313, 183.48446655273, 267.75463867188),
			["cayo"] = vector4(4505.35546875, -4539.9912109375, 4.0752420425415, 330.087890625),
		},
		Message = "You have been released!",
	},
	Bounds = {
		["prison"] = {
			Center = vector3(1701.09765625, 2585.0864257813, 267.87060546875),
			Radius = 320,
		},
		["parsons"] = {
			Center = vector3(-1540.4116210938, 827.20050048828, 186.05271911621),
			Radius = 120,
		},
		["cayo"] = {
			Center = vector3(4476.52197265625, -4509.9755859375, 4.1829195022583),
			Radius = 200,
		},
	},
}