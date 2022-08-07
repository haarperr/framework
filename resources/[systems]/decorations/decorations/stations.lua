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
				Locked = true,
				Sequence = {
					{ Dict = "anim@amb@warehouse@toolbox@", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "anim@amb@warehouse@toolbox@", Name = "idle", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "anim@amb@warehouse@toolbox@", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = {
		"gr_prop_gr_bench_04b",
		"gr_prop_gr_bench_04a",
	},
})

Register("Fryer", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Fryer",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "prop_chip_fryer",
			"",
})

Register("Smeltry", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Smeltry",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "v_ilev_found_cranebucket",
})

Register("Jewel Bench", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Jewel Bench",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "gr_prop_gr_bench_04b",
})

Register("Class One Weapon Bench", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Class One Weapon Bench",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "gr_prop_gr_bench_02a",
})

Register("Class Two Weapon Bench", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Class Two Weapon Bench",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "gr_prop_gr_bench_02a",
})

Register("Class Three Weapon Bench", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Class Three Weapon Bench",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "gr_prop_gr_bench_02a",
})

Register("Stove", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Stove",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "prop_cooker_03",
})

Register("Processor", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Processor",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "prop_foodprocess_01",
})

Register("Ammo Bench", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Ammo Bench",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "gr_prop_gr_bench_02a",
})

Register("Pizza Oven", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Pizza Oven",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "prop_pizza_oven_01",
})

Register("Grater", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Grater",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "v_res_fa_grater",
})

Register("Frying Pan", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Frying Pan",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "prop_kitch_pot_fry",
})

Register("Pot", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Pot",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "prop_kitch_pot_sm",
			"prop_kitch_pot_med",
			"prop_kitch_pot_lrg",
			"prop_kitch_pot_huge",
})

Register("Cutting Board", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Cutting Board",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "v_res_fa_chopbrd",
})

Register("Keycard Printer", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Keycard Printer",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "prop_printer_01",
})

Register("Resource Sales", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Resource Sales",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "hei_prop_heist_wooden_box",
})

Register("Fish Sales", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Fish Sales",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "v_res_fa_chopbrd",
})

Register("Saw Mill", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Saw Mill",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "prop_bonesaw",
})

Register("Cnc", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Cnc",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "gr_prop_gr_cnc_01b",
			"gr_prop_gr_cnc_01c",
})