AddNpc({
	name = "Marcus",
	id = "TERRITORY_MARCUS",
	quest = "TERRITORY_DAILY_MARCUS",
	coords = vector4(1126.4461669921875, -1242.94970703125, 21.366884231567383, 150.65798950195312),
	model = "ig_joeminuteman",
	idle = {
		dict = "amb@world_human_smoking@male@male_a@idle_a",
		name = "idle_a",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return "You got the money?"
				else
					return "What do you want?"
				end
			end,
			responses = {
				{
					text = "Yeah. I have the money right here.",
					quest = true,
				},
				{
					text = "What do you do around here?",
					dialogue = "I mind my own business. Maybe you should do the same.",
				},
				{
					text = "Got anything for me?",
					dialogue = "Maybe. Depends on who I'm talking to.",
				},
			},
		},
		["QUEST_END"] = {
			text = "Here... make good use of it.",
			next = "INIT",
		},
	},
})