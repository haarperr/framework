TickRate = 200

Main.update = {}
Main.vehicles = {}

function Main:Update()
	-- Update globals.
	Ped = PlayerPedId()
	CurrentVehicle = GetVehiclePedIsIn(Ped)
	EnteringVehicle = GetVehiclePedIsEntering(Ped)
	IsDriver = GetPedInVehicleSeat(CurrentVehicle, -1) == Ped
	IsInVehicle = DoesEntityExist(CurrentVehicle)

	-- Disables hotwiring.
	DisableControlAction(0, 77)
	DisableControlAction(0, 78)

	-- Update vehicle being entered.
	if EnteringVehicle ~= (self.entering or 0) then
		if DoesEntityExist(EnteringVehicle) then
			print("begin enter", EnteringVehicle)
			self:InvokeListener("BeginEnter", EnteringVehicle)
			TriggerEvent("vehicles:beginEnter", EnteringVehicle)
		elseif DoesEntityExist(self.entering) then
			print("finish enter", self.entering)
			self:InvokeListener("FinishEnter", self.entering)
			TriggerEvent("vehicles:finishEnter", self.entering)
		end

		self.entering = EnteringVehicle
	end

	-- Update current vehicle.
	if CurrentVehicle ~= (self.vehicle or 0) then
		-- The last vehicle has been exited.
		if self.vehicle and DoesEntityExist(self.vehicle) then
			-- Events.
			print("exited", self.vehicle)
			self:InvokeListener("Exit", self.vehicle)
			TriggerEvent("vehicles:exit", self.vehicle)

			local netId = GetNetworkId(self.vehicle)
			if netId then
				TriggerServerEvent("vehicles:exit", netId)
			end
		end
		
		-- A new vehicle has been entered.
		if IsInVehicle then
			-- Events.
			print("entered", CurrentVehicle)
			self:InvokeListener("Enter", CurrentVehicle)
			TriggerEvent("vehicles:enter", CurrentVehicle)
			
			local netId = GetNetworkId(CurrentVehicle)
			if netId then
				TriggerServerEvent("vehicles:enter", netId)
			end

			-- Global settings.
			Class = GetVehicleClass(CurrentVehicle)
			ClassSettings = Classes[Class] or {}
		end
		
		self.vehicle = CurrentVehicle
	end

	-- General values.
	if IsInVehicle then
		IsSirenOn = IsVehicleSirenOn(CurrentVehicle)
		EngineOn = GetIsVehicleEngineRunning(CurrentVehicle)
		InAir = IsEntityInAir(CurrentVehicle)
		Clutch = GetVehicleClutch(CurrentVehicle)
		Gear = GetVehicleCurrentGear(CurrentVehicle)
		OnWheels = IsVehicleOnAllWheels(CurrentVehicle)
		Rpm = EngineOn and GetVehicleCurrentRpm(CurrentVehicle) or 0.0
		Speed = GetEntitySpeed(CurrentVehicle)
		IsIdling = EngineOn and Rpm < 0.2001 and Speed < 1.0
	end
	
	-- Driver stuff.
	if IsDriver then
		-- Idling.
		if IsIdling ~= self.isIdling then
			self.isIdling = IsIdling
			
			if not IsIdling then
				self.lastIdleTime = GetGameTimer()
			end
		end

		-- Gear shifting.
		if Gear ~= self.gear then
			self.gearDelta = Gear - (self.gear or 0)
			self.gearSwitchTime = GetGameTimer()
			self.gear = Gear

			print("Switch gear", Gear)
		end

		-- Controls.
		Braking = (IsControlPressed(0, 72) or IsControlPressed(0, 76)) and Gear > 0
		if Braking ~= self.braking then
			print("Braking", Braking, Gear)
			self.braking = Braking
			if Braking then
				self.brakeGear = Speed > 1.0 and Gear
			end
		end
		
		Accelerating = IsControlPressed(0, 71)
		if Accelerating ~= self.accelerating then
			print("Accelerating", Accelerating)
			self.accelerating = Accelerating
		end

		-- Prevent double clutching, results in slower acceleration immediately after down shifting.
		if Accelerating and self.gearDelta <= -1 and self.gearSwitchTime and GetGameTimer() - self.gearSwitchTime < Config.Values.GearShiftDownDelay then
			SetVehicleClutch(CurrentVehicle, 0.0)
		end

		-- Prevent accidental reversing when braking.
		if IsDisabledControlPressed(0, 72) or IsDisabledControlPressed(0, 76) then
			if self.brakeGear and self.brakeGear > 0 and Gear == 0 then
				DisableControlAction(0, 72)
			end
		else
			self.brakeGear = nil
		end

		-- Prevent burn-out when leaving an idle state.
		local idlePadding = Accelerating and not IsDisabledControlPressed(0, 21) and self.lastIdleTime and (GetGameTimer() - self.lastIdleTime) / 2000.0
		if idlePadding and idlePadding < 1.0 then
			SetVehicleCurrentRpm(CurrentVehicle, math.min(Rpm, idlePadding * 0.8 + 0.2))
			SetVehicleClutch(CurrentVehicle, math.min(Clutch, idlePadding * 0.8 + 0.2))
		end

		-- Prevent vehicle rolling.
		if (InAir or not OnWheels) and not ClassSettings.AirControl then
			DisableControlAction(0, 59)
			DisableControlAction(0, 60)
		end
	end

	-- Invoke update listener.
	self:InvokeListener("Update")
end

function Main.update:Proximity()
	if IsDriver then
		NearestVehicle = nil
		NearestDoor = nil
	else
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		NearestVehicle = GetNearestVehicle(coords, 10.0)

		if NearestVehicle and DoesEntityExist(NearestVehicle) then
			NearestDoor = GetClosestDoor(coords, NearestVehicle)
		else
			NearestDoor = nil
		end
	end

	if self.nearestVehicle ~= NearestVehicle then
		self.nearestVehicle = NearestVehicle
		self:InvokeListener("UpdateNearestVehicle", NearestVehicle)
	end

	if self.nearestDoor ~= NearestDoor then
		self.nearestDoor = NearestDoor
		self:InvokeListener("UpdateNearestDoor", NearestVehicle, NearestDoor)
	end
end

-- function Main:UpdateBones(vehicle)
-- 	self.bones = {}

-- 	local boneCache = {}
-- 	for _, boneName in ipairs(Bones) do
-- 		local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)
-- 		if boneIndex ~= -1 then
-- 			boneCache[boneIndex] = boneName
-- 		end
-- 	end

-- 	local boneCount = GetEntityBoneCount(vehicle)
-- 	for i = 0, boneCount - 1 do
-- 		local name = boneCache[i]
-- 		if name then
-- 			self.bones[name] = i
-- 		end
-- 	end
-- end

function Main:ToggleDoor(vehicle, index)
	local angleRatio = GetVehicleDoorAngleRatio(vehicle, index)
	if angleRatio > 0.5 then
		SetVehicleDoorShut(vehicle, index, false)
	else
		SetVehicleDoorOpen(vehicle, index, false, false)
	end
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
		for name, func in pairs(Main.update) do
			func(Main)
		end

		-- Update time.
		lastUpdate = GetGameTimer()

		Citizen.Wait(TickRate)
	end
end)