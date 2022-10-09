AddNpc({
	name = "Rufus",
	id = "TERRITORY_RUFUS",
	quest = "TERRITORY_DAILY_RUFUS",
	coords = vector4(-439.8473815917969, 1596.75439453125, 358.4740295410156, 109.9923095703125),
	model = "s_m_y_dealer_01",
	idle = {
		dict = "amb@world_human_smoking@male@male_a@idle_a",
		name = "idle_a",
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
					dialogue = "Nice views are my thing..",
				},
			},
		},
		["QUEST_END"] = {
			text = "Thanks",
			next = "INIT",
		},
	},
})
