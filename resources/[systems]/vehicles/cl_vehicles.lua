Bones = {}
CruiseControl = nil
Debug = false
Draw3DText = exports.oldutils.Draw3DText
DrawContext = exports.oldutils.DrawContext
HandlingCache = {}
HealthBuffer = {}
Hotwiring = false
InTrunk = 0
IsEngineOn = false
Keys = {}
LastDriver = 0
LastForward = nil
LastHandlingChanged = {}
LastProcess = 0
LastProcessControls = 0
LastSpeed = 0.0
LastStall = 0
LastToggledEngine = 0.0
LookingAt = 0
NearestVehicle = 0
NearestVehicle2 = 0
Repairing = 0
SpeedBuffer = {}
TaingKey = false
Towing = { Whitelist = {}, Blacklist = {} }
Vehicle = 0
WasEngineOn = false
WasEntering = false
WheelieTime = 0

--[[ Initialization ]]--
for k, v in pairs(Config.Towing.Whitelist) do
	Towing.Whitelist[GetHashKey(k)] = v
end

for k, v in pairs(Config.Towing.Blacklist) do
	Towing.Blacklist[GetHashKey(k)] = v
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	DecorRegister("hotwired", 2)
	DecorRegister("lockpicked", 2)

	while true do
		Citizen.Wait(0)
		
		SetParkedVehicleDensityMultiplierThisFrame(0.9)
		SetRandomVehicleDensityMultiplierThisFrame(0.7)
		SetVehicleDensityMultiplierThisFrame(0.7)
		
		ProcessEntering()
		ProcessRefueling()
		-- ProcessHitching()
		ProcessWeapons()
		ProcessWindows()
		ProcessRestrainedExiting()
		ProcessRestrainedEntering()

		for k, v in ipairs({351, 350, 352, 353, 354, 354, 357}) do
			DisableControlAction(0, v)
		end
		
		local ped = PlayerPedId()
		
		if DoesEntityExist(Vehicle) then
			-- Disable weapon wheel.
			DisableControlAction(0, 99)
			DisableControlAction(0, 100)
			local isDriver = GetPedInVehicleSeat(Vehicle, -1) == ped
			local isPassenger = GetPedInVehicleSeat(Vehicle, 0) == ped
			if isDriver then
				-- Check for keys and drivability.
				if (HasKey(Vehicle) or DecorGetBool(Vehicle, "hotwired") or IsEngineOn or GetVehicleClass(Vehicle) == 13) and IsVehicleDriveable(Vehicle, false) then
					ProcessControls(Vehicle)
				else
					ProcessHotwire(Vehicle)
				end
				-- Force check engine.
				if not IsEngineOn and IsVehicleEngineOn(Vehicle) then
					SetVehicleEngineOn(Vehicle, false, true, true)
				end
				-- Disable roll.
				if (IsEntityInAir(Vehicle) or not IsEntityUpright(Vehicle, 80.0)) and not Config.TiltClasses[GetVehicleClass(Vehicle)] then
					DisableControlAction(0, 59)
					DisableControlAction(0, 60)
				end
				-- Leaving.
				if WasEngineOn and GetIsTaskActive(ped, 2) and IsVehicleDriveable(Vehicle) then
					while GetIsTaskActive(ped, 2) do
						SetVehicleEngineOn(Vehicle, true, true, true)
						Citizen.Wait(200)
					end
				end
				-- Max speed.
				if CruiseControl then
					SetControlNormal(0, 71, 1.0)
					if IsControlPressed(0, 72) then
						CruiseControl = nil
					end
				end
				SetVehicleMaxSpeed(Vehicle, CruiseControl)
			elseif isPassenger then
				if GetIsTaskActive(ped, 165) then
					SetPedIntoVehicle(ped, Vehicle, 0)
				end
				SetPedConfigFlag(ped, 184, true)
			end
		end

		WasEngineOn = IsEngineOn
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		Vehicle = GetVehiclePedIsIn(ped, false)

		if DoesEntityExist(Vehicle) then
			local isDriver = GetPedInVehicleSeat(Vehicle, -1) == ped
			if isDriver then
				ProcessDriving(Vehicle)
				LastSpeed = GetEntitySpeed(Vehicle)
				LastForward = GetEntityForwardVector(Vehicle)
			else
				LastForward = nil
			end
			SetPedConfigFlag(ped, 35, false)
		else
			LastForward = nil

			-- Get the two nearest vehicles.
			local nearestVehicle = exports.oldutils:GetNearestVehicle()
			local nearestVehicle2 = exports.oldutils:GetNearestVehicle(2)

			-- Uncache the nearest vehicles' bones.
			if NearestVehicle ~= nil and NearestVehicle ~= nearestVehicle then
				Bones[NearestVehicle] = nil
			end

			if NearestVehicle2 ~= nil and NearestVehicle2 ~= nearestVehicle2 then
				Bones[NearestVehicle2] = nil
			end

			-- Setup bones for the vehicles.
			ProcessBones(nearestVehicle)
			ProcessBones(nearestVehicle2)

			-- Cache the nearest vehicles.
			NearestVehicle = nearestVehicle
			NearestVehicle2 = nearestVehicle2
		end
		Citizen.Wait(400)
	end
end)

Citizen.CreateThread(function()
	while true do
		if DoesEntityExist(Vehicle) then
			ProcessSelfDamage()
		end

		Citizen.Wait(20)
	end
end)

--[[ Functions ]]--
function HasKey(vehicle)
	if not DoesEntityExist(vehicle) then return false end

	local netId = VehToNet(vehicle)
	if not netId then return false end

	return Keys[netId] == true
end

