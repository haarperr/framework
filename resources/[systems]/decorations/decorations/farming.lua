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
			Items = { { 1.0, "Weed", {1,3} }, { 0.25, "Weed Seed", {1,1} } },
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
			Items = { { 1.0, "Blue Dream Weed", {1,3} }, { 0.25, "Blue Dream Weed Seed", {1,1} } },
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