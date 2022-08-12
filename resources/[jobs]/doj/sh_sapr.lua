exports.jobs:Register("sapr", {
	Title = "Federal",
	Name = "San Andreas Park Rangers",
	Faction = "federal",
	Pay = 90,
	Group = "sapr",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "emergency",
		State = "federal",
	},
	Ranks = {
		{ Name = "Ranger" },
		{ Name = "Senior Ranger" },
		{ Name = "Sergeant" },
		{
			Name = "Superintendent",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Game Warden",
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
	},
})