function ProcessDriving(vehicle)
	if LastProcess == 0 then
		LastProcess = GetGameTimer()
	end

	local class = GetVehicleClass(vehicle)
	local delta = GetGameTimer() - LastProcess
	local fuel = GetVehicleFuelLevel(vehicle)
	local isEngineOn = IsVehicleEngineOn(vehicle)
	local isGrounded = not IsEntityInAir(vehicle)
	local maxSpeed = GetVehicleEstimatedMaxSpeed(vehicle)
	local oil = GetVehicleOilLevel(vehicle)
	local oldFuel = fuel
	local speed = GetEntitySpeed(vehicle)
	local speedRatio = speed / maxSpeed
	local temperature = GetVehicleEngineTemperature(vehicle)
	local forward = GetEntityForwardVector(vehicle)
	local angleDot = 0.0

	if LastForward then
		angleDot = math.max(1.0 - exports.misc:Dot(forward, LastForward), 0.0)
	end

	if isEngineOn and (
		(class ~= 14 and isGrounded) or
		(class == 14 and GetEntitySubmergedLevel(vehicle) > 0.01) or -- Boats.
		class == 15 or class == 16 -- Helicopters or planes.
	) then
		fuel = fuel - speed / 50.0 * delta * Config.Driving.FuelBurnRate
		oil = oil - speed / 50.0 * delta * Config.Driving.OilBurnRate
	end

	SetVehicleFuelLevel(vehicle, math.max(fuel, 0.0))
	SetVehicleOilLevel(vehicle, math.max(oil, 0.0))

	if not Config.DrivableClasses[class] then
		LastProcess = GetGameTimer()
		return
	end

	InitializeVehicle(vehicle)

	-- Using these defaults.
	local brakeForce = GetDefaultHandling(vehicle, "fBrakeForce")
	local driveInertia = GetDefaultHandling(vehicle, "fDriveInertia")
	local handBrakeForce = GetDefaultHandling(vehicle, "fHandBrakeForce")
	local initialDriveForce = GetDefaultHandling(vehicle, "fInitialDriveForce")
	local initialDragCoeff = GetDefaultHandling(vehicle, "fInitialDragCoeff")
	local steeringLock = GetDefaultHandling(vehicle, "fSteeringLock")
	
	-- Axle processing.
	if isGrounded and steeringLock then
		local steering = math.abs(GetVehicleSteeringAngle(vehicle) / steeringLock * speedRatio)
		DamageDecor(vehicle, "Vehicle_AxleHealth", steering * delta * Config.Damage.AxleRate)
		SetHandling(vehicle, "fSteeringLock", steeringLock * (DecorGetFloat(vehicle, "Vehicle_AxleHealth") * Config.Damage.AxleModifier + (1.0 - Config.Damage.AxleModifier)))
	end
	
	-- Brake processing.
	if isGrounded and brakeForce and handBrakeForce then
		local brakes = 0.0

		for i = 1, 5 do
			brakes = brakes + GetVehicleWheelBrakePressure(vehicle, i) * speedRatio
		end

		local brakeDamage = DecorGetFloat(vehicle, "Vehicle_BrakeHealth") * Config.Damage.BrakeModifier + (1.0 - Config.Damage.BrakeModifier)

		DamageDecor(vehicle, "Vehicle_BrakeHealth", brakes * delta * Config.Damage.BrakeRate)
		SetHandling(vehicle, "fBrakeForce", brakeForce * brakeDamage)
		SetHandling(vehicle, "fHandBrakeForce", handBrakeForce * brakeDamage)
	end

	-- Fuel injector processing.
	local brakeForce = GetDefaultHandling(vehicle, "fBrakeForce")
	if isGrounded then
		local fuelChange = oldFuel - fuel
		DamageDecor(vehicle, "Vehicle_FuelInjectorHealth", fuelChange * Config.Damage.FuelInjector.Rate)
	end

	local fuelInjector = (DecorGetFloat(vehicle, "Vehicle_FuelInjectorHealth") * Config.Damage.FuelInjector.DriveModifier + (1.0 - Config.Damage.FuelInjector.DriveModifier))
	if initialDragCoeff then
		SetHandling(vehicle, "fInitialDragCoeff", initialDragCoeff + (Config.Damage.FuelInjector.AddDrag * (1.0 - fuelInjector^0.2)))
	end
	if initialDriveForce then
		SetHandling(vehicle, "fInitialDriveForce", initialDriveForce * fuelInjector)
	end
	ModifyVehicleTopSpeed(vehicle, 1.0)--maxSpeed * fuelInjector * initialDriveForce)
	-- SetVehicleMaxSpeed(vehicle, maxSpeed * (DecorGetFloat(vehicle, "Vehicle_FuelInjectorHealth") * Config.Damage.FuelInjector.DriveModifier + (1.0 - Config.Damage.FuelInjector.DriveModifier)))

	-- SetVehicleCurrentRpm(vehicle, 0.0)
	-- print(GetVehicleCurrentRpm(vehicle))
	
	-- Fuel injector processing.
	-- local brakeForce = GetDefaultHandling(vehicle, "fBrakeForce")
	-- if isGrounded then
	-- 	local fuelChange = oldFuel - fuel
	-- 	DamageDecor(vehicle, "Vehicle_FuelInjectorHealth", fuelChange * Config.Damage.FuelInjector.Rate)
	-- end

	-- if driveInertia then
	-- 	SetHandling(vehicle, "fDriveInertia", driveInertia * (DecorGetFloat(vehicle, "Vehicle_FuelInjectorHealth") * Config.Damage.FuelInjector.DriveModifier + (1.0 - Config.Damage.FuelInjector.DriveModifier)))
	-- end

	-- Electronics processing.
	local electronicsDamage = 0.0
	if angleDot > 0.001 then
		electronicsDamage = electronicsDamage + angleDot * speedRatio * Config.Damage.Electronics.RollDamage * delta
	end

	DamageDecor(vehicle, "Vehicle_ElectronicsHealth", electronicsDamage)

	local electronics = DecorGetFloat(vehicle, "Vehicle_ElectronicsHealth")
	if IsEngineOn and electronics < Config.Damage.Electronics.StallHealth and GetGameTimer() - LastStall > Config.Damage.Electronics.StallCooldown then
		math.randomseed(math.floor(GetGameTimer() / Config.Damage.Electronics.StallTime))
		if math.random() < Config.Damage.Electronics.StallChance * (1.0 - electronics / Config.Damage.Electronics.StallHealth) then
			SetVehicleEngineOn(vehicle, false)
			LastStall = GetGameTimer()
		end
	end
	
	LastProcess = GetGameTimer()
end

function ProcessEntering()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsTryingToEnter(ped)
	local isEntering = DoesEntityExist(vehicle)
	
	if isEntering and not WasEntering then
		LastDriver = GetPedInVehicleSeat(vehicle, -1)

		Hotwiring = false
		IsEngineOn = IsVehicleEngineOn(vehicle)
		
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehicleEngineOn(vehicle, IsEngineOn, false, true)
		ProcessLocks(vehicle)
	end

	if isEntering and DoesEntityExist(LastDriver) and not IsPedAPlayer(LastDriver) and GetPedInVehicleSeat(vehicle, -1) == 0 and not HasKey(vehicle) and not TakingKey then
		TakingKey = true
		Citizen.CreateThread(function()
			for i = 1, 60 do
				exports.peds:AddEvent("robbing", false)
				Citizen.Wait(100)
			end
		end)
		exports.mythic_progbar:Progress(Config.TakingKeysInIgnition.Action, function(wasCancelled)
			if not DoesEntityExist(vehicle) then
				TakingKey = false
				return
			end
			
			if wasCancelled then
				TaskLeaveVehicle(ped, vehicle, 256)
				TakingKey = false
				return
			end

			RequestKey(vehicle, "on")
		end)
	end

	WasEntering = isEntering
end

