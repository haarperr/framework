Messages["force"] = function(source, message, value)
	if not value and not exports.emotes:AreHandsUp() and not IsHandcuffed and not IsZiptied and not exports.health:IsPedDead() then
		return
	end
	
	local ped = PlayerPedId()
	local currentVehicle = GetVehiclePedIsIn(ped, false)
	
	if DoesEntityExist(currentVehicle) then
		TaskLeaveVehicle(ped, currentVehicle, 16)

		return
	end

	local nearestVehicle = exports.oldutils:GetNearestVehicle()
	if not DoesEntityExist(nearestVehicle) then return end

	local nearestDoor = exports.vehicles:GetNearestSeat(nearestVehicle, 3.0, true)
	if nearestDoor == nil then return end
	local locked = GetVehicleDoorsLockedForPlayer(nearestVehicle, ped)
	if not locked then
		StopBeingEscorted()
		SetPedIntoVehicle(ped, nearestVehicle, nearestDoor)
	else
		exports.mythic_notify:SendAlert("error", "The vehicle is locked!", 7000)
	end
end

RegisterCommand("force", function(source, args, command)
	if not CanDo() or IsPedInAnyVehicle(PlayerPedId(), true) then return end
	local player = GetPlayer(2.0)
	if player ~= 0 then
		SendMessage(player, "force", exports.jobs:IsInEmergency())
	else
		NobodyNearby("force")
	end
end)