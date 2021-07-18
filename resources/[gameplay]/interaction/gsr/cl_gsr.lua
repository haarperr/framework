local Distance = 4.0
local Text = "test"

--[[ Functions ]]--
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
	exports.mythic_notify:SendAlert(typeof, ("They came back %s!"):format(message), 10000)
end

Items["Gunshot Residue Kit"] = function()
	return CanUse(Distance, Text)
end

--[[ Items ]]--
RegisterNetEvent("inventory:use_GunshotResidueKit")
AddEventHandler("inventory:use_GunshotResidueKit", function()
	if IsPedInAnyVehicle(PlayerPedId(), false) then return end

	local player = GetPlayer(Distance)
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
			NobodyNearby(Text)
		else
			SendMessage(player, "gsr-request")
		end
	end)
end)