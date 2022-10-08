AddNpc({
	name = "Bert",
	id = "TERRITORY_BERT",
	quest = "TERRITORY_DAILY_BERT",
	coords = vector4(710.7650756835938, 536.7893676757812, 129.84458923339844, 7.51581239700317),
	model = "s_m_m_hairdress_01",
	idle = {
		dict = "switch@michael@sitting",
		name = "idle",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return "Please tell me that you got the ring?"
				else
					return "Excuse me, but I'm waiting for someone important."
				end
			end,
			responses = {
				{
					text = "Yeah. I have it right here.",
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
