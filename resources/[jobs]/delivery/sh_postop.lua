exports.jobs:Register("postop", {
	Title = "Dealership",
	Name = "Post-Op",
	Faction = "delivery",
	Group = "postop",
	IsPublic = true,
	Delivery = {
		Center = vector3(-101.2231674194336, -902.0380859375, 58.2816047668457),
		Properties = {
			Radius = 3000.0,
			Max = 128,
			Types = {
				["motel"] = true,
				["apartment"] = true,
				["house"] = true,
				["mansion"] = true,
			},
		},
		-- Destinations = {
		-- 	vector3(-294.1211242675781, -917.2229614257812, 31.08061790466309),
		-- 	vector3(-294.03851318359375, -914.292724609375, 31.08061981201172),
		-- 	vector3(-296.4261474609375, -913.3141479492188, 31.08061981201172),
		-- 	vector3(-298.4041442871094, -915.0750732421876, 31.08061981201172),
		-- 	vector3(-297.544189453125, -917.4437866210938, 31.08061981201172),
		-- },
		Pay = 32,
	},
	Clocks = {
		{ Coords = vector3(-232.45993041992188, -915.5792236328124, 32.3108024597168), Radius = 3.5 },
	},
	Vehicles = {
		{
			Rank = 0,
			In = vector3(-228.3406982421875, -911.2813110351564, 32.31079483032226),
			Model = "boxville4",
			PrimaryColor = 0,
			SecondaryColor = 0,
			Coords = {
				vector4(-211.29608154296875, -916.7569580078124, 29.29507255554199, 155.83604431152344),
				vector4(-225.6054840087891, -893.7627563476562, 29.77957344055175, 251.0935516357422),
			},
		},
	},
	Ranks = {
		{ Name = "Delivery Driver" },
		{
			Name = "Manager",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Owner",
			Flags = Jobs.Permissions.ALL()
		},
	},
})