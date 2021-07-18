Config = {
	Debug = true,
	CycleRanges = 3,
	ChannelHudKey = "nsrp_channel",
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
		{ Coords = vector3(120.97727966308594, -1281.084716796875, 29.79060554504394), Radius = 2.5 }, -- Vanilla Unicorn.
		{ Coords = vector3(686.324951171875, 577.818603515625, 130.46127319335938), Radius = 10.0 }, -- Vinewood Bowl.
		{ Coords = vector3(205.1594696044922, 1167.18310546875, 227.00482177734375), Radius = 8.0}, --Sisyphus Theater.
		{ Coords = vector3(77.44329833984375, 3704.7197265625, 41.07716369628906), Radius = 2.5 }, -- Stab City L.
		{ Coords = vector3(80.14737701416016, 3708.42919921875, 41.07716369628906), Radius = 2.5 }, -- Stab City M.
		{ Coords = vector3(82.62446594238281, 3711.324462890625, 41.07718658447265), Radius = 2.5 }, -- Stab City R.
		{ Coords = vector3(-550.8392944335938, 281.9425048828125, 82.97657012939453), Radius = 1.5 }, -- Tequi-la-la L.
		{ Coords = vector3(-551.5172729492188, 284.0843505859375, 82.97657012939453), Radius = 1.5 }, -- Tequi-la-la M.
		{ Coords = vector3(-550.9138793945312, 286.9436950683594, 82.97657012939453), Radius = 1.5 }, -- Tequi-la-la R.
		{ Coords = vector3(-454.537841796875, 271.7487487792969, 83.62382507324219), Radius = 3.5 }, -- Comedy Club.
		{ Coords = vector3(-312.4431762695313, 6264.5966796875, 32.06183624267578), Radius = 1.5 }, -- Hen House.
	},
}