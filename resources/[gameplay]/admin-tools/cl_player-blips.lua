-- local Blips = {}
-- local Enabled = false

-- function InitializePlayers()
-- 	for k, player in ipairs(GetActivePlayers()) do
-- 		if player == PlayerId() then goto continue end
		
-- 		local ped = GetPlayerPed(player)
-- 		local key = "Player_"..player
-- 		blip = GetBlipFromEntity(ped)
-- 		if not DoesBlipExist(blip) then
-- 			local blip = AddBlipForEntity(ped)
-- 			SetBlipColour(blip, 37)
-- 			SetBlipScale(blip, 1.0)

-- 			AddTextEntry(key, ("~y~Player - %s"):format(GetPlayerName(player)))
			
-- 			Blips[blip] = true
-- 		end

-- 		local vehicle = GetVehiclePedIsIn(ped, false)
-- 		local sprite = 1
		
-- 		if DoesEntityExist(vehicle) then
-- 			local class = GetVehicleClass(vehicle)
-- 			if class == 15 then
-- 				sprite = 422
-- 			elseif class == 16 then
-- 				sprite = 423
-- 			elseif class == 14 then
-- 				sprite = 427
-- 			else
-- 				sprite = 426
-- 			end
-- 		end

-- 		SetBlipSprite(blip, sprite)
-- 		SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
-- 		SetBlipShowCone(blip, true)

-- 		BeginTextCommandSetBlipName(key)
-- 		EndTextCommandSetBlipName(blip)
-- 		::continue::
-- 	end
-- end

Options[#Options + 1] = {
	"Player Blips", "toggle",
	function(value)
		TriggerServerEvent("admin-tools:toggleBlips", value)
	end
}