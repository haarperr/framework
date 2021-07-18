AddNpc({
	name = "Johnny",
	id = "TERRITORY_JOHNNY",
	quest = "TERRITORY_DAILY_JOHNNY",
	coords = vector4(-141.04026794433597, -948.8388061523438, 269.1353454589844, 23.30349731445313),
	model = "s_m_y_dockwork_01",
	idle = {
		dict = "amb@world_human_leaning@male@wall@back@hands_together@idle_b",
		name = "idle_e",
		flag = 129
	},
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return "I was told to Jerome would send somebody. You have the shipment?"
				else
					return "No offense, but I'm trying to enjoy my break."
				end
			end,
			responses = {
				{
					text = "Yeah. I have it right here.",
					quest = true,
				},
				{
					text = "What are you working on?",
					dialogue = "We are building a new skyscraper called the Mile High Club.",
				},
			},
		},
		["QUEST_END"] = {
			text = "Thanks.",
			next = "INIT",
		},
	},
})

AddNpc({
	id = "TERRITORY_WORKER_A",
	coords = vector4(-142.65701293945312, -954.5726806640624, 270.3351623535156, 67.26657104492188),
	model = "s_m_y_construct_02",
	idle = {
		dict = "timetable@ron@ig_3_couch",
		name = "base",
		flag = 1
	},
})

AddNpc({
	id = "TERRITORY_WORKER_B",
	coords = vector4(-161.73587036132812, -950.9749145507812, 269.22723388671875, 69.52130126953125),
	model = "s_m_y_construct_01",
	idle = {
		dict = "amb@world_human_hammering@male@base",
		name = "base",
		flag = 1
	},
})

AddNpc({
	id = "TERRITORY_WORKER_C",
	coords = vector4(-148.0117645263672, -985.4036254882812, 269.2358093261719, 162.9005889892578),
	model = "s_m_y_construct_01",
	idle = {
		dict = "amb@prop_human_seat_bar@male@hands_on_bar@idle_b",
		name = "idle_d",
		flag = 49
	},
})