function ProcessBones(vehicle)
	if not vehicle or not DoesEntityExist(vehicle) then return end

	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	local time = GetGameTimer()

	local info = {
		coords = {},
		distances = {},
		indexes = {},
		lastUpdate = time,
		names = {},
	}

	for boneName, _ in pairs(Config.Bones) do
		local bone = GetEntityBoneIndexByName(vehicle, boneName)
		if bone ~= -1 then
			local boneCoords = GetWorldPositionOfEntityBone(vehicle, bone)

			-- Citizen.CreateThread(function()
			-- 	while Bones[vehicle] and time == Bones[vehicle].lastUpdate do
			-- 		exports.oldutils:Draw3DText(boneCoords, boneName, 4, 0.4)
			-- 		Citizen.Wait(0)
			-- 	end
			-- end)
			
			info.names[boneName] = bone

			info.indexes[bone] = true
			info.coords[bone] = boneCoords
			info.distances[bone] = #(boneCoords - pedCoords)
		end
	end

	Bones[vehicle] = info
end

function ProcessSelfDamage()
	local speedRatio = 0.0
	local healthRatio = 0.0
	local speed = GetEntitySpeed(Vehicle)
	local health = GetVehicleBodyHealth(Vehicle)

	if IsEntityInAir(Vehicle) then
		speed = speed * 2.0
	end
	
	table.insert(SpeedBuffer, speed)
	table.insert(HealthBuffer, health)

	local bufferCount = #SpeedBuffer

	for i = 2, bufferCount do
		speedRatio = speedRatio + (SpeedBuffer[i] - SpeedBuffer[i - 1])
		healthRatio = healthRatio + (HealthBuffer[i] - HealthBuffer[i - 1])
	end

	speedRatio = speedRatio / bufferCount
	if speedRatio < -1.0 and healthRatio < -1.0 then
		-- Take damage.
		exports.health:Impact(math.min((math.abs(speedRatio) / 20.0 * math.abs(healthRatio) / 100.0), 1.0))

		-- Clear speed buffer.
		SpeedBuffer = {}
		HealthBuffer = {}

	elseif bufferCount > 5 then
		table.remove(SpeedBuffer, 1)
		table.remove(HealthBuffer, 1)
	end
end

function ProcessHitching()
	if not DoesEntityExist(NearestVehicle) or not DoesEntityExist(NearestVehicle2) then return end

	local maleVehicle = NearestVehicle
	local femaleVehicle = NearestVehicle2

	local boneInfo = Bones[NearestVehicle]
	local boneInfo2 = Bones[NearestVehicle2]

	if not boneInfo or not boneInfo2 then return end

	local maleIndex = boneInfo.names["attach_male"]
	local femaleIndex = boneInfo2.names["attach_female"]
	
	if not maleIndex or not femaleIndex then
		boneInfo = Bones[NearestVehicle2]
		boneInfo2 = Bones[NearestVehicle]

		maleIndex = boneInfo.names["attach_male"]
		femaleIndex = boneInfo2.names["attach_female"]

		maleVehicle = NearestVehicle2
		femaleVehicle = NearestVehicle

		return
	end

	if not maleIndex or not femaleIndex then return end

	local maleCoords = boneInfo.coords[maleIndex] or boneInfo2.coords[maleIndex]
	local femaleCoords = boneInfo.coords[femaleIndex] or boneInfo2.coords[femaleIndex]

	exports.oldutils:Draw3DText(maleCoords, "MALE", 4, 0.4)
	exports.oldutils:Draw3DText(femaleCoords, "FEMALE", 4, 0.4)
end

function ProcessRefueling()
	local ped = PlayerPedId()
	if DoesEntityExist(Vehicle) then return end

	local retval, currentWeapon = GetCurrentPedWeapon(PlayerPedId())
	local jerryCan = retval and currentWeapon == GetHashKey("WEAPON_PETROLCAN")
	
	local vehicle = NearestVehicle
	if not jerryCan and not DoesEntityExist(vehicle) then return end

	local boneInfo = Bones[vehicle]
	if boneInfo == nil then return end

	local vehicleCoords = GetEntityCoords(vehicle)
	local pedCoords = GetEntityCoords(ped)
	if #(vehicleCoords - pedCoords) > 10.0 then return end

	local coords, boneIndex

	for k, bone in ipairs(Config.Refueling.Bones) do
		local index = boneInfo.names[bone.Name]
		if index ~= nil then
			local _coords = vehicleCoords - GetOffsetFromEntityInWorldCoords(vehicle, bone.Offset or vector3(0.0, 0.0, 0.0)) + boneInfo.coords[index]
			if (not bone.Condition or bone.Condition(vehicle, bones)) and #(_coords - pedCoords) < Config.Refueling.TankDistnace then
				coords = _coords
				boneIndex = index
				break
			end
		end
	end

	if not coords and jerryCan then
		coords = pedCoords
	end

	if coords then
		if ((jerryCan and boneIndex) or IsNearPump(coords, Config.Refueling.PumpDistance)) and DrawContext(nil, "Refuel", coords) then
			local maxFuel = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume")

			exports.mythic_progbar:Progress({
				Anim = Config.Refueling.Anim,
				Label = "Refueling...",
				Duration = 10000,
				UseWhileDead = false,
				CanCancel = true,
				Disarm = false,
			}, function(wasCancelled)
				if wasCancelled then return end
				
				if jerryCan and not boneIndex then
					exports.weapons:FillJerryCan()
				else
					if not exports.oldutils:RequestAccess(vehicle) then print("no access") return end
					SetVehicleFuelLevel(vehicle, maxFuel)
				end
			end)
		end
	end
end

function ProcessWeapons()
	if not DoesEntityExist(Vehicle) then return end
	local ped = PlayerPedId()
	local hasWeapon, weapon = GetCurrentPedVehicleWeapon(ped)
	if hasWeapon then
		DisableControlAction(0, 68, true)
		DisableControlAction(0, 69, true)
		DisableControlAction(0, 70, true)
		DisableControlAction(0, 114, true)
		DisableControlAction(0, 331, true)
	end
	local hasWeapon, weapon = GetCurrentPedWeapon(ped, 1)
	if hasWeapon and weapon == GetHashKey("WEAPON_SNIPER") then
		TriggerEvent("disarmed")
	end
end

function GetSeat()
	local ped = PlayerPedId()
	local seat = false
	
	for seat = -1, 4 do
		if GetPedInVehicleSeat(Vehicle, seat) == ped then
			return seat
		end
	end
end

function ProcessWindows()
	if not DoesEntityExist(Vehicle) then return end

	local func = nil
	if IsControlJustPressed(0, 188) then
		func = RollUpWindow
	elseif IsControlJustPressed(0, 187) then
		func = RollDownWindow
	end
	if func then
		local seat = GetSeat()
		if seat then
			func(Vehicle, seat + 1)
		end
	end
end

