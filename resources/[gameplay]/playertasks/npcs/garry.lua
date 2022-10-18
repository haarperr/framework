AddNpc({
	name = "Garry",
	id = "TASKS_GARRY",
	quest = "TASKS_DAILY_GARRY",
	coords = vector4(1135.8203125, -477.51116943359375, 66.24131774902344, 255.577880859375),
	model = "ig_drfriedlander",
	idle = {
		dict = "anim@amb@nightclub@peds@",
		name = "amb_world_human_leaning_female_wall_back_texting_idle_a",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return "You must be bringing ye olde electronics?"
				else
					return "Sorry, the person you are trying to reach is currently unavailable. Fuck off!"
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