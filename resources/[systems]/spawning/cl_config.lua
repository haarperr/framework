Config = {
	AudioScenes = {
		"CHARACTER_CHANGE_IN_SKY_SCENE",
	},
	Previews = {
		{
			Timecycle = {
				Name = "spectator1",
				Strength = 1.0,
			},
			Camera = {
				Coords = vector3(268.3897705078125, -1216.106689453125, 40.2591667175293),
				Rotation = vector3(-4.16012287139892, -1.067216999217635e-7, -37.37743759155273),
				Fov = 22.5,
			},
			Peds = {
				{
					Coords = vector4(273.9588012695313, -1206.091552734375, 38.89941024780273, 178.8838348388672),
					Anim = { Dict = "timetable@ron@ig_3_couch", Name = "base", Flag = 1 },
				},
				{
					Coords = vector4(275.0482482910156, -1206.026123046875, 38.89752197265625, 187.229736328125),
					Anim = { Dict = "timetable@reunited@ig_10", Name = "base_amanda", Flag = 1 },
				},
				{
					Coords = vector4(276.9018859863281, -1205.81298828125, 38.89432907104492, 353.5223693847656),
					Anim = { Dict = "anim@amb@business@bgen@bgen_inspecting@", Name = "inspecting_med_lookingaround_inspector", Flag = 1 },
				},
			},
		}
	},
	Havens = {
		{
			Name = "Pillbox Hill",
			Static = {
				Coords = vector4(128.1701812744141, -690.90283203125, 42.02895355224609, 280.5345764160156),
			},
			Poses = {
				{
					Coords = vector4(137.61326599121097, -680.9774169921875, 42.02923965454101, 141.93112182617188),
					Anim = {
						Dict = "amb@world_human_leaning@male@wall@back@foot_up@exit",
						Name = "exit_front",
						BlendIn = 1000.0,
						Flag = 0,
					},
				},
				{
					Coords = vector4(149.35797119140625, -680.9443359375, 42.02947998046875, 105.45870208740236),
					Anim = {
						Dict = "switch@franklin@chopshop",
						Name = "checkshoe",
						BlendIn = 1000.0,
						Flag = 0,
					}
				},
				{
					Coords = vector4(122.2041244506836, -681.1710815429688, 42.02921676635742, 128.904052734375),
					Anim = {
						Dict = "switch@franklin@chopshop",
						Name = "wipehands",
						BlendIn = 1000.0,
						Flag = 0,
					}
				},
				{
					Coords = vector4(137.4122772216797, -676.892578125, 42.02926254272461, 191.0637969970703),
					Anim = {
						Dict = "switch@michael@sitting",
						Name = "exit_forward",
						BlendIn = 1000.0,
						Flag = 0,
					}
				},
				{
					Coords = vector4(148.19158935546875, -687.7426147460938, 42.02947616577148, 337.3321228027344),
					Anim = {
						Dict = "switch@michael@sitting",
						Name = "exit_forward",
						BlendIn = 1000.0,
						Flag = 0,
					}
				},
				{
					Coords = vector4(130.2030029296875, -696.3775634765625, 42.0289077758789, 9.68234348297119),
					Anim = {
						Dict = "switch@michael@sitting",
						Name = "exit_forward",
						BlendIn = 1000.0,
						Flag = 0,
					}
				},
			},
		},
	},
}