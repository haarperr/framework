AddNpc({ -- Pillbox.
	id = "DOCTOR_A",
	coords = vector4(324.1757507324219, -580.3070068359375, 43.2840576171875, 159.65611267089844),
	model = "s_m_m_doctor_01",
	idle = {
		dict = "mini@hookers_spcokehead",
		name = "idle_wait",
		flag = 49
	},
})

AddNpc({ -- Pillbox.
	name = "Freddy",
	id = "JANITOR_A",
	coords = vector4(325.2513732910156, -597.1519165039062, 43.28402328491211, 29.63226127624512),
	model = "csb_janitor",
	idle = {
		dict = "friends@frl@ig_1",
		name = "look_lamar",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = "What is it now?",
			condition = function(self)
				if exports.jobs:GetCurrentJob("paramedic") then
					return false, false, "I swear I was just going to clean that!"
				else
					return true
				end
			end,
			responses = {
				{
					text = "Sup dude.",
					next = "SUH",
				},
				{
					text = "You hear everything, what's new?.",
					next = "BATHROOM",
				},
				{
					text = "You are doing a great job!",
					next = "GOODJOB",
				},
			},
		},
		["SUH"] = {
			text = "suh dood.",
			next = "INIT"
		},
		["BATHROOM"] = {
			text = "Apparently, if you can make a diamond keycard then it will reward well...",
			next = "INIT"
		},
		["GOODJOB"] = {
			text = "Thank you, means alot more than you think.",
			next = "INIT"
		},
	},
})

AddNpc({ -- Paleto.
	id = "RECEPTIONIST_A",
	coords = vector4(-252.04217529296875, 6335.5869140625, 32.42720413208008, 168.1917266845703),
	model = "s_m_m_doctor_01",
	idle = {
		dict = "missheistdockssetup1showoffcar@base",
		name = "base_5",
		flag = 1
	},
})

AddNpc({ -- Sandy.
	id = "RECEPTIONIST_B",
	coords = vector4(1830.6348876953127, 3676.43994140625, 34.36486801147461, 208.8287353515625),
	model = "s_m_m_doctor_01",
	idle = {
		dict = "mp_fib_grab",
		name = "loop",
		flag = 49
	},
})

AddNpc({ -- Sandy.
	id = "RECEPTIONIST_C",
	coords = vector4(1825.6165771484375, 3668.029443359375, 34.38890234375, 19.83708763122558),
	model = "s_f_y_scrubs_01",
	idle = {
		dict = "mp_fib_grab",
		name = "loop",
		flag = 49
	},
})
