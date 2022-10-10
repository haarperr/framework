AddNpc({
	name = "Jessie",
	id = "TERRITORY_BILLY",
	quest = "TERRITORY_DAILY_BILLY",
	-- coords = vector4(425.9872131347656, -981.4188232421876, 30.70981216430664, 344.5561218261719),
	coords = vector4(-1230.248046875, -169.30221557617188, 39.32523727416992, 151.6962890625),
	model = "mp_m_freemode_01",
	data = json.decode('[1,28,21,10,7,[10,8,2,4,5,9,6,7,7,8,9,6,6,4,4,6,4,5,6,3],[[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1]],[[0,0,1,1],[0,0,1,1],[5,0,9,1],[14,0,1,1],[129,0,1,1],[0,0,1,1],[118,0,1,1],[0,0,1,1],[15,0,1,1],[0,0,1,1],[0,0,1,1],[192,5,1,1]],0,[[0,0],[0,0],[0,0],[],[],[],[0,0],[0,0]],[{"1":1},[],[]]]'),
	idle = {
		dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@",
		name = "high_center",
		flag = 1
	},
	stages = {
		["INIT"] = {
			text = function(self)
				if self:HasQuest(true) then
					return { "Please tell me you brought me something!", "INTRO2" }
				else
					return { "I have so much grass! Let's go!", "INTRO1" }
				end
			end,
			responses = {
				{
					text = "Yeah. I got the stuff.",
					quest = true,
				},
				{
					text = "Who are you?",
					dialogue = { "I'm Jessie! Puff puff pass...", "INTRO" },
				},
				{
					text = "Do you live here?",
					dialogue = { "No! They throw really cool parties here all the time. With lots of grass!", "LIVEHERE" },
				},
			},
		},
		["QUEST_END"] = {
			text = { "Thank you!", "THANKS" },
			next = "INIT",
		},
	},
})
