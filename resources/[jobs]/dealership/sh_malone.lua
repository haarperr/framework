exports.jobs:Register("maloneandsons", {
	Title = "Dealership",
	Name = "Malone & Son's",
	Faction = "dealer",
	Group = "maloneandsons",
	-- Description = "Known for winning situations.",
	--Flags = PD_FLAGS,
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "dealer",
		State = "maloneandsons",
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