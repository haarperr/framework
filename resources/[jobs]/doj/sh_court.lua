exports.jobs:Register("doj", {
	Title = "Federal",
	Name = "Courthouse",
	Faction = "federal",
	Group = "doj",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Ranks = {
		{ Name = "Secretary" },
		{ Name = "Head Secretary" },
		{ Name = "Clerk" },
		{
			Name = "Judge",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Court Manager",
			Flags = Jobs.Permissions.ALL()
		},
	},
	Licenses = {
		{ Name = "Drivers" },
		{ Name = "Boating" },
		{ Name = "Weapons" },
		{ Name = "Fishing" },
		{ Name = "Hunting" },
		{ Name = "Pilots" },
		{ Name = "Commercial-Hunting" },
	},
})