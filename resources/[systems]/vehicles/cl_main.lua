TickRate = 200

Main.update = {}
Main.processes = {}
Main.vehicles = {}

function Main:Update()
	Ped = PlayerPedId()
	CurrentVehicle = GetVehiclePedIsIn(Ped)
	EnteringVehicle = GetVehiclePedIsEntering(Ped)
	IsDriver = GetPedInVehicleSeat(CurrentVehicle, -1) == Ped

	if EnteringVehicle ~= (self.entering or 0) then
		print("entering", EnteringVehicle)
		self.entering = EnteringVehicle
	end

	if CurrentVehicle ~= (self.vehicle or 0) then
		print("entered", CurrentVehicle)

		if self.vehicle then
			self:InvokeListener("Exit", self.vehicle)
			
			TriggerEvent("vehicles:exit", self.vehicle)

			if DoesEntityExist(self.vehicle) and NetworkGetEntityIsNetworked(self.vehicle) then
				TriggerServerEvent("vehicles:exit", NetworkGetNetworkIdFromEntity(self.vehicle))
			end
		end
		
		if DoesEntityExist(CurrentVehicle) then
			self:InvokeListener("Enter", CurrentVehicle)
			TriggerEvent("vehicles:enter", CurrentVehicle)
			
			if DoesEntityExist(CurrentVehicle) and NetworkGetEntityIsNetworked(CurrentVehicle) then
				TriggerServerEvent("vehicles:enter", NetworkGetNetworkIdFromEntity(CurrentVehicle))
			end
		end
		
		self.vehicle = CurrentVehicle
	end

	self:InvokeListener("Update")
end

function Main:GetNearestVehicle(coords, maxDist)
	local nearestVehicle = nil
	local nearestDist = 0.0

	for vehicle, _ in EnumerateVehicles() do
		local dist = #(coords - GetEntityCoords(vehicle))
		if (not maxDist or dist < maxDist) and (not nearestVehicle or dist < nearestDist) then
			nearestVehicle = vehicle
			nearestDist = dist
		end
	end

	return nearestVehicle, nearestDist
end

function Main:GetClosestDoor(coords, vehicle)
	local nearestDoor = nil
	local nearestDist = 0.0

	for index = 0, GetNumberOfVehicleDoors(vehicle) - 1 do
		local doorCoords = GetEntryPositionOfDoor(vehicle, index)
		local dist = doorCoords and #doorCoords > 0.001 and #(doorCoords - coords)

		if dist and (not nearestDoor or dist < nearestDist) then
			nearestDoor = index
			nearestDist = dist
		end
	end

	return nearestDoor, nearestDist
end

function Main:GetClosestSeat(coords, vehicle, mustBeEmpty)
	local nearestDoor = nil
	local nearestDist = 0.0
	local model = GetEntityModel(vehicle)

	for index = -1, GetVehicleModelNumberOfSeats(model) - 2 do
		local ped = mustBeEmpty and GetPedInVehicleSeat(vehicle, index)
		if not mustBeEmpty or not ped or not DoesEntityExist(ped) then
			local doorCoords = GetEntityBonePosition_2(vehicle, GetEntityBoneIndexByName(vehicle, Config.Bones[index + 2]))
			local dist = doorCoords and #doorCoords > 0.001 and #(doorCoords - coords)

			if dist and (not nearestDoor or dist < nearestDist) then
				nearestDoor = index
				nearestDist = dist
			end
		end
	end

	return nearestDoor, nearestDist
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	local lastUpdate = GetGameTimer()
	
	while true do
		-- Update delta.
		DeltaTime = GetGameTimer() - lastUpdate
		MinutesToTicks = 1.0 / 60000.0 * DeltaTime

		-- Update functions.
		if Main.vehicle then
			for name, func in pairs(Main.update) do
				func(Main)
			end
		end

		-- Update time.
		lastUpdate = GetGameTimer()

		Citizen.Wait(TickRate)
	end
end)