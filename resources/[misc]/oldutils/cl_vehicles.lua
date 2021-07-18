exports("GetSeatPedIsIn", function(vehicle, ped)
	local seats = GetVehicleMaxNumberOfPassengers(vehicle)
	for i = -1, seats - 1 do
		if GetPedInVehicleSeat(vehicle, i) == ped then
			return i
		end
	end
end)

exports("CreateVehicle", function(model, x, y, z, heading, isNetwork, isMissionEntity, thisScriptCheck)
	if not IsModelInCdimage(model) or not IsModelAVehicle(model) then
		return false
	end

	while not HasModelLoaded(model) do RequestModel(model) Citizen.Wait(1) end

	local vehicle = CreateVehicle(model, x, y, z, heading, isNetwork, thisScriptCheck or false)

	if isNetwork then
		NetworkRegisterEntityAsNetworked(vehicle)
	end
	if isMissionEntity then
		local netId = VehToNet(vehicle)
		SetEntityAsMissionEntity(vehicle)
		SetEntitySomething(vehicle, true)
		if NetworkGetEntityIsNetworked(vehicle) then
			SetNetworkIdExistsOnAllMachines(netId, true)
		end
	else
		SetEntityAsNoLongerNeeded(vehicle)
	end

	SetModelAsNoLongerNeeded(model)

	return vehicle
end)