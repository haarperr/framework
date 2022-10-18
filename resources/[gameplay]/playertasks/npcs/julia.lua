AddNpc({
	name = "Julia",
	id = "TASKS_JULIA",
	quest = "TASKS_DAILY_JULIA",
	coords = vector4(-2193.3544921875, 4291.25927734375, 49.17412567138672, 238.7976837158203),
	model = "ig_mrsphillips",
	idle = {
		dict = "rcmpaparazzo1ig_1",
		name = "idle",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return "You have it?"
				else
					return "If you don't have my fish, I'm not interested."
				end
			end,
			responses = {
				{
					text = "You are not the hero we deserve.",
					quest = true,
				},
			},
		},
		["QUEST_END"] = {
			text = "Thanks.",
			next = "INIT",
		},
	},
})