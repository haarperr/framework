AddNpc({
	name = "Trish",
	id = "TASKS_TRISH",
    quest = "TASKS_DAILY_TRISH",
	coords = vector4(1425.9666748046875, 6352.98486328125, 23.98499488830566, 271.8819274902344),
	model = "cs_ashley",
	idle = {
		dict = "timetable@amanda@ig_9",
		name = "ig_9_base_amanda",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return "You better have my cute branch babies?"
				else
					return "MY BABIES!! Go away until you have them!"
				end
			end,
			responses = {
				{
					text = "You are so kind, so sweet, such a pretty face!",
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