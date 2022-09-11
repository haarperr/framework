local waitTime = 15000
local doctors = {
	{
		coords = vector4(2439.29296875, 4962.93896484375, 46.8105583190918, 23.02151489257813),
		model = "mp_m_freemode_01",
		data = json.decode('[1,27,4,8,9,[4,1,6,5,7,7,5,8,9,9,1,10,9,6,5,4,2,10,10,5],[[0,0.0,1],[11,0.91,4],[16,0.96,4],[13,0.43,1],[0,0.0,1,1],[0,0.0,1,1],[0,0.13,1],[0,0.11,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1]],[[0,0,1,1],[0,0,1,1],[2,0,2,2],[169,0,1,1],[180,0,1,1],[0,0,1,1],[140,1,1,1],[210,0,1,1],[214,0,1,1],[0,0,1,1],[151,0,1,1],[334,0,1,1]],0,[[203,0],[0,0],[0,0],[],[],[],[117,2],[0,0]],[[],[],[]]]'),
		target = vector4(2437.90986328125, 4960.3837890625, 45.572342681884766, 323.5800476074219),
	}
}

for doctorId, doctor in ipairs(doctors) do
	AddNpc({
		name = "Gomez",
		id = "TERRITORY_DOCTOR-"..tostring(doctorId),
		coords = doctor.coords,
		model = doctor.model,
		data = doctor.data,
		stages = {
			["INIT"] = {
				text = "How can I help?",
				condition = function(self)
					if IsInGang() then
						return true
					else
						return false, false, { "Hello?", "REJECT" }
					end
				end,
				responses = {
					{
						text = "What do you do here?",
						dialogue = "People get hurt. They come to me. I offer a much more discrete service than the hospital, but I only accept cash. I'll treat you personally for $500--flat. Treating somebody that is incapacitated will cost $750.",
					},
					{
						text = "I need medical treatment.",
						condition = function(self)
							return true
						end,
						callback = function(self)
							TriggerServerEvent("territories:revive", false, doctorId)
						end
					},
					{
						text = "Can you help this person?",
						condition = function(self)
							return exports.interaction:IsEscorting()
						end,
						callback = function(self)
							escorting = exports.interaction:GetEscorting()
							if not escorting then return end

							exports.interaction:StopEscorting()

							Citizen.Wait(200)
							
							TriggerServerEvent("territories:revive", escorting, doctorId)
						end,
					},
				},
			},
		},
	})
end

RegisterNetEvent("territories:revive")
AddEventHandler("territories:revive", function(doctorId)
	local doctor = doctors[doctorId]
	if not doctor then return end

	local ped = PlayerPedId()

	exports.health:ResurrectPed(ped)

	exports.mythic_notify:SendAlert("inform", "Resting...", waitTime)
	
	FreezeEntityPosition(ped, true)
	SetEntityCoords(ped, doctor.target.x, doctor.target.y, doctor.target.z)
	SetEntityHeading(ped, doctor.target.w)

	exports.emotes:PerformEmote({
		Dict = "switch@franklin@bed",
		Name = "sleep_loop",
		Flag = 1,
		BlendIn = 1000.0,
		BlendOut = 1000.0,
		IgnoreCancel = true,
	})
	
	Citizen.Wait(waitTime)

	exports.emotes:PerformEmote({
		Dict = "switch@franklin@bed",
		Name = "sleep_getup_rubeyes",
		Flag = 0,
		BlendIn = 1000.0,
		BlendOut = 10.0,
		IgnoreCancel = true,
	}, false, PlayerPedId(), true)

	Citizen.Wait(3000)

	FreezeEntityPosition(PlayerPedId(), false)
end)