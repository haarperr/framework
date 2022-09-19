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
})]]
