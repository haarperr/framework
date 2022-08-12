local Distance = 4.0
local Text = "test"

--[[ Functions ]]--

function SendMessage(target, message, value)
	TriggerServerEvent("interaction:send", target, message, value)
end
exports("SendMessage", SendMessage)

Messages["gsr-request"] = function(source, message, value)
	SendMessage(source, "gsr-respond", exports.evidence:DidShoot(true))
end

Messages["gsr-respond"] = function(source, message, value)
	local typeof
	if value then
		typeof = "success"
		message = "positive"
	else
		typeof = "error"
		message = "negative"
	end
	TriggerEvent("chat:notify", ("They came back %s!"):format(message), "inform")
end

--[[ Items ]]--
RegisterNetEvent("inventory:use_GunshotResidueKit")
AddEventHandler("inventory:use_GunshotResidueKit", function()
	if IsPedInAnyVehicle(PlayerPedId(), false) then return end

	local player, playerPed, playerDist = GetNearestPlayer(Distance)
	if player == 0 then return end
	
	exports.mythic_progbar:Progress({
		Anim = {
			Scenario = "WORLD_HUMAN_STAND_MOBILE",
			PlayEnterAnim = true,
		},
		Label = "GSR...",
		Duration = 8000,
		UseWhileDead = false,
		DisableMovement = true,
		CanCancel = true,
		Disarm = true,
	}, function(wasCanceled)
		if wasCanceled then return end
		
		player = GetPlayer(Distance)
		if player == 0 then
			TriggerEvent("chat:notify", "No player within range!", "error")
		else
			SendMessage(player, "gsr-request")
		end
	end)
end)