function ProcessLocks(vehicle)
	local driver = GetPedInVehicleSeat(vehicle, -1)
	local isPlayerDriving = DoesEntityExist(driver) and IsPedAPlayer(driver)

	if not IsEntityAMissionEntity(vehicle) and not isPlayerDriving then
		local netId = VehToNet(vehicle) or 0
		local isParked = IsVehicleSeatFree(vehicle, -1) or IsPedDeadOrDying(driver)
		local locked = false

		math.randomseed(netId)
		local chance = math.random()
		if isParked then
			if chance < Config.ParkedLockChance and not DecorGetBool(vehicle, "lockpicked") then
				locked = 7
				ProcessWindowSmash(vehicle)
			else
				locked = false
			end
		else
			locked = chance < Config.DrivingLockChance
			if DoesEntityExist(driver) and not IsPedAPlayer(driver) then
				if locked then
					exports.peds:AddEvent("carjack1", false, driver)
				else
					exports.peds:AddEvent("carjack2", false, driver)
				end
			end
		end
		if locked == true then
			locked = 2
		elseif locked == false then
			locked = 1
		end
		SetVehicleDoorsLocked(vehicle, locked)
	else
		local isLocked = GetVehicleDoorsLockedForPlayer(vehicle)
		if isLocked then
			ClearPedTasks(PlayerPedId())
			ClearPedSecondaryTask(PlayerPedId())
		end
	end
end

function ProcessRestrainedExiting()
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped, false) or not (exports.interaction:IsHandcuffed() or exports.interaction:IsZiptied()) then return end

	DisableControlAction(0,75)

	if not IsDisabledControlJustPressed(0,75) then return end

	local seat = exports.utils:GetSeatPedIsIn(Vehicle, ped)
	if not seat then return end

	if GetVehicleDoorAngleRatio(Vehicle, seat + 1) < 0.1 then
		exports.mythic_notify:SendAlert("error", "You cannot exit while restrained!", 7000)
	else
		TaskLeaveVehicle(ped, Vehicle, 256)
	end
end

function ProcessRestrainedEntering()
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped, false) or not (exports.interaction:IsHandcuffed() or exports.interaction:IsZiptied()) then return end

	local vehicle = exports.utils:GetNearestVehicle()
	if not DoesEntityExist(vehicle) then return end

	DisableControlAction(0,23)
	if not IsDisabledControlJustPressed(0,23) then return end

	door = GetNearestSeat(vehicle, 2.0) -- Can't get into front seats for some reason.
	if not door then return end
	
	local locked = GetVehicleDoorsLockedForPlayer(vehicle, PlayerId())
	if locked then return end

	if GetVehicleDoorAngleRatio(vehicle, door + 1) > 0.1 then
		TaskEnterVehicle(ped, vehicle, 10000, door, 1.0, 1, 0)
	end

end

function ProcessWindowSmash(vehicle)
	Citizen.CreateThread(function()
		local door = nil
		local ped = PlayerPedId()
		
		while door == nil and GetVehiclePedIsTryingToEnter(ped) == vehicle do
			Citizen.Wait(0)
			
			for i = 0, 1 do
				if GetPedUsingVehicleDoor(vehicle, i) == ped then
					door = i
					break
				end
			end
		end

		local window = nil
		local bone = nil

		if door == 0 then
			window = 0
			bone = 28252
		elseif door == 1 then
			window = 1
			bone = 61163
		else
			return
		end
		
		if IsVehicleWindowIntact(vehicle, window) == 1 then
			Citizen.Wait(1500)
			SetEntityHealth(ped, GetEntityHealth(ped) - Config.BreakWindowDamage)
			TriggerEvent("gameEventTriggered", "CEventNetworkEntityDamage", { ped, vehicle, 0, 0, "WEAPON_GLASS", bone })
			exports.peds:AddEvent("hotwiring")
		end
	end)
end

function ProcessHotwire(vehicle, item, slot)
	if Hotwiring then return end
	
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) then return end

	if IsVehicleDriveable(vehicle) and (item or DrawContext(nil, "Hot-wire", GetEntityCoords(ped))) then
		SetHornEnabled(vehicle, false)

		Hotwiring = true

		Config.Hotwiring.Action.Duration = Config.Hotwiring.Durations[item or 0]

		exports.peds:AddEvent("hotwiring")
		
		exports.mythic_progbar:ProgressWithTickEvent(Config.Hotwiring.Action, function()
			if not DoesEntityExist(vehicle) or GetPedInVehicleSeat(vehicle, -1) ~= PlayerPedId() then
				exports.mythic_progbar:Cancel()
			end
		end, function(wasCancelled)
			if not DoesEntityExist(vehicle) then return end

			if wasCancelled then
				Hotwiring = false
				return
			end

			Citizen.CreateThread(function()
				local coords = GetEntityCoords(vehicle)
				local delay = GetRandomIntInRange(30000, 120000)

				Citizen.Wait(delay)

				if not DoesEntityExist(vehicle) then return end
				exports.dispatch:Report("Emergency", { "10-31", "Vehicle" }, 0, coords, vehicle)
			end)

			DecorSetBool(vehicle, "hotwired", true)
			RequestKey(vehicle, "hotwire")
			SetHornEnabled(vehicle, true)
			SetEntityAsMissionEntity(vehicle)
		end)

		if slot then
			TriggerServerEvent("vehicles:hotwiring", slot)
		end
	end
end

function ProcessLockpick(vehicle)
	local duration = Config.Lockpicking.Action.Duration
	if IsEntityAMissionEntity(vehicle) then
		Config.Lockpicking.Action.Duration = 60000
		SetVehicleAlarm(vehicle, true)
	end
	exports.peds:AddEvent("hotwiring")
	exports.mythic_progbar:Progress(Config.Lockpicking.Action, function(wasCancelled)
		if wasCancelled then return end
		if not DoesEntityExist(vehicle) then return end

		local pedCoords = GetEntityCoords(PlayerPedId())
		if #(pedCoords - GetEntityCoords(vehicle)) > 10.0 then return end

		exports.oldutils:RequestAccess(vehicle)
		
		SetVehicleDoorsLockedForAllPlayers(vehicle, false)
		DecorSetBool(vehicle, "lockpicked", true)
	end)
	Config.Lockpicking.Action.Duration = duration
end

