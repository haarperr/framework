exports.jobs:Register("pdm", {
	Title = "Dealership",
	Name = "Premium Deluxe Motorsports",
	Faction = "dealership",
	Group = "pdm",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Ranks = {
		{ Name = "Dealer" },
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