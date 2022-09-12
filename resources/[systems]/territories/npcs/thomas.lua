local template = {
	interact = "Talk",
	animations = {
		idle = { Dict = "timetable@ron@ig_3_couch", Name = "base", Flag = 1 },
	},
}

local thomas = {
	{
		id = "TERRITORY",
		name = "Thomas",
		coords = vector4(-1610.4593505859375, -3011.478271484375, -75.20503997802734, 189.7862243652344),
		instance = "territory_1",
		appearance = json.decode('{"makeupOverlays":[4,2,3,0,0,0,35,35,35,32,32,32],"components":[1,1,1,1,1,1,197,17,119,29,18,1,1,1,1,1,1,4,1,1,1,1],"props":[1,104,34,1,1,1,4,1,1,1],"hair":[149,0,60]}'),
		features = json.decode('{"eyeColor":0,"overlays":[],"hairOverlays":[11,1,1,0.61,1,1,12,1,1],"bodyType":1,"otherOverlays":[1,1,1,1,1,1,0.18896675193231,0.00735024856576,0.11427237434617,0.00811838253267,0.93986320495605,0.635582447052,0.13508403301239],"faceFeatures":[0.27272727272727,-0.81818181818181,0.81818181818181,-0.63636363636363,-0.45454545454545,0.27272727272727,-0.63636363636363,-0.09090909090909,0.45454545454545,-0.27272727272727,0.45454545454545,0.27272727272727,0.27272727272727,-0.45454545454545,-0.45454545454545,0.81818181818181,-0.27272727272727,0.63636363636363,0.81818181818181,-0.45454545454545],"model":1,"blendData":[7,3,1,7,3,1,0.81818181818181,0.81818181818181,0.0]}'),
		options = {
			{
				text = "Back in business?",
				dialogue = "Nope.",
				once = true,
			}
		},
	},
}

Citizen.CreateThread(function()
	while not Npcs do
		Citizen.Wait(0)
	end

	for _, info in ipairs(thomas) do
		for k, v in pairs(template) do
			info[k] = v
		end
		local npc = Npcs:Register(info)
	end
end)