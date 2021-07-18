AddNpc({
	name = "Rufus",
	id = "TERRITORY_RUFUS",
	quest = "TERRITORY_DAILY_RUFUS",
	coords = vector4(-449.0765686035156, 1062.326416015625, 327.6821899414063, 136.5984039306641),
	model = "s_m_y_dealer_01",
	idle = {
		dict = "amb@prop_human_seat_bar@male@hands_on_bar@idle_b",
		name = "idle_d",
		flag = 49
	},
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return "You the guy with the uh... stuff?"
				else
					return "Uh... what do you want?"
				end
			end,
			responses = {
				{
					text = "Yeah. I have it right here.",
					quest = true,
				},
				{
					text = "What are you doing up here?",
					dialogue = "Just chillin' at the moment?",
				},
				{
					text = "How's the view?",
					dialogue = "Use your eyes and you tell me.",
				},
			},
		},
		["QUEST_END"] = {
			text = "Thanks",
			next = "INIT",
		},
	},
})