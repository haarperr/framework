AddNpc({
	name = "Ben",
	id = "TASKS_BEN",
	quest = "TASKS_DAILY_BEN",
	coords = vector4(-1067.81640625, -2083.2470703125, 13.29149627685546, 295.0635986328125),
	model = "ig_floyd",
	idle = {
		dict = "rcmpaparazzo1ig_1",
		name = "idle",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return "Please tell me you have some copper?"
				else
					return "Look, I don't have time to talk, get outta here!"
				end
			end,
			responses = {
				{
					text = "Thank you, thank you!! If there's ever anything you need done just harass Rajesh Gupta instead of me but thank you!!",
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