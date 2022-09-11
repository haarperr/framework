AddNpc({
	name = "Mercenary",
	id = "TERRITORY_MERC",
	quest = "TERRITORY_DAILY_MERC",
	-- coords = vector4(429.8319091796875, -979.5164184570312, 30.710418701171875, 72.54087829589844),
	coords = vector4(3513.331787109375, 3755.48828125, 29.962472915649418, 349.94696044921875),
	model = "csb_mweather",
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return "You must be the delivery ^pronoun_formal. Do you have our blueprints?"
				else
					return "It's dangerous around here. Watch yourself."
				end
			end,
			responses = {
				{
					text = "I have your order.",
					quest = true,
				},
				{
					text = "Who are you?",
					dialogue = "None of your business.",
				},
				{
					text = "What is this place?",
					dialogue = "This is Humane Labs and Research. All you need to know is that it's dangerous around here.",
				},
			},
		},
		["QUEST_END"] = {
			text = "We'll put these to good use.",
			next = "INIT",
		},
	},
})