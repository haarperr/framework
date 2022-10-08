AddNpc({
	name = "Griffin",
	id = "TERRITORY_GRIFFIN",
	quest = "TERRITORY_DAILY_GRIFFIN",
	-- coords = vector4(428.9096984863281, -976.9622802734376, 30.71024513244629, 146.14797973632812),
	coords = vector4(-1158.466064453125, -523.63232421875, 32.54770278930664, 232.89083862304688),
	model = "u_m_m_spyactor",
	idle = {
		dict = "misscarsteal4@actor",
		name = "actor_warming_up_loop_2",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return "Please, I need time to prepare--hold on, did you bring my package?"
				else
					return "Please, I need time to prepare. The most significant role I have ever played is afoot."
				end
			end,
			responses = {
				{
					text = "I have the gold.",
					quest = true,
				},
				{
					text = "What are you preparing for?",
					dialogue = "Spoilers, but, it's for the climax to my next feature film. The antagonist comes in and tries to steal the gold bars and I, playing a notoroius mob boss, shoots him down with my Gusenberg Sweeper. I wanted to use a real one, but the board turned it down.",
				},
			},
		},
		["QUEST_END"] = {
			text = "At last! These glistening bars of gold will be of great help!",
			next = "INIT",
		},
	},
})