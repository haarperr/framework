AddNpc({
	name = "Billy",
	id = "TERRITORY_BILLY",
	quest = "TERRITORY_DAILY_BILLY",
	-- coords = vector4(425.9872131347656, -981.4188232421876, 30.70981216430664, 344.5561218261719),
	coords = vector4(-1465.3963623046875, 63.13937377929688, 52.93687057495117, 187.71424865722656),
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
					return { "I have so much energy powder! Let's go!", "INTRO1" }
				end
			end,
			responses = {
				{
					text = "Yeah. I got the stuff.",
					quest = true,
				},
				{
					text = "Who are you?",
					dialogue = { "I'm Billy Bacilli and I am not silly! I don't know why people keep saying that...", "INTRO" },
				},
				{
					text = "Do you live here?",
					dialogue = { "No! They throw really cool parties here all the time. With lots of energy powder!", "LIVEHERE" },
				},
			},
		},
		["QUEST_END"] = {
			text = { "Thank you!", "THANKS" },
			next = "INIT",
		},
	},
})