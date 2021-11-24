--[[
	Labs
		shell_coke1
		shell_coke2
		shell_meth
		shell_weed
		shell_weed2
	
	Offices
		shell_office1
		shell_office2
		shell_officebig
		
	Houses
		shell_apartment1
		shell_apartment2
		shell_apartment3
		shell_banham
		shell_frankaunt
		shell_highend
		shell_highendv2
		shell_lester
		shell_medium2
		shell_medium3
		shell_michael
		shell_ranch
		shell_trailer
		shell_trevor
		shell_v16low
		shell_v16mid
		shell_westons
		shell_westons2
]]

Config = {
	GridSize = 2,
	DoorRadius = 2.0,
	GarageRadisu = 3.0,
	Types = {
		["motel"] = {
			Entry = vector4(151.44100952148438, -1007.7667846679688, -99.00001525878906, 357.2196044921875),
		},
		["apartment_sm"] = {
			Shell = "apartment_sm",
		},
		["house"] = {
		},
		["mansion"] = {
		},
		["warehouse_sm"] = {
		},
		["warehouse_md"] = {
		},
		["warehouse_lg"] = {
		},
		["warehouse_xl"] = {
		},
	},
	Shells = {
		["apartment_sm"] = {
			Name = "Apartment",
			Model = `shell_trevor`,
			Entry = vector4(0.18750430643558, -3.51456928253173, 2.4279327392578, 358.0670166015625),
		},
		["apartment_md"] = {
			Name = "Apartment",
			Model = `shell_medium2`,
			Entry = vector4(6.14452028274536, 0.51251339912414, 1.0273895263672, 1.14755201339721),
		},
		["apartment_lg1"] = {
			Name = "Apartment",
			Model = `shell_apartment1`,
			Entry = vector4(-2.19454479217529, 8.66103172302246, 8.69442844390869, 184.3791046142578),
		},
		["house_sm"] = {
			Name = "House",
			Model = `shell_v16mid`,
			Entry = vector4(1.41482126712799, -14.02155303955078, 1.14791870117188, 0.40985843539237),
		},
		["office_sm"] = {
			Name = "Office",
			Model = `shell_office1`,
			Entry = vector4(1.2672529220581, 4.69660949707031, 2.04898071289065, 181.34971618652344),
		},
	},
}