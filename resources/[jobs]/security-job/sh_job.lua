exports.jobs:Register("Security", {
	--Clocks = {
	--	vector3(578.09619140625, -3119.18310546875, 18.76865768432617),
	--},
	Ranks = {
		["Recruit"] = 0,
		["Probationary Guard"] = 10,
		["Guard"] = 20,
		["Senior Guard"] = 30,
		["Team Lead"] = 40,
		["Legal Team"] = 50,
		["Management"] = 60,
		["Owner"] = 70,
	},
	Master = { "Judge" },
	ControlAt = 60,
	UseGroup = true,
	Group = "Security",
	Pay = 20,
	Tracker = {
		Group = "security",
		Color = 48,
		SecondaryColor = 2,
	},
})