function ProcessControls(vehicle)
	local class = GetVehicleClass(vehicle)
	local isOn = GetIsVehicleEngineRunning(vehicle) == 1 or IsVehicleEngineStarting(vehicle) == 1
	local isGrounded = not IsEntityInAir(vehicle)
	local isWheelying = IsControlPressed(0, 62) and isGrounded
	local velocity = GetEntityVelocity(vehicle)
	local maxSpeed = GetVehicleMaxSpeed(vehicle)
	local speed = GetEntitySpeed(vehicle)
	local delta = GetGameTimer() - LastProcessControls

	LastProcessControls = GetGameTimer()
	
	if IsControlPressed(0, 21) or IsEngineControl then
		DisableControlAction(0, 86)
		if (IsDisabledControlPressed(0, 86) or IsEngineControl) and isGrounded and GetGameTimer() - LastToggledEngine > Config.EngineToggleCooldown then
			LastToggledEngine = GetGameTimer()
			IsEngineOn = not IsEngineOn
		end
	end
	
	if isOn ~= IsEngineOn then
		SetVehicleEngineOn(vehicle, IsEngineOn, false, true)
	end

	if not IsEngineOn then
		DisableControlAction(0, 32, true)
		DisableControlAction(0, 71, true)
		DisableControlAction(0, 77, true)
		DisableControlAction(0, 87, true)
		DisableControlAction(0, 129, true)
		DisableControlAction(0, 150, true)
		DisableControlAction(0, 232, true)
	end

	-- Flying cars.
	SetVehicleHoverTransformEnabled(vehicle, false)

	-- Wheelies.
	if class == 8 or class == 13 then
		if isWheelying then
			WheelieTime = math.min(WheelieTime + delta, 4000)
		else
			WheelieTime = math.max(WheelieTime - delta, 0)
		end

		if speed > maxSpeed and WheelieTime > 2000 then
			local ped = PlayerPedId()
			SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
			SetEntityVelocity(ped, velocity.x, velocity.y, velocity.z)
		elseif isWheelying then
			local velDamp = 1.0 - math.min(math.max(delta, 1) / 1000.0, 0.999) * 0.2
			SetEntityVelocity(vehicle, velocity.x * velDamp, velocity.y * velDamp, velocity.z * velDamp)
		end
	end

	-- Dispatch.
	if
		speed * 2.236936 > 140 and
		class ~= 18 and
		not IsVehicleSirenOn(vehicle) and
		GetResourceState("peds") == "started"
	then
		exports.peds:AddEvent("reckless")
	end
end

function RequestKey(vehicle, message)
	TriggerServerEvent("vehicles:requestKey", VehToNet(vehicle), message)
end
exports("RequestKey", RequestKey)

function GetDecorInfo(vehicle)
	local default = nil
	if not DecorGetBool(vehicle, "Vehicle_Initialized") then
		default = 1.0
	end

	local info = {
		default or DecorGetFloat(vehicle, "Vehicle_AxleHealth"),
		default or DecorGetFloat(vehicle, "Vehicle_BrakeHealth"),
		default or DecorGetFloat(vehicle, "Vehicle_ElectronicsHealth"),
		default or DecorGetFloat(vehicle, "Vehicle_FuelInjectorHealth"),
		default or DecorGetFloat(vehicle, "Vehicle_RadiatorHealth"),
		default or DecorGetFloat(vehicle, "Vehicle_TransmissionHealth"),
	}

	return info
end
exports("GetDecorInfo", GetDecorInfo)

function InitializeVehicle(vehicle, info)
	if not info and DecorGetBool(vehicle, "Vehicle_Initialized") then
		return false
	end
	
	info = info or {}

	-- info[1] = 0.0
	-- info[2] = 0.0
	-- info[3] = 0.0
	-- info[4] = 0.0
	-- info[5] = 0.0
	-- info[6] = 0.0

	DecorSetBool(vehicle, "Vehicle_Initialized", true)
	DecorSetFloat(vehicle, "Vehicle_LastBodyHealth", GetVehicleBodyHealth(vehicle) or 1000.0)
	DecorSetFloat(vehicle, "Vehicle_LastEngineHealth", GetVehicleEngineHealth(vehicle) or 1000.0)
	DecorSetFloat(vehicle, "Vehicle_LastFuelHealth", GetVehiclePetrolTankHealth(vehicle) or 1000.0)
	DecorSetFloat(vehicle, "Vehicle_AxleHealth", info[1] or 1.0)
	DecorSetFloat(vehicle, "Vehicle_BrakeHealth", info[2] or 1.0)
	DecorSetFloat(vehicle, "Vehicle_ElectronicsHealth", info[3] or 1.0)
	DecorSetFloat(vehicle, "Vehicle_FuelInjectorHealth", info[4] or 1.0)
	DecorSetFloat(vehicle, "Vehicle_RadiatorHealth", info[5] or 1.0)
	DecorSetFloat(vehicle, "Vehicle_TransmissionHealth", info[6] or 1.0)

	local model = GetEntityModel(vehicle)
	if not HandlingCache[model] then
		HandlingCache[model] = {}

		for k, v in ipairs(Config.HandlingFields) do
			local value = nil
			local prefix = v:sub(1, 1)
			if Config.HandlingFuncs[prefix] then
				HandlingCache[model][v] = Config.HandlingFuncs[prefix][1](vehicle, "CHandlingData", v)
			end
		end
	end

	return true
end
exports("InitializeVehicle", InitializeVehicle)

function ResetHandling(vehicle)
	local model = GetEntityModel(vehicle)
	if not HandlingCache[model] then
		return
	end
	
	for k, v in ipairs(HandlingCache[model]) do
		local prefix = k:sub(1, 1)
		if Config.HandlingFuncs[prefix] then
			Config.HandlingFuncs[prefix][2](vehicle, "CHandlingData", k, v)
		end
	end
end
exports("ResetHandling", ResetHandling)

function GetDefaultHandling(vehicle, field)
	local model = GetEntityModel(vehicle)
	if not HandlingCache[model] then
		return
	end
	return HandlingCache[model][field]
end
exports("GetDefaultHandling", GetDefaultHandling)

function DamageDecor(vehicle, decor, amount)
	if amount < 0.000000001 then return end
	DecorSetFloat(vehicle, decor, math.max(DecorGetFloat(vehicle, decor) - amount, 0.0))
end

function SetHandling(vehicle, key, value)
	if not LastHandlingChanged[key] then LastHandlingChanged[key] = 0 end

	if GetResourceState("vehicleDebug") == "started" then return end

	if GetGameTimer() - LastHandlingChanged[key] > 15000 then
		-- local oldValue = GetVehicleHandlingFloat(vehicle, "CHandlingData", key)
		SetVehicleHandlingFloat(vehicle, "CHandlingData", key, value)
		LastHandlingChanged[key] = GetGameTimer()
	end
end

function IsNearPump(coords, distance)
	local objects = exports.oldutils:GetObjects()
	for k, object in ipairs(objects) do
		if Config.Refueling.Models[GetEntityModel(object)] and #(coords - GetEntityCoords(object)) < distance then
			return true
		end
	end
	return false
end
exports("IsNearPump", IsNearPump)

