Config = {
	Alarms = {
		{ Coords = vector3(1780.2607421875, 2590.0712890625, 50.92486190795898), Radius = 0.6 },
		{ Coords = vector3(1790.6978759765625, 2547.674560546875, 46.36921691894531), Radius = 0.6 },
		{ Coords = vector3(1763.8306884765625, 2605.38671875, 51.00505447387695), Radius = 0.6 },
		{ Coords = vector3(1790.4093017578125, 2597.81005859375, 46.13355255126953), Radius = 0.6 },
	},
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
	},
	TimeLeft = {
		Coords = {
			["prison"] = vector3(1782.062255859375, 2573.16796875, 45.79793930053711),
			["parsons"] = vector3(-1528.5972900391, 835.80096435547, 181.59468078613),
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
				vector4(1790.10107421875, 2578.252197265625, 45.79793930053711, 90.72119140625),
				vector4(1769.237548828125, 2581.6435546875, 45.79800415039062, 272.8771057128906),
				vector4(1789.405029296875, 2590.030517578125, 50.54985427856445, 90.68022918701172),
				vector4(1769.458740234375, 2581.648681640625, 50.54985046386719, 272.26727294921875),
				vector4(1782.0467529296875, 2568.524658203125, 50.54985809326172, 1.33542799949646),
			},
			["parsons"] = vector4(-1515.3767089844, 851.15087890625, 181.59484863281, 26.634798049927),
		},
		Message = "You have been imprisoned for %s months!",
	},
	Exit = {
		Coords = {
			["prison"] = vector4(1849.9930419922, 2585.8337402344, 45.672019958496, 267.89682006836),
			["parsons"] = vector4(-1467.8068847656, 871.98559570313, 183.48446655273, 267.75463867188),
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
	},
}