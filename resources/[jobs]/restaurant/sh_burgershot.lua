exports.jobs:Register("burgershot", {
	Title = "Restaurant",
	Name = "Burger Shot",
	Faction = "restaurant",
	Group = "burgershot",
	Clocks = {
		{ Coords = vector3(-1187.074, -900.2129, 13.97847), Radius = 3.5 },
	},
	Tracker = {
		Group = "restaurant",
		State = "burgershot",
	},
	Ranks = {
		{ Name = "Employee" },
		{ Name = "Shift Lead" },
		{ Name = "Assistant Manager" },
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