function ToggleDoor(door)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local isInVehicle = true
	if not DoesEntityExist(vehicle) then
		isInVehicle = false
		vehicle = exports.oldutils:GetNearestVehicle()
		if not DoesEntityExist(vehicle) then return end
		if not exports.oldutils:RequestAccess(vehicle) then return end
	end
	
	door = door or GetNearestDoor(vehicle, 2.0)
	if not door then return end
	local locked = GetVehicleDoorsLockedForPlayer(vehicle, PlayerId())

	if not locked or IsPedInAnyVehicle(ped, false) then
		if not (exports.interaction:IsHandcuffed() or exports.interaction:IsZiptied()) then
			if GetVehicleDoorAngleRatio(vehicle, door) > 0.1 then
				SetVehicleDoorShut(vehicle, door, false)
			else
				SetVehicleDoorOpen(vehicle, door, false, false)
			end
		else
			exports.mythic_notify:SendAlert("error", "You cannot open a door while restrained!", 7000)
		end
	else
		exports.mythic_notify:SendAlert("error", "The vehicle is locked!", 7000)
	end
end

function GetNearestSeat(vehicle, maxDistance, shouldBeEmpty)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local model = GetEntityModel(vehicle)
	local seats = GetVehicleModelNumberOfSeats(model)
	local nearestSeat = nil
	local nearestDist = 0
	
	for i = 1, seats - 1 do
		if not shouldBeEmpty or not DoesEntityExist(GetPedInVehicleSeat(vehicle, i)) then
			local dist = #(coords - GetDoorPosition(vehicle, i))
			if dist < maxDistance and (nearestSeat == nil or dist < nearestDist) then
				nearestDist = dist
				nearestSeat = i - 1
			end
		end
	end
	return nearestSeat
end
exports("GetNearestSeat", GetNearestSeat)

function GetNearestDoor(vehicle, maxDistance)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local nearestDoor = nil
	local nearestDist = 0
	
	for k, v in pairs(Config.Doors) do
		local dist = #(coords - GetDoorPosition(vehicle, k))
		if dist < maxDistance and (nearestDoor == nil or dist < nearestDist) then
			nearestDist = dist
			nearestDoor = k
		end
	end
	return nearestDoor
end
exports("GetNearestDoor", GetNearestDoor)

function GetDoorPosition(vehicle, index, offset)
	local door = Config.Doors[index]
	if not door then return vector3(0, 0, 0) end
	local boneIndex = GetEntityBoneIndexByName(vehicle, door)
	local coords = GetWorldPositionOfEntityBone(vehicle, boneIndex)

	if offset then
		local vehicleCoords = GetEntityCoords(vehicle)
		return vehicleCoords - GetOffsetFromEntityInWorldCoords(vehicle, offset) + coords
	else
		return coords
	end
end

function IsInTrunk()
	return DoesEntityExist(InTrunk)
end
exports("IsInTrunk", IsInTrunk)

