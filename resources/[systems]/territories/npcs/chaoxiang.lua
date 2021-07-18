AddNpc({
	name = "Chaoxiang",
	id = "TERRITORY_CHAOXIANG",
	quest = "TERRITORY_DAILY_CHAOXIANG",
	coords = vector4(-316.8656005859375, -2780.05517578125, 5.000236988067627, 302.49261474609375),
	model = "ig_chengsr",
	idle = {
		dict = "amb@world_human_smoking@male@male_a@idle_a",
		name = "idle_a",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return "I was told they would send someone. 你有吗?"
				else
					return "Excuse me, but I have business to attend to."
				end
			end,
			responses = {
				{
					text = "Yeah. I have it right here.",
					quest = true,
				},
				{
					text = "What do you do here?",
					dialogue = "Does it really matter? Learn to mind your own business... 白痴.",
				},
			},
		},
		["QUEST_END"] = {
			text = "谢谢",
			next = "INIT",
		},
	},
})

AddNpc({
	id = "TRIAD_GUARD_A",
	coords = vector4(-317.8887023925781, -2768.055419921875, 5.140109539031982, 358.6650085449219),
	model = "csb_chin_goon",
	idle = {
		dict = "amb@world_human_leaning@male@wall@back@foot_up@base",
		name = "base",
	},
})

AddNpc({
	id = "TRIAD_GUARD_B",
	coords = vector4(-312.5845642089844, -2764.7529296875, 5.00023365020752, 82.22601318359375),
	model = "g_m_m_chigoon_01",
	idle = {
		dict = "amb@world_human_stand_guard@male@idle_a",
		name = "idle_a",
	},
})