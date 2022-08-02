exports.jobs:Register("pdm", {
	Title = "Dealership",
	Name = "Premium Deluxe Motorsports",
	Faction = "dealer",
	Group = "pdm",
	-- Description = "Known for winning situations.",
	--Flags = PD_FLAGS,
	Clocks = {
		{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
		{ Coords = vector3(453.5949, -980.6509, 30.57985), Radius = 3.5 },
	},
	Tracker = {
		Group = "dealer",
		State = "pdm",
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