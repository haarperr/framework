Config = {
	CycleRanges = 3,
	ChannelHudKey = "nsrp_channel",
	VoiceTarget = 3,
	Convars = {
		["voice_useNativeAudio"] = "true",
		["voice_use2dAudio"] = "false",
		["voice_use3dAudio"] = "false",
		["voice_useSendingRangeOnly"] = "true",
	},
	Ranges = {
		[1] = {
			Proximity = 0.8,
		},
		[2] = {
			Proximity = 2.8,
		},
		[3] = {
			Proximity = 6.7,
		},
		["M"] = {
			Proximity = 18.2,
		}
	},
	Types = {
		Automatic = 1, -- Listens and sends over the channel automatically.
		Manual = 2, -- Listens and sends over the channel using filters.
		Receiver = 3, -- Listens over the channel.
	},
	Amplifiers = {
		Stages = {
			{ Coords = vector3(121.40032958984376, -1280.865478515625, 29.4804630279541), Radius = 2.0 }, -- Vanilla Unicorn.
			{ Coords = vector3(686.324951171875, 577.818603515625, 130.46127319335938), Radius = 10.0 }, -- Vinewood Bowl.
			{ Coords = vector3(205.1594696044922, 1167.18310546875, 227.00482177734375), Radius = 8.0}, --Sisyphus Theater.
			{ Coords = vector3(77.44329833984375, 3704.7197265625, 41.07716369628906), Radius = 2.5 }, -- Stab City L.
			{ Coords = vector3(80.14737701416016, 3708.42919921875, 41.07716369628906), Radius = 2.5 }, -- Stab City M.
			{ Coords = vector3(82.62446594238281, 3711.324462890625, 41.07718658447265), Radius = 2.5 }, -- Stab City R.
			{ Coords = vector3(-550.8392944335938, 281.9425048828125, 82.97657012939453), Radius = 1.5 }, -- Tequi-la-la L.
			{ Coords = vector3(-551.5172729492188, 284.0843505859375, 82.97657012939453), Radius = 1.5 }, -- Tequi-la-la M.
			{ Coords = vector3(-550.9138793945312, 286.9436950683594, 82.97657012939453), Radius = 1.5 }, -- Tequi-la-la R.
			{ Coords = vector3(-1831.1636962890625, -1190.7034912109375, 19.87976264953613), Radius = 1.5 }, -- Pearls.
			{ Coords = vector3(-576.8135986328125, -210.30194091796875, 38.98944854736328), Radius = 1.5 }, -- Courthouse Judge seat.
			{ Coords = vector3(-572.6636962890625, -207.92184448242188, 38.7354736328125), Radius = 1.0 }, -- Courthouse Speaking Stand.
			{ Coords = vector3(-576.1199, -212.3873, 38.07262), Radius = 0.8 }, -- Courthouse Witness Stand Right.
			{ Coords = vector3(-578.2142, -208.6503, 38.07262), Radius = 0.8 }, -- Courthouse Witness Stand Left.
			{ Coords = vector3(-1378.4508056640625, -629.0260620117188, 30.62794494628906), Radius = 1.5 }, -- Bahama Mamas.
			{ Coords = vector3(4893.516, -4905.183, 3.486646), Radius = 2.0 }, -- Cayo Perico, Pleasure Cove.
		},
		Vehicles = {
			[`pbus2`] = { Offset = vector3(-0.58, -1.58, 2.9), Radius = 1.0 },
		},
	},
}