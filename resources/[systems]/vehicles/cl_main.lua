TickRate = 200
Towing = { Whitelist = {}, Blacklist = {} }

Main.info = {}
Main.update = {}

-- local maxFuel = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume")

--[[ Initialization ]]--
for k, v in pairs(Config.Towing.Whitelist) do
	Towing.Whitelist[GetHashKey(k)] = v
end

for k, v in pairs(Config.Towing.Blacklist) do
	Towing.Blacklist[GetHashKey(k)] = v
end

function Main:Update()
	-- Update globals.
	Player = PlayerId()
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
			--print("begin enter", EnteringVehicle)
			self:InvokeListener("BeginEnter", EnteringVehicle)
			TriggerEvent("vehicles:beginEnter", EnteringVehicle)
		elseif DoesEntityExist(self.entering) then
			--print("finish enter", self.entering)
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
		Fuel = GetVehicleFuelLevel(CurrentVehicle)
		
		DriftAngle = Dot(Forward, #Velocity > 0.01 and Normalize(Velocity) or Velocity)
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
			--print("exited", self.vehicle)
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
			Materials = {}
			Compressions = {}

			-- Events.
			--print("entered", CurrentVehicle)
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
		-- Fuel
		Fuel = Fuel - ( Speed * Config.Driving.FuelBurnRate )
		SetVehicleFuelLevel(CurrentVehicle, Fuel)
		
		-- Tire locking.
		if (
			math.abs(DriftAngle) < Config.Spinning.DotProduct and
			LastDamageEntity and GetEntityType(LastDamageEntity) == 2 and
			Speed > (LastDamageTime and GetGameTimer() - LastDamageTime < 3000 and Config.Spinning.LowSpeed or Config.Spinning.HighSpeed) * 0.44704
		) then
			LastLock = GetGameTimer()
		end
		
		local isLocked = LastLock and GetGameTimer() - LastLock < 1200
		if WasLocked ~= isLocked then
			SetVehicleBrake(CurrentVehicle, isLocked)
			SetVehicleHandbrake(CurrentVehicle, isLocked)

			if isLocked then
				StallVehicle()

				if GetRandomFloatInRange(0.0, 1.0) < Config.Spinning.CutChance then
					SetVehicleEngineOn(CurrentVehicle, false, true, true)
				end
			end
			
			WasLocked = isLocked
		end
		
		if isLocked then
			for i = 1, GetVehicleNumberOfWheels(CurrentVehicle) do
				SetVehicleWheelRotationSpeed(CurrentVehicle, i, 0.0)
				SetVehicleWheelBrakePressure(CurrentVehicle, i, 1.0)
			end
		end
		
	-- Prevent curb boosting.
		if LastCurbBoost and GetGameTimer() - LastCurbBoost < 200 and Speed * 0.621371 > 20.0 then
			SetVehicleCurrentRpm(CurrentVehicle, 0.0)
			-- SetVehicleClutch(CurrentVehicle, 0.0)
		end

		-- Temperature.
		Temperature = GetVehicleEngineTemperature(CurrentVehicle)
		TemperatureRatio = Temperature / 104.444

		-- Update wheels.
		for i = 0, GetVehicleNumberOfWheels(CurrentVehicle) - 1 do
			local compression = GetVehicleWheelSuspensionCompression(CurrentVehicle, i)
			local lastCompression = Compressions[i]

			if lastCompression and compression then
				local compressionDelta = math.abs(lastCompression - compression)
				if compressionDelta > 0.1 then
					LastCurbBoost = GetGameTimer()
				end
			end
			
			local material = GetVehicleWheelSurfaceMaterial(CurrentVehicle, i)
			Materials[i] = material
			Compressions[i] = compression
		end

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

			--print("Switch gear", Gear)
		end

		-- Controls.
		Braking = (IsControlPressed(0, 72) or IsControlPressed(0, 76)) and Gear > 0
		if Braking ~= self.braking then
			--print("Braking", Braking, Gear)
			self.braking = Braking
			if Braking then
				self.brakeGear = Speed > 1.0 and ForwardDot > 0.0 and Gear
			end
		end
		
		Accelerating = IsControlPressed(0, 71)
		if Accelerating ~= self.accelerating then
			--print("Accelerating", Accelerating)
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

		NearestVehicle = GetFacingVehicle(ped, 1.0, true) or GetNearestVehicle(coords, 3.0)

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
	local owner = NetworkGetEntityOwner(vehicle)
	local ownerPed = owner and owner ~= PlayerId() and GetPlayerPed(owner)

	if (ownerPed and DoesEntityExist(ownerPed) and IsPedInVehicle(ownerPed, vehicle)) or not WaitForAccess(vehicle, 3000) then
		TriggerServerEvent("vehicles:toggleDoor", GetNetworkId(vehicle), index, state)
		return
	end

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

function Tow()
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	local vehicles = exports.oldutils:GetVehicles()
	local targetVehicle = nil
	local sourceVehicle = nil
	local nearestSource = 0.0
	local nearestTarget = 0.0
	local currentBed = nil
	local attached = {}

	for k, vehicle in ipairs(vehicles) do
		local coords = GetEntityCoords(vehicle)
		local dist = #(coords - pedCoords)
		local attachedTo = GetEntityAttachedTo(vehicle)
		if DoesEntityExist(attachedTo) then
			if not sourceVehicle or dist < nearestSource then
				sourceVehicle = vehicle
				nearestSource = dist
				attached[attachedTo] = true
			end
		else
			local bed = Config.Towing.Beds[GetEntityModel(vehicle)]
			if bed and (not targetVehicle or dist < nearestTarget) then
				targetVehicle = vehicle
				currentBed = bed
				nearestTarget = dist
			elseif not sourceVehicle or dist < nearestSource then
				sourceVehicle = vehicle
				nearestSource = dist
			end
		end
	end

	if DoesEntityExist(sourceVehicle) and DoesEntityExist(targetVehicle) and currentBed then
		if not exports.oldutils:RequestAccess(sourceVehicle) then return end
		if not exports.oldutils:RequestAccess(targetVehicle) then return end

		local sourceModel = GetEntityModel(sourceVehicle)
		if (not Config.Towing.Classes[GetVehicleClass(sourceVehicle)] and not Towing.Whitelist[sourceModel]) or Towing.Blacklist[sourceModel] then
			TriggerEvent("chat:notify", { text = "It won't fit!", class = "error" })
			return
		end

		local entry = GetOffsetFromEntityInWorldCoords(targetVehicle, currentBed.Entry.x, currentBed.Entry.y, currentBed.Entry.z)
		if IsEntityAttached(sourceVehicle) then
			if #(pedCoords - GetEntityCoords(targetVehicle)) < Config.Towing.Distance then
				DetachEntity(sourceVehicle, true, true)
				SetEntityCoords(sourceVehicle, entry.x, entry.y, entry.z)
				return
			end
		else
			if not attached[targetVehicle] and #(GetEntityCoords(sourceVehicle) - entry) < Config.Towing.Distance then
				AttachEntityToEntity(
					sourceVehicle,
					targetVehicle,
					currentBed.Bone or 0,
					currentBed.Offset.x, currentBed.Offset.y, currentBed.Offset.z,
					currentBed.Rot.x, currentBed.Rot.y, currentBed.Rot.z,
					false,
					false,
					true,
					false,
					currentBed.Bone or 0,
					true
				)
				return
			end
		end

		TriggerEvent("chat:notify", { class = "error", text = "Not Close Enough!" })
	end
end

--[[ Exports ]]--
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
AddEventHandler("gameEventTriggered", function(name, args)
	if name ~= "CEventNetworkEntityDamage" then return end
	
	local ped = PlayerPedId()
	local vehicle, sourceEntity, fatalDamage, weaponUsed = args[1], args[2], args[4], args[5]

	if sourceEntity == -1 or not IsEntityAVehicle(vehicle) or not NetworkGetEntityIsNetworked(vehicle) or not NetworkHasControlOfEntity(vehicle) then return end

	-- Traffic lights.
	if sourceEntity and Config.TrafficLights[GetEntityModel(sourceEntity)] and GetEntityHealth(sourceEntity) < 1000 and GetRandomFloatInRange(0.0, 1.0) < 0.2 then
		local coords = GetEntityCoords(vehicle)
		exports.dispatch:Report("emergency", "10-49", 0, coords, vehicle, { coords = coords })
	end

	-- Damage types.
	local damageType = GetWeaponDamageType(weaponUsed)
	local isBullet = damageType == 3
	local isMelee = damageType == 2

	-- Get health stuff.
	local bodyHealth = GetVehicleBodyHealth(vehicle)
	local lastBodyHealth = 1000.0
	
	-- Damage.
	local bodyDamage = lastBodyHealth - bodyHealth

	-- Hit and runs.
	if IsEntityAPed(sourceEntity) and sourceEntity ~= PlayerPedId() then
		-- Hit and runs.
		exports.peds:AddEvent("hitandrun")
	elseif bodyDamage > 10.0 then
		-- Reckless driving.
		exports.peds:AddEvent("reckless")
	end
end)

RegisterCommand("flip", function(source, args, rawCommand)
	if IsPedInAnyVehicle(PlayerPedId(), false) then return end

	local vehicle = exports.oldutils:GetNearestVehicle()
	if not DoesEntityExist(vehicle) then return end
	if not exports.oldutils:RequestAccess(vehicle) then return end

	local ped = PlayerPedId()
	if #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > Config.Flipping.MaxDistance then return end

	exports.mythic_progbar:Progress(Config.Flipping.Action, function(wasCancelled)
		if wasCancelled then return end
		if not DoesEntityExist(vehicle) then return end
		if not exports.oldutils:RequestAccess(vehicle) then return end
		if #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > Config.Flipping.MaxDistance then return end

		local rot = GetEntityRotation(vehicle)
		SetEntityRotation(vehicle, 0.0, 0.0, rot.z)
		PlaceObjectOnGroundProperly(vehicle)
	end)
end, false)

RegisterCommand("anchor", function()
	local vehicle = exports.oldutils:GetNearestVehicle()
	local ped = PlayerPedId()

	if (
		not vehicle or
		not DoesEntityExist(vehicle)
		or GetVehicleClass(vehicle) ~= 14
		or #(GetEntityCoords(vehicle) - GetEntityCoords(ped)) > 10.0
	) then
		TriggerEvent("chat:notify", { class = "error", text = "This isn't a boat you can anchor!" })
		return
	end

	if IsPedSwimming(ped) or IsPedInAnyVehicle(ped) or IsPedGettingIntoAVehicle(ped) then
		TriggerEvent("chat:notify", { class = "error", text = "You can't do that!" })
		return
	end

	local anchored = IsBoatAnchoredAndFrozen(vehicle)

	Config.AnchorAction.Label = anchored and "Lifting anchor..." or "Lowering anchor..."

	exports.mythic_progbar:Progress(Config.AnchorAction, function(wasCancelled)
		if wasCancelled then return end

		exports.oldutils:RequestAccess(vehicle)
		
		SetForcedBoatLocationWhenAnchored(vehicle, true)
		SetBoatFrozenWhenAnchored(vehicle, true)
		SetBoatAnchor(vehicle, not anchored)
	end)
end)

RegisterCommand("tow", function(source, args, command)
	exports.mythic_progbar:Progress(Config.Towing.Action, function(wasCancelled)
		if wasCancelled then return end
		Tow()
	end)
end)

--[[ Events: Net ]]--
RegisterNetEvent("vehicles:sync", function(netId, key, value)
	-- if not CurrentVehicle or GetNetworkId(CurrentVehicle) ~= netId then return end

	Main.infoEntity = NetworkGetEntityFromNetworkId(netId)

	if type(key) == "table" then
		Main.info = key
	else
		Main.info[key] = value
	end

	--print("Sync", netId, json.encode(key), json.encode(value))

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

		-- Reset modifers.
		BrakeModifier = 1.0
		MaxFlatModifier = 1.0
		TractionCurveModifier = 1.0
		TractionLossModifier = 1.0

		-- Update functions.
		for name, func in pairs(Main.update) do
			func(Main)
		end

		-- Update time.
		lastUpdate = GetGameTimer()

		Citizen.Wait(TickRate)
	end
end)




