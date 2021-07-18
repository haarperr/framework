AddNpc({
	name = "Garry",
	id = "TERRITORY_GARRY",
	quest = "TERRITORY_DAILY_GARRY",
	-- coords = vector4(428.3697509765625, -981.7973022460938, 30.7102108001709, 15.550079345703123),
	coords = vector4(-39.65930938720703, -2702.89453125, 6.167046546936035, 290.6504211425781),
	model = "s_m_m_dockwork_01",
	idle = {
		dict = "clothingshoes",
		name = "check_out_a",
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
					text = "What do you do here?",
					dialogue = "I work here... or at least I'm trying to. I lost a key to one of the storage houses. I'm trying to find it.",
				},
			},
		},
		["QUEST_END"] = {
			text = "Thanks.",
			next = "INIT",
		},
	},
})