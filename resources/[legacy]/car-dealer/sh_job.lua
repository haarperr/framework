exports.jobs:Register("Car Dealer", {
	RequireBusiness = true,
	Ranks = {
		["Salesperson"] = 0,
		["Manager"] = 8,
		["Boss"] = 10,
	},
	Master = { "Judge", "Justice" },
	ControlAt = 8,
})