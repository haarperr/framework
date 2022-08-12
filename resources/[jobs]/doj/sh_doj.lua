exports.jobs:Register("doj", {
	Title = "Federal",
	Name = "Department of Justice",
	Faction = "federal",
	Group = "doj",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "emergency",
		State = "federal",
	},
	Ranks = {
		{ Name = "Judge" },
		{ Name = "Court Manager" },
		{
			Name = "Justice",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Chief Justice",
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