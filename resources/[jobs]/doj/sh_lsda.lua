exports.jobs:Register("lsda", {
	Title = "State",
	Name = "Los Santos District Attorney",
	Faction = "state",
	Group = "lsda",
	Clocks = {
		--{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
	},
	Tracker = {
		Group = "state",
		State = "lsda",
	},
	Ranks = {
		{ Name = "Paralegal" },
		{ Name = "State Attorney" },
		{ Name = "Probationary Investigator" },
		{ Name = "Investigator" },
		{ Name = "Chief Investigator" },
		{ Name = "Assistant District Attorney" },
		{ Name = "District Attorney" },
		{
			Name = "Deputy Attorney General",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Attorney General",
			Flags = Jobs.Permissions.ALL()
		},
	},
})