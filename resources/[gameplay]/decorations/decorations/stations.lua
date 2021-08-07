Register("Workbench", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Workbench",
		Auto = false,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Sequence = {
					{ Dict = "anim@amb@warehouse@toolbox@", Name = "enter", Flag = 0, BlendOut = 100.0 },
					{ Dict = "anim@amb@warehouse@toolbox@", Name = "idle", Flag = 1, BlendIn = 100.0 },
				},
			},
			Out = { Dict = "anim@amb@warehouse@toolbox@", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
	},
	Model = {
		"gr_prop_gr_bench_04b",
		"gr_prop_gr_bench_04a",
	},
})