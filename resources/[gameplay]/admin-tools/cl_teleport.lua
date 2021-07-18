function Functions:ProcessTeleport()
	if PowerLevel < Config.Teleport.PowerLevel then return end

	if IsControlJustPressed(0, Config.Teleport.Key) then
		local blip = GetFirstBlipInfoId(8)
		if DoesBlipExist(blip) then
			local coords = GetBlipCoords(blip)
			local height = 1000.0
			SetCoords(coords.x, coords.y, height)

			Citizen.CreateThread(function()
				local endTime = GetGameTimer() + 5000
				
				while GetGameTimer() < endTime do
					Citizen.Wait(1)
					local retval, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, height)
					if retval then
						SetCoords(coords.x, coords.y, groundZ)
						break
					else
						height = height - 10.0
						SetCoords(coords.x, coords.y, height)
					end
				end
			end)
		end
	end
end

RegisterNetEvent("admin-tools:goto")
AddEventHandler("admin-tools:goto", function(coords, instance)
	local ped = PlayerPedId()

	local currentInstance = exports.instances:GetPlayerInstance() or {}

	TriggerEvent("disarmed")

	if currentInstance.id ~= instance then
		if instance then
			if currentInstance.id then
				TriggerServerEvent("instances:exit")
				Citizen.Wait(0)
			end
			TriggerServerEvent("instances:join", instance)
			Citizen.Wait(2000)
		else
			exports.instances:LeaveInstance()
		end
	end

	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z)
end)