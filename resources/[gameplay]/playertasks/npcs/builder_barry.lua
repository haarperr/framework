AddNpc({
	name = "Builder Barry",
	id = "TASKS_BUILDER_BARRY",
	quest = "TASKS_DAILY_BUILDER_BARRY",
	coords = vector4(-3066.721923828125, 619.8284912109375, 7.38350534439086, 106.44432830810548),
	model = "s_m_y_construct_01",
	idle = {
		dict = "switch@michael@pier",
		name = "pier_lean_smoke_idle",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return "Do you have the wood?"
				else
					return "I can't build something out of nothing dumbass!"
				end
			end,
			responses = {
				{
					text = "Here you go, good job.",
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