function GetInTrunk()
	if DoesEntityExist(InTrunk) then
		InTrunk = 0
		return
	end

	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped, true) then return end
	
	local vehicle = exports.oldutils:GetNearestVehicle()
	if not DoesEntityExist(vehicle) then return end

	-- Check bones.
	local bone = -1
	local boneDir = 1
	local boneCoords
	local door = 5

	local trunkBone = GetEntityBoneIndexByName(vehicle, "boot")
	local trunkCoords = GetWorldPositionOfEntityBone(vehicle, trunkBone)

	local hoodBone = GetEntityBoneIndexByName(vehicle, "bonnet")
	local hoodCoords = GetWorldPositionOfEntityBone(vehicle, hoodBone)
	
	local engineBone = GetEntityBoneIndexByName(vehicle, "engine")
	local engineCoords = GetWorldPositionOfEntityBone(vehicle, engineBone)
	
	if trunkBone ~= -1 and (engineBone == -1 or #(engineCoords - trunkCoords) > 1.0) then
		bone = trunkBone
		boneCoords = trunkCoords
		door = 5
	elseif hoodBone ~= -1 and (engineBone == -1 or #(engineCoords - hoodCoords) > 1.0) then
		bone = hoodBone
		boneCoords = hoodCoords
		door = 4
	end

	if bone == -1 then
		exports.mythic_notify:SendAlert("error", "Can't find the trunk...", 7000)
		return
	end

	-- Check distance.
	if #(GetEntityCoords(ped) - boneCoords) > 3.0 then
		exports.mythic_notify:SendAlert("error", "Can't reach the trunk...", 7000)
		return
	end

	-- Transform bone coords to local.
	boneCoords = GetOffsetFromEntityGivenWorldCoords(vehicle, boneCoords)
	
	if boneCoords.y > 0.0 then
		boneDir = -1
	else
		boneDir = 1
	end
	
	-- Check doors.
	if GetVehicleDoorAngleRatio(vehicle, door) < 0.5 then
		exports.mythic_notify:SendAlert("error", "The trunk isn't open!", 7000)
		return
	end
	
	Citizen.CreateThread(function()
		ClearPedTasksImmediately(ped)
		FreezeEntityPosition(ped, true)

		AttachEntityToEntity(
			ped, vehicle, -1,
			boneCoords.x, boneCoords.y - 0.2 * boneDir, boneCoords.z + 0.5,
			0.0, 0.0, 0.0,
			0, false, true, true, 0, true
		)
		
		InTrunk = vehicle
		
		local cam = exports.oldutils:CreateCam()
		cam:Activate()
		cam:Set("fov", 60.0)

		while DoesEntityExist(InTrunk) do
			ped = PlayerPedId()
			local coords = GetWorldPositionOfEntityBone(vehicle, bone)
			-- Getting out.
			if exports.oldutils:DrawContext("Exit", coords) then
				InTrunk = 0
				break
			end
			-- Camera.
			-- local camPos = GetEntityCoords(vehicle) - GetOffsetFromEntityInWorldCoords(vehicle, vector3(0.0, 2.0 * boneDir, -1.0)) + coords
			local camPos = GetEntityCoords(vehicle) - GetOffsetFromEntityInWorldCoords(vehicle, vector3(0.0, -1.5 * boneDir, -1.0)) + coords
			local camRot = exports.misc:ToRotation2(exports.misc:Normalize((coords + vector3(0.0, 0.0, 0.5)) - camPos))
			cam:Set("pos", camPos)
			cam:Set("rot", camRot)
			-- Emote.
			local emote = exports.emotes:GetCurrentEmote()
			if not emote or not emote.IsTrunk then
				exports.emotes:PerformEmote({
					Dict = "amb@world_human_bum_slumped@male@laying_on_right_side@base",
					Name = "base",
					Flag = 1,
					IsTrunk = true,
				})
			end
			Citizen.Wait(0)
		end

		if cam then
			cam:Deactivate()
		end

		ped = PlayerPedId()

		DetachEntity(ped, true, true)
		FreezeEntityPosition(ped, false)
		
		if DoesEntityExist(vehicle) then
			local outCoords = GetEntityCoords(vehicle) - GetOffsetFromEntityInWorldCoords(vehicle, vector3(0.0, 1.5 * boneDir, 0.0)) + GetWorldPositionOfEntityBone(vehicle, bone)
			SetEntityCoordsNoOffset(ped, outCoords)
		end
		
		exports.emotes:CancelEmote()
	end)
end
exports("GetInTrunk", GetInTrunk)

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
			exports.mythic_notify:SendAlert("error", "It won't fit!", 7000)
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

		exports.mythic_notify:SendAlert("error", "Not close enough!", 7000)
	end
end

--[[ Commands ]]--
AddEventHandler("interaction:toggleLock", function()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	if vehicle == 0 then vehicle = exports.oldutils:GetNearestVehicle() end
	if not DoesEntityExist(vehicle) or #(GetEntityCoords(vehicle) - GetEntityCoords(ped)) > 5.0 then return end

	if not HasKey(vehicle) then
		exports.mythic_notify:SendAlert("error", "You don't have keys to this vehicle!", 7000)
		return
	end

	exports.oldutils:RequestAccess(vehicle)

	if not IsPedInAnyVehicle(ped, false) then
		exports.emotes:PerformEmote(Config.Locking.Anim)
	end

	local locked = GetVehicleDoorsLockedForPlayer(vehicle, PlayerId())
	SetVehicleDoorsLockedForAllPlayers(vehicle, not locked)

	local message = ""
	if locked then
		message = "You unlocked the vehicle!"
	else
		message = "You locked the vehicle!"
		DecorSetBool(vehicle, "lockpicked", false)
	end
	exports.mythic_notify:SendAlert("inform", message, 7000)
end)

--[[ Events ]]--
RegisterNetEvent("vehicles:receiveKeys")
AddEventHandler("vehicles:receiveKeys", function(netId, failed)
	TakingKey = false
	Hotwiring = false
	
	--- Clear keys.
	if netId == nil then
		Keys = {}
		return
	elseif type(netId) == "table" then
		-- Load keys in bulk.
		for _netId, _ in pairs(netId) do
			Keys[tonumber(_netId)] = true
		end
		return
	end
	
	if failed or not netId then return end

	-- Receive individual keys.
	Keys[netId] = true
	exports.mythic_notify:SendAlert("inform", "You've received keys!", 7000)
end)

RegisterNetEvent("vehicles:receiveVehicle")
AddEventHandler("vehicles:receiveVehicle", function(netId)
	Keys[netId] = true
end)

AddEventHandler("vehicles:clientStart", function()
	DecorRegister("Vehicle_Initialized", 2)
	DecorRegister("Vehicle_LastBodyHealth", 1)
	DecorRegister("Vehicle_LastEngineHealth", 1)
	DecorRegister("Vehicle_LastFuelHealth", 1)
	DecorRegister("Vehicle_AxleHealth", 1)
	DecorRegister("Vehicle_BrakeHealth", 1)
	DecorRegister("Vehicle_ElectronicsHealth", 1)
	DecorRegister("Vehicle_FuelInjectorHealth", 1)
	DecorRegister("Vehicle_RadiatorHealth", 1)
	DecorRegister("Vehicle_TransmissionHealth", 1)

	if GetResourceState("cache") ~= "started" then return end

	Keys = exports.cache:Get("Keys") or Keys
end)

AddEventHandler("vehicles:stop", function()
	if GetResourceState("cache") ~= "started" then return end
	
	exports.cache:Set("Keys", Keys)
end)

AddEventHandler("gameEventTriggered", function(name, args)
	if name ~= "CEventNetworkEntityDamage" then return end
	
	local ped = PlayerPedId()
	local vehicle, sourceEntity, fatalDamage, weaponUsed = args[1], args[2], args[4], args[5]

	if sourceEntity == -1 or not IsEntityAVehicle(vehicle) or not NetworkGetEntityIsNetworked(vehicle) or not NetworkHasControlOfEntity(vehicle) then return end

	-- Traffic lights.
	if sourceEntity and Config.TrafficLights[GetEntityModel(sourceEntity)] and GetEntityHealth(sourceEntity) < 1000 and GetRandomFloatInRange(0.0, 1.0) < 0.2 then
		local coords = GetEntityCoords(vehicle)
		exports.dispatch:Report("Emergency", "10-49", 0, coords, vehicle, { coords = coords })
	end

	-- Damage types.
	local damageType = GetWeaponDamageType(weaponUsed)
	local isBullet = damageType == 3
	local isMelee = damageType == 2

	-- Get health stuff.
	local engineHealth, bodyHealth, fuelHealth = GetVehicleEngineHealth(vehicle), GetVehicleBodyHealth(vehicle), GetVehiclePetrolTankHealth(vehicle)
	local lastEngineHealth, lastBodyHealth, lastFuelHealth = 1000.0, 1000.0, 1000.0
	
	-- Use decors for last damage.
	if not InitializeVehicle(vehicle) then
		lastEngineHealth = DecorGetFloat(vehicle, "Vehicle_LastEngineHealth")
		lastBodyHealth = DecorGetFloat(vehicle, "Vehicle_LastBodyHealth")
		lastFuelHealth = DecorGetFloat(vehicle, "Vehicle_LastFuelHealth")
	end
	
	-- Damage.
	local bodyDamage = lastBodyHealth - bodyHealth
	local engineDamage = lastEngineHealth - engineHealth + bodyDamage * Config.Damage.BodyToEngineDamageRatio
	local fuelDamage = lastFuelHealth - fuelHealth

	-- Multipliers.
	local bodyDamageMult = Config.Damage.BodyDamageMult
	local engineDamageMult = Config.Damage.EngineDamageMult
	
	if isBullet then
		bodyDamageMult = bodyDamageMult * Config.Damage.BulletDamageMult
		engineDamageMult = engineDamageMult * Config.Damage.BulletDamageMult
	elseif isMelee then
		bodyDamageMult = bodyDamageMult * Config.Damage.MeleeDamageMult
		engineDamageMult = engineDamageMult * Config.Damage.MeleeDamageMult
	end
	
	bodyHealth = lastBodyHealth - bodyDamage * bodyDamageMult
	engineHealth = lastEngineHealth - engineDamage * engineDamageMult

	-- Hit and runs.
	if IsEntityAPed(sourceEntity) and sourceEntity ~= PlayerPedId() then
		-- Hit and runs.
		exports.peds:AddEvent("hitandrun")
	elseif bodyDamage > 10.0 then
		-- Reckless driving.
		exports.peds:AddEvent("reckless")
	end

	-- Tyre bursting/tire popping.
	if not isBullet and not isMelee then
		local minDamage, maxDamage = Config.Damage.CriticalEvent.MinDamage, Config.Damage.CriticalEvent.MaxDamage
		local minSpeed, maxSpeed = Config.Damage.CriticalEvent.MinSpeed, Config.Damage.CriticalEvent.MaxSpeed
		local damageChance = 0.0
		damageChance = damageChance + math.min(math.max((bodyDamage - minDamage) / (maxDamage - minDamage), 0.0), 1.0)
		damageChance = damageChance * math.min(math.max((LastSpeed - minSpeed) / (maxSpeed - minSpeed), 0.0), 1.0)

		if Debug then
			print("critcial probability", damageChance)
		end

		if damageChance > Config.Damage.CriticalEvent.TotaledCritChance and GetRandomFloatInRange(0.0, 1.0) > Config.Damage.CriticalEvent.TotaledChance then
			engineHealth = 0.0
		end

		for i = 0, 5 do
			if not IsVehicleTyreBurst(vehicle, i, true) and GetRandomFloatInRange(0.0, 1.0) < damageChance then
				SetVehicleTyreBurst(vehicle, i, GetRandomFloatInRange(0.0, 1.0) < Config.Damage.CriticalEvent.OnRimChance, 1000.0)
			end
		end
	end

	-- Other damages.
	DamageDecor(vehicle, "Vehicle_AxleHealth", bodyDamage / 1000.0 * Config.Damage.PartReflection)
	DamageDecor(vehicle, "Vehicle_BrakeHealth", bodyDamage / 1000.0 * Config.Damage.PartReflection)
	DamageDecor(vehicle, "Vehicle_ElectronicsHealth", engineDamage / 1000.0 * Config.Damage.PartReflection)
	DamageDecor(vehicle, "Vehicle_FuelInjectorHealth", engineDamage / 1000.0 * Config.Damage.PartReflection)
	DamageDecor(vehicle, "Vehicle_RadiatorHealth", engineDamage / 1000.0 * Config.Damage.PartReflection)
	DamageDecor(vehicle, "Vehicle_TransmissionHealth", engineDamage / 1000.0 * Config.Damage.PartReflection)
	
	-- Clamp healths.
	engineHealth = math.max(engineHealth, 0.0)
	bodyHealth = math.max(bodyHealth, 0.0)
	fuelHealth = math.max(fuelHealth, 0.0)

	-- Engine breaking.
	if engineHealth < Config.Damage.UndriveableEngineHealth then
		SetVehicleUndriveable(vehicle, true)
	end
	
	if Debug then
		print("engine", lastEngineHealth.."->"..engineHealth.." ("..engineDamage..")")
		print("body", lastBodyHealth.."->"..bodyHealth.." ("..bodyDamage..")")
		print("fuel", lastFuelHealth.."->"..fuelHealth.." ("..fuelDamage..")")
	end

	SetVehicleEngineHealth(vehicle, engineHealth)
	SetVehicleBodyHealth(vehicle, bodyHealth)
	SetVehiclePetrolTankHealth(vehicle, fuelHealth)
	
	SetVehicleCanLeakPetrol(vehicle, true)
	SetDisableVehicleEngineFires(vehicle, true)
	SetDisableVehiclePetrolTankFires(vehicle, true)

	DecorSetFloat(vehicle, "Vehicle_LastEngineHealth", engineHealth)
	DecorSetFloat(vehicle, "Vehicle_LastBodyHealth", bodyHealth)
	DecorSetFloat(vehicle, "Vehicle_LastFuelHealth", fuelHealth)
end)

--[[ Commands ]]--
RegisterCommand("seat", function(source, args, rawCommand)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local class = GetVehicleClass(vehicle)
	local models = { "f450ambo", "pbus", "riot", "riot2", "polmav", "predator", "firetruk", }
	local cache = {}

	for k, v in ipairs(models) do
		cache[GetHashKey(v)] = true
	end

	function CanShuffle()
		return cache[GetEntityModel(vehicle)]
	end
	
	if not DoesEntityExist(vehicle) then
		exports.mythic_notify:SendAlert("error", "You must be in a vehicle!", 7000)
	end
	
	local seat = tonumber(args[1])
	if not seat or not IsVehicleSeatFree(vehicle, seat) then
		exports.mythic_notify:SendAlert("error", "Invalid seat!", 7000)
	end
	if not exports.interaction:IsHandcuffed() or not exports.interactions:IsZiptied() then
		if class == 18 and (GetPedInVehicleSeat(vehicle, 1) == ped or GetPedInVehicleSeat(vehicle, 2) == ped) then 
			if CanShuffle() then
				SetPedIntoVehicle(ped, vehicle, seat)
			elseif seat <= 0 then
				exports.mythic_notify:SendAlert("error", "You can't shuffle there!", 7000)
			else
				SetPedIntoVehicle(ped, vehicle, seat)
			end
		elseif class ~= 18 or (class == 18 and seat <= 0) or CanShuffle() then
			SetPedIntoVehicle(ped, vehicle, seat)
		else
			exports.mythic_notify:SendAlert("error", "You can't shuffle there!", 7000)
		end
	end

end, false)

RegisterCommand("flip", function(source, args, rawCommand)
	if IsPedInAnyVehicle(PlayerPedId(), false) then return end

	local vehicle = exports.utils:GetNearestVehicle()
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

RegisterCommand("tow", function(source, args, command)
	exports.mythic_progbar:Progress(Config.Towing.Action, function(wasCancelled)
		if wasCancelled then return end
		Tow()
	end)
end)

RegisterCommand("door", function(source, args, rawCommand)
	ToggleDoor(tonumber(args[1]))
end, false)

RegisterCommand("hood", function(source, args, rawCommand)
	ToggleDoor(4)
end, false)

RegisterCommand("trunk", function(source, args, rawCommand)
	ToggleDoor(5)
end, false)

for k, v in ipairs({ "getintrunk", "trunkgetin", "hideintrunk", "trunkhide", "hidetrunk" }) do
	RegisterCommand(v, function(source, args, rawCommand)
		GetInTrunk()
	end, false)
end

RegisterCommand("givekey", function(source, args, command)
	if not HasKey(Vehicle) then return end
	if not DoesEntityExist(Vehicle) then return end
	local player = exports.oldutils:GetNearestPlayer(5.0)
	TriggerServerEvent("vehicles:giveKey", player, VehToNet(Vehicle))
end)

--[[ Input ]]--
IsEngineControl = false

RegisterCommand("+engine", function()
	IsEngineControl = true
end, true)

RegisterCommand("-engine", function()
	IsEngineControl = false
end, true)

RegisterKeyMapping("+engine", "Toggle Engine", "keyboard", "i")

RegisterCommand("+cruisecontrol", function()
	if CruiseControl then
		CruiseControl = nil
		exports.mythic_notify:SendAlert("inform", "Cruise control disabled!")
	elseif DoesEntityExist(Vehicle) then
		CruiseControl = GetEntitySpeed(Vehicle)
		SetVehicleMaxSpeed(Vehicle, CruiseControl)
		exports.mythic_notify:SendAlert("inform", "Cruise control set to "..math.floor(CruiseControl * 2.24).."!")
	end
end, true)

RegisterKeyMapping("+cruisecontrol", "Toggle Cruise Control", "keyboard", "k")
