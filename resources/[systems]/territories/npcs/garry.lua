AddNpc({
	name = "Garry",
	id = "TERRITORY_GARRY",
	quest = "TERRITORY_DAILY_GARRY",
	coords = vector4(-1000.9124145507812, 4853.255859375, 274.605712890625, 158.8517303466797),
	model = "s_m_m_dockwork_01",
	idle = {
		dict = "amb@world_human_smoking@male@male_a@idle_a",
		name = "idle_a",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return "I was told to expect you. You have the lettuce?"
				else
					return "Excuse me, but I have work to do."
				end
			end,
			responses = {
				{
					text = "Yeah. I have it right here.",
					quest = true,
				},
				{
					text = "What are you doing?",
					dialogue = "Making sure the radio tower stays optimal.. damn hippies.",
				},
			},
		},
		["QUEST_END"] = {
			text = "Thanks.",
			next = "INIT",
		},
	},
})