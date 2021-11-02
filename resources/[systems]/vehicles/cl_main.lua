TickRate = 200

Main.update = {}
Main.settings = {}
Main.vehicles = {}
Main.classes = {}
Main.info = {}

function Main:Init()
	for model, settings in pairs(Vehicles) do
		-- Get name.
		settings.Name = GetLabelText(model)
		if settings.Name == "NULL" then
			settings.Name = model:gsub("^%l", string.upper)
		end

		-- Get class.
		settings.Class = GetVehicleClassFromName(model)

		-- Cache settings.
		self.settings[model] = settings

		-- Cache class.
		local classList = self.classes[settings.Class]
		if not classList then
			classList = {}
			self.classes[settings.Class] = classList
		end
		classList[model] = settings
	end
end

function Main:Update()
	-- Update globals.
	Ped = PlayerPedId()
	CurrentVehicle = GetVehiclePedIsIn(Ped)
	EnteringVehicle = GetVehiclePedIsEntering(Ped)
	IsInVehicle = DoesEntityExist(CurrentVehicle)
	IsDriver = IsInVehicle and GetPedInVehicleSeat(CurrentVehicle, -1) == Ped

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

	-- General values.
	if IsInVehicle then
		Coords = GetEntityCoords(CurrentVehicle)
		IsSirenOn = IsVehicleSirenOn(CurrentVehicle)
		EngineOn = GetIsVehicleEngineRunning(CurrentVehicle)
		InAir = IsEntityInAir(CurrentVehicle)
		Clutch = GetVehicleClutch(CurrentVehicle)
		Gear = GetVehicleCurrentGear(CurrentVehicle)
		OnWheels = IsVehicleOnAllWheels(CurrentVehicle)
		Rpm = EngineOn and GetVehicleCurrentRpm(CurrentVehicle) or 0.0
		Speed = GetEntitySpeed(CurrentVehicle)
		SpeedVector = GetEntitySpeedVector(CurrentVehicle, false)
		Forward = GetEntityForwardVector(CurrentVehicle)
		Velocity = GetEntityVelocity(CurrentVehicle)
		
		ForwardDot = Dot(Forward, SpeedVector)
		IsIdling = EngineOn and Rpm < 0.2001 and Speed < 1.0

		if #Velocity > 1.0 then
			LastVelocity = Velocity / #Velocity
			-- DrawLine(Coords.x, Coords.y, Coords.z, Coords.x + LastVelocity.x * 10.0, Coords.y + LastVelocity.y * 10.0, Coords.z + LastVelocity.z * 10.0, 255, 255, 0, 128)
		end
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
			-- Global settings.
			Class = GetVehicleClass(CurrentVehicle)
			ClassSettings = Classes[Class] or {}
			Model = GetEntityModel(CurrentVehicle)

			-- Events.
			print("entered", CurrentVehicle)
			self:InvokeListener("Enter", CurrentVehicle)
			TriggerEvent("vehicles:enter", CurrentVehicle)
			
			local netId = GetNetworkId(CurrentVehicle)
			if netId then
				TriggerServerEvent("vehicles:enter", netId)
			end
		end
		
		self.vehicle = CurrentVehicle
	end
	
	-- Driver stuff.
	if IsDriver then
		local fuel = GetVehicleFuelLevel(CurrentVehicle) -- TODO: set fuel properly.
		SetVehicleFuelLevel(CurrentVehicle, fuel - Speed * 0.0001)

		-- Temperature.
		Temperature = GetVehicleEngineTemperature(CurrentVehicle)
		TemperatureRatio = Temperature / 104.444

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
				self.brakeGear = Speed > 1.0 and ForwardDot > 0.0 and Gear
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
	local state = angleRatio < 0.1

	self:SetDoorState(vehicle, index, not state)
end

function Main:SetDoorState(vehicle, index, state, fromServer)
	local driver = GetPedInVehicleSeat(vehicle, -1)
	if driver and DoesEntityExist(driver) and driver ~= PlayerPedId() and not fromServer then
		TriggerServerEvent("vehicles:toggleDoor", GetNetworkId(vehicle), index, state)
		return
	end

	WaitForAccess(vehicle)

	if state then
		SetVehicleDoorShut(vehicle, index, false)
	else
		SetVehicleDoorOpen(vehicle, index, false, false)
	end
end

function Main:ToggleBay(vehicle)
	if AreBombBayDoorsOpen(vehicle) then
		CloseBombBayDoors(vehicle)
	else
		OpenBombBayDoors(vehicle)
	end
end

function Main:CanGetInSeat(vehicle, seat)
	return IsVehicleSeatFree(vehicle, seat) -- add more checks I guess
end

function Main:Subscribe(vehicle, value)
	TriggerServerEvent("vehicles:subscribe", GetNetworkId(vehicle), value)
end

--[[ Exports ]]--
exports("GetSettings", function(model)
	return Vehicles[model]
end)

exports("GetClass", function(id)
	return Classes[id]
end)

exports("GetVehicles", function()
	return Main.settings
end)

exports("GetClasses", function()
	return Main.classes
end)

--[[ Events ]]--
AddEventHandler("vehicles:clientStart", function()
	Main:Init()
end)

--[[ Events: Net ]]--
RegisterNetEvent("vehicles:sync", function(netId, key, value)
	-- if not CurrentVehicle or GetNetworkId(CurrentVehicle) ~= netId then return end

	if type(key) == "table" then
		Main.info = key
	else
		Main.info[key] = value
	end

	print("Sync", netId, json.encode(key), json.encode(value))

	Main:InvokeListener("Sync", key, value)
end)

RegisterNetEvent("vehicles:toggleDoor", function(netId, index, state)
	local vehicle = NetworkGetEntityFromNetworkId(netId)
	if not vehicle or not DoesEntityExist(vehicle) then return end

	Main:SetDoorState(vehicle, index, state, true)
end)

RegisterNetEvent("vehicles:clean", function(netId)
	if not NetworkDoesEntityExistWithNetworkId(netId) then return end

	local vehicle = NetworkGetEntityFromNetworkId(netId)
	if not vehicle or not DoesEntityExist(vehicle) then return end

	RemoveDecalsFromVehicle(vehicle)
end)

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