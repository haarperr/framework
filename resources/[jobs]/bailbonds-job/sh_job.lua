exports.jobs:Register("Bailbonds", {
	--Clocks = {
	--	vector3(-232.7588653564453, 6342.2216796875, 32.38544082641601),
	--},
	Ranks = {
		["Employee"] = 0,
		["Manager"] = 10,
		["Owner"] = 20,
	},
	Master = { "Judge" },
	ControlAt = 10,
	UseGroup = true,
	Pay = 100,
	Tracker = {
		Group = "bailbonds",
		Color = 11,
		SecondaryColor = 10,
	},
})