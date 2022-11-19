Register("Bucket", {
	Placement = "Floor",
	Model = {
		"prop_soil_bucket",
	},
	Anim = { Dict = "anim@mp_snowball", Name = "pickup_snowball", Flag = 0, Duration = 1200 },
})

--[[Register("Weed Plant", {
	Placement = "Floor",
	Radius = 0.75,
	Model = {
		"bkr_prop_weed_01_small_01a",
	},
	Anim = { Dict = "anim@mp_snowball", Name = "pickup_snowball", Flag = 0, Duration = 1200 },
	Stages = {
		{
			Age = 360,
			Model = "bkr_prop_weed_lrg_01a",
			Items = { { 1.0, "Weed", {2,5} }, { 0.3, "Weed Seed", {0,2} } },
			Harvestable = true,
		},
		{
			Age = 120,
			Model = "bkr_prop_weed_med_01a",
		},
		{
			Model = "bkr_prop_weed_01_small_01a",
		},
	},
	Materials = { -- For weed seed.
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
	},
})]]

Register("Weed Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 0.75,
	Placement = "Floor",
	Model = {
		"prop_weed_02",
	},
	Stages = {
		{
			Age = 360,
			Model = "prop_weed_01",
			Items = { { 1.0, "Weed", {1,3} }, { 0.30, "Weed Seed", {1,1} } },
			Harvestable = true,
		},
		{
			Model = "prop_weed_02",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
	},
})

Register("Blue Dream Weed Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 0.75,
	Placement = "Floor",
	Model = {
		"prop_weed_02",
	},
	Stages = {
		{
			Age = 360,
			Model = "prop_weed_01",
			Items = { { 1.0, "Blue Dream Weed", {1,3} }, { 0.40, "Blue Dream Weed Seed", {1,1} } },
			Harvestable = true,
		},
		{
			Model = "prop_weed_02",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
	},
})

Register("Purple Kush Weed Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 0.75,
	Placement = "Floor",
	Model = {
		"prop_weed_02",
	},
	Stages = {
		{
			Age = 480,
			Model = "prop_weed_01",
			Items = { { 1.0, "Purple Kush Weed", {1,3} }, { 0.5, "Purple Kush Weed Seed", {1,1} } },
			Harvestable = true,
		},
		{
			Model = "prop_weed_02",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
	},
})

Register("Girl Scout Cookies Weed Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 0.75,
	Placement = "Floor",
	Model = {
		"prop_weed_02",
	},
	Stages = {
		{
			Age = 480,
			Model = "prop_weed_01",
			Items = { { 1.0, "Girl Scout Cookies Weed", {1,3} }, { 0.55, "Girl Scout Cookies Weed Seed", {1,1} } },
			Harvestable = true,
		},
		{
			Model = "prop_weed_02",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
	},
})

Register("Tomato Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_veg_crop_04_leaf",
	},
	Stages = {
		{
			Age = 360,
			Model = "prop_veg_crop_02",
			Items = { { 1.0, "Tomato", {1,4} } },
			Harvestable = true,
		},
		{
			Age = 240,
			Model = "prop_veg_crop_04_leaf",
		},
		{
			Model = "proc_mntn_stone01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Seed Potato Segment", {
	Decay = 72,
	DecayInside = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_veg_crop_04_leaf",
	},
	Stages = {
		{
			Age = 360,
			Model = "prop_veg_crop_04_leaf",
			Items = { { 1.0, "Potatoes", {1,4} } },
			Harvestable = true,
		},
		{
			Model = "proc_mntn_stone01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Carrot Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_veg_crop_02",
	},
	Stages = {
		{
			Age = 360,
			Model = "prop_veg_crop_02",
			Items = { { 1.0, "Carrot", {1,2} } },
			Harvestable = true,
		},
		{
			Age = 240,
			Model = "prop_veg_crop_04_leaf",
		},
		{
			Model = "proc_mntn_stone01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Pumpkin Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_veg_crop_03_pump",
	},
	Stages = {
		{
			Age = 1440,
			Model = "prop_veg_crop_03_pump",
			Items = { { 1.0, "Pumpkin", {1,1} } },
			Harvestable = true,
		},
		{
			Age = 720,
			Model = "prop_veg_crop_04_leaf",
		},
		{
			Model = "proc_mntn_stone01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Cabbage Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_veg_crop_03_cab",
	},
	Stages = {
		{
			Age = 1440,
			Model = "prop_veg_crop_03_cab",
			Items = { { 1.0, "Cabbage", {1,1} } },
			Harvestable = true,
		},
		{
			Age = 720,
			Model = "prop_veg_crop_04_leaf",
		},
		{
			Model = "proc_mntn_stone01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Wheat Seed", {
	Decay = 72,
	DecayInside = true,
	NoCenter = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_veg_grass_02_a",
	},
	Stages = {
		{
			Age = 1440,
			Model = "prop_veg_grass_02_a",
			Items = { { 1.0, "Wheat", {1,5} } },
			Harvestable = true,
		},
		{
			Age = 720,
			Model = "prop_veg_crop_04_leaf",
		},
		{
			Model = "proc_mntn_stone01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Orange Tree Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 2.0,
	Placement = "Floor",
	Model = {
		"prop_sapling_break_01",
	},
	Stages = {
		{
			Age = 720,
			Model = "prop_veg_crop_orange",
			Items = { { 1.0, "Orange", {2,5} } },
			Harvestable = true,
		},
		{
			Age = 240,
			Model = "prop_sapling_break_02",
		},
		{
			Model = "prop_sapling_break_01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Apple Tree Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 2.0,
	Placement = "Floor",
	Model = {
		"prop_sapling_break_01",
	},
	Stages = {
		{
			Age = 720,
			Model = "prop_veg_crop_orange",
			Items = { { 1.0, "Apple", {2,5} } },
			Harvestable = true,
		},
		{
			Age = 240,
			Model = "prop_sapling_break_02",
		},
		{
			Model = "prop_sapling_break_01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Lemon Tree Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 2.0,
	Placement = "Floor",
	Model = {
		"prop_sapling_break_01",
	},
	Stages = {
		{
			Age = 720,
			Model = "prop_veg_crop_orange",
			Items = { { 1.0, "Lemon", {2,5} } },
			Harvestable = true,
		},
		{
			Age = 240,
			Model = "prop_sapling_break_02",
		},
		{
			Model = "prop_sapling_break_01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Lime Tree Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 2.0,
	Placement = "Floor",
	Model = {
		"prop_sapling_break_01",
	},
	Stages = {
		{
			Age = 720,
			Model = "prop_veg_crop_orange",
			Items = { { 1.0, "Lime", {2,5} } },
			Harvestable = true,
		},
		{
			Age = 240,
			Model = "prop_sapling_break_02",
		},
		{
			Model = "prop_sapling_break_01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Peach Tree Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 2.0,
	Placement = "Floor",
	Model = {
		"prop_sapling_break_01",
	},
	Stages = {
		{
			Age = 720,
			Model = "prop_veg_crop_orange",
			Items = { { 1.0, "Peach", {2,5} } },
			Harvestable = true,
		},
		{
			Age = 240,
			Model = "prop_sapling_break_02",
		},
		{
			Model = "prop_sapling_break_01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Strawberry Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_veg_crop_02",
	},
	Stages = {
		{
			Age = 720,
			Model = "prop_veg_crop_02",
			Items = { { 1.0, "Strawberry", {2,5} } },
			Harvestable = true,
		},
		{
			Age = 240,
			Model = "prop_veg_crop_04_leaf",
		},
		{
			Model = "proc_mntn_stone01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Watermelon Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_agave_02",
	},
	Stages = {
		{
			Age = 1440,
			Model = "prop_agave_02",
			Items = { { 1.0, "Watermelon", {1,1} } },
			Harvestable = true,
		},
		{
			Age = 720,
			Model = "prop_veg_crop_04_leaf",
		},
		{
			Model = "proc_mntn_stone01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Blueberry Seed", {
	Decay = 72,
	DecayInside = true,
	NoCenter = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_bush_med_03_cr",
	},
	Stages = {
		{
			Age = 720,
			Model = "prop_bush_med_03_cr",
			Items = { { 1.0, "Blueberry", {2,5} } },
			Harvestable = true,
		},
		{
			Age = 240,
			Model = "prop_veg_crop_04_leaf",
		},
		{
			Model = "proc_mntn_stone01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Pineapple Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_aloevera_01",
	},
	Stages = {
		{
			Age = 1440,
			Model = "prop_aloevera_01",
			Items = { { 1.0, "Pineapple", {1,1} } },
			Harvestable = true,
		},
		{
			Age = 720,
			Model = "prop_veg_crop_04_leaf",
		},
		{
			Model = "proc_mntn_stone01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Marjoram Seed", {
	Decay = 72,
	DecayInside = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_plant_cane_01a",
	},
	Stages = {
		{
			Age = 360,
			Model = "prop_plant_cane_01a",
			Items = { { 1.0, "Marjoram", {2,5} } },
			Harvestable = true,
		},
		{
			Age = 240,
			Model = "prop_veg_crop_04_leaf",
		},
		{
			Model = "proc_mntn_stone01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Thyme Seed", {
	Decay = 72,
	DecayInside = true,
	NoCenter = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_bush_med_03_cr2",
	},
	Stages = {
		{
			Age = 360,
			Model = "prop_bush_med_03_cr2",
			Items = { { 1.0, "Thyme", {2,5} } },
			Harvestable = true,
		},
		{
			Age = 240,
			Model = "prop_veg_crop_04_leaf",
		},
		{
			Model = "proc_mntn_stone01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Sage Seed", {
	Decay = 72,
	DecayInside = true,
	NoCenter = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_bush_med_03_cr2",
	},
	Stages = {
		{
			Age = 360,
			Model = "prop_bush_med_03_cr2",
			Items = { { 1.0, "Sage", {2,5} } },
			Harvestable = true,
		},
		{
			Age = 240,
			Model = "prop_veg_crop_04_leaf",
		},
		{
			Model = "proc_mntn_stone01",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
	},
})

Register("Chicken Coop", {
	NoDecay = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_chickencoop_a",
	},
	Stages = {
		{
			Age = 240,
			Model = "prop_chickencoop_a",
			Items = { { 1.0, "Egg", {2,5} } },
			Harvestable = true,
			Persistent = true,
		},
		{
			Model = "prop_chickencoop_a",
		},
	},
	Materials = {
		[3594309083] = true,
		[-1286696947] = true,
		[-1885547121] = true,
		[-1942898710] = true,
		[1333033863] = true,
		[1109728704] = true,
		[-700658213] = true,
		[510490462] = true,
		[2128369009] = true,
	},
})

Register("Milking", {
	NoDecay = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_bucket_01a",
	},
	Stages = {
		{
			Age = 240,
			Model = "prop_bucket_01a",
			Items = { { 1.0, "Milk", {5,10} } },
			Harvestable = true,
			Persistent = true,
		},
		{
			Model = "prop_bucket_01a",
		},
	},
	Materials = {
		[2128369009] = true,
		[510490462] = true,
	},
})

Register("Beehive", {
	NoDecay = true,
	Radius = 1.0,
	Placement = "Floor",
	Model = {
		"prop_byard_block_01",
	},
	Stages = {
		{
			Age = 1440,
			Model = "prop_byard_block_01",
			Items = { { 1.0, "Honey", {1,4} } },
			Harvestable = true,
			Persistent = true,
		},
		{
			Model = "prop_byard_block_01",
		},
	},
	Materials = {
		[2128369009] = true,
		[510490462] = true,
	},
})

