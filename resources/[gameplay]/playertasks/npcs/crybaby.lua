AddNpc({
	name = "Crybaby",
	id = "TASKS_CRYBABY",
	quest = "TASKS_DAILY_CRYBABY",
	coords = vector4(-1700.51220703125, -1126.83837890625, 13.15244674682617, 153.85313415527344),
	model = "a_f_y_runner_01",
	idle = {
		dict = "anim@amb@business@bgen@bgen_no_work@",
		name = "sit_phone_phoneputdown_idle_nowork",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return "Do you have my boo boo fixer?"
				else
					return "Go away, I'm hurting!"
				end
			end,
			responses = {
				{
					text = "Here you go, wipe those eyes.",
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
