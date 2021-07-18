local Distance = 1.5
local Text = "tackle"
local TackleTime = 0
IsTackled = false

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		while IsTackled do
			Citizen.Wait(200)
		end
		
		if IsControlPressed( 0, 21 ) and IsControlJustPressed( 0, 38 ) and GetGameTimer() - TackleTime > 10000 then
			local player = GetPlayer(Distance)

			if player and not exports.interaction:IsHandcuffed(true) and (GetEntitySpeed(PlayerPedId()) >= 3 ) then
				TackleTime = GetGameTimer()
				SendMessage(player, "tackle")

				exports.emotes:PerformEmote({
					Dict = "missmic2ig_11",
					Name = "mic_2_ig_11_intro_goon",
					Flag = 48,
					Duration = 1500
				})
			end
		end
		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
Messages["tackle"] = function(source, message, value)
	--exports.emotes:PerformEmote({
	--	Dict = "missmic2ig_11",
	--	Name = "mic_2_ig_11_intro_p_one",
	--	Flag = 32,
	--	Duration = 500
	--})
	

	Citizen.Wait(1000)
	SetPedToRagdoll( PlayerPedId(), 2500, 0, 0 )
end