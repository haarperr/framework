TaxiJob = {}
TaxiJob.fare = {}
TaxiJob.meter = {}
TaxiJob.status = {}
TaxiJob.warnings = {}
TaxiJob.cooldowns = {}

IsInService = false

IsTaxiDriver = false
WasTaxiDriver = nil
TaxiVehicle = nil

--[[ Functions ]]--
function TaxiJob:Init()
	IsInService = exports.jobs:GetActiveJobs("taxi")

    SendNUIMessage({
        enabled = IsTaxiDriver
    })
end

function TaxiJob:Reset()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)

	if not vehicle then 
		vehicle = GetVehiclePedIsIn(ped, true)
	end

	for i = -1, 6 do
		if not IsVehicleSeatFree(vehicle, i) then
			local p = GetPedInVehicleSeat(vehicle, i)
			
			if not IsPedAPlayer(p) then
				TaskLeaveVehicle(p, vehicle, 1)
			end
		end
	end
	
	self:ClearRoutesAndBlips()
	self:NPCLeavesVehicle()

	SetEntityAsNoLongerNeeded(TaxiJob.fare.id)

    TaxiJob.fare = {}
    TaxiJob.meter.fare = 0.0

    TaxiJob.warnings.tooFarWarnings = 0
    TaxiJob.status.totalFareTime = 0
    TaxiJob.status.secondsOutOfVehicle = 0
    TaxiJob.status.secondsOverMaxSpeed = 0

    TaxiJob.status.almostThere = false
    TaxiJob.status.arrivedAtDestination = false
    TaxiJob.status.gettingClose = false
    TaxiJob.status.isEnteringTaxi = false
    TaxiJob.status.isNearby = false
    TaxiJob.status.inRoute = false
    TaxiJob.status.waitingForPickup = false
    TaxiJob.status.wantsToCancel = false
    
    TaxiJob.warnings.outOfCar = false

    TaxiJob.status.lastInteract = GetGameTimer()
    TaxiJob.warnings.lastTooFarWarning = GetGameTimer()
    TaxiJob.cooldowns.speedWarning = GetGameTimer()
end

function TaxiJob:IsPlayerDrivingTaxi()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	
	if IsInService and DoesEntityExist(vehicle) then
		local model = GetEntityModel(vehicle)
        local isTaxi = Config.Taxis[model] ~= nil
        
        if isTaxi then
            local isDriver = GetPedInVehicleSeat(vehicle, -1) == ped
            
            return isDriver, vehicle
        end
	end

    return false, nil
end

function TaxiJob:ClearRoutesAndBlips()
	if DoesBlipExist(TaxiJob.fare.blip) then
		RemoveBlip(TaxiJob.fare.blip)
	end

	if DoesBlipExist(TaxiJob.fare.destinationBlip) then
		RemoveBlip(TaxiJob.fare.destinationBlip)
	end
end

function TaxiJob:NPCLeavesVehicle()
    local vehicle = TaxiVehicle

	if not vehicle then
		if IsPedInAnyVehicle(TaxiJob.fare.id, false) then
			vehicle = GetVehiclePedIsIn(TaxiJob.fare.id, false)
		end
	end

	TaskLeaveVehicle(TaxiJob.fare.id, vehicle, 1)

	Citizen.CreateThread(function()
		Citizen.Wait(1000)
		
		SetVehicleDoorShut(vehicle, 1, true)
		SetVehicleDoorShut(vehicle, 3, true)
	end)
end

function TaxiJob:NPCCancelsRide()
	TaxiJob.status.wantsToCancel = true
    TaxiJob.status.inRoute = false

	TriggerEvent("chat:notify", "I want out of your vehicle. Now!", "inform")

	self:ClearRoutesAndBlips()
end

function TaxiJob:DropOffFare()
    if not IsInService then return end
	if not IsTaxiDriver then return end
	if not TaxiJob.fare.id and not TaxiJob.status.arrivedAtDestination then return end

	TriggerServerEvent("taxi-job:completeFare", VehToNet(TaxiVehicle), exports.jobs:GetCurrentJob().Name)
	
	self:NPCLeavesVehicle()

    if (Config.Debug) then
        print("Dropped off fare - Resetting...")
    end
	self:Reset()
end

function TaxiJob:InteractWithNPC()
    if not IsInService then return end
	if not IsTaxiDriver then return end

    if Config.Debug then
        print("NPC heading for car...")
    end
	
	TaxiJob.status.lastInteract = GetGameTimer()
	TaxiJob.status.isEnteringTaxi = true

	TaskTurnPedToFaceEntity(TaxiJob.fare.id, PlayerPedId(), 4000)

	local seat = 2
	if not IsVehicleSeatFree(TaxiVehicle, seat) then
		seat = 1
		if not IsVehicleSeatFree(TaxiVehicle, seat) then 
			seat = nil
		end
	end

	if not seat then
		TriggerEvent("chat:addMessage", "Sorry, no seat available!", "inform")
        
        if (Config.Debug) then
            print("No seat available - Resetting...")
        end
		self:Reset()
		return
	end

	TaskEnterVehicle(TaxiJob.fare.id, TaxiVehicle, 10.0, seat, 1.0, 1, 0)
	
	Citizen.CreateThread(function()

        local failsafe = 10 * 1000
        local timer = 0

		while not IsPedInAnyVehicle(TaxiJob.fare.id, false) and timer <= failsafe do
            if (timer >= failsafe) then
                if (Config.Debug) then
                    print("Fare unable to path to vehicle - Resetting...")
                end
                self:Reset()
                return
            end

            timer = timer + 500
			Citizen.Wait(500)
		end

		TaxiJob.status.isEnteringTaxi = false
		TaxiJob.status.waitingForPickup = false

		if DoesBlipExist(TaxiJob.fare.blip) then
            RemoveBlip(TaxiJob.fare.blip)
		end

		TriggerServerEvent("taxi-job:getDropoffLocation")
	end)
end

function TaxiJob:GetRandomOnFootNPC()
    local function isValidPed(ped)
        return DoesEntityExist(ped) and IsPedHuman(ped) and IsPedOnFoot(ped) and not IsPedAPlayer(ped)
    end

	local function isPedPositionValid(ped)
        local pedCoords = GetEntityCoords(ped)
        local retval, _ = GetPointOnRoadSide(pedCoords.x, pedCoords.y, pedCoords.z)

        if retval then return true end

        return false
	end

	local search = {}
	local peds = exports.oldutils:GetPeds()

	for i = 1, #peds, 1 do
        local ped = peds[i]

        if isValidPed(ped) and isPedPositionValid(ped) then
            table.insert(search, ped)
        end
	end

    if Config.Debug then
        print("GetPeds(): "..json.encode(search))
    end

	if #search > 0 then
        if Config.Debug then
            print("Found NPC from GetPed() export")
        end

		return search[GetRandomIntInRange(1, #search)]
	end

	for i = 1, 250, 1 do
		local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

        if isValidPed(ped) and isPedPositionValid(ped) then
            table.insert(search, ped)
        end
	end

    if Config.Debug then
        print("GetRandomPedAtCoord(): "..json.encode(search))
    end

	if #search > 0 then
        if Config.Debug then
            print("Found NPC from GetRandomPedAtCoord()")
        end

		return search[GetRandomIntInRange(1, #search)]
	end

    if Config.Debug then
        print("No viable NPC found...")
    end
end

function TaxiJob:MonitorFareDistance()
    if not IsTaxiDriver then return end
    if not TaxiJob.fare.id then return end
    if not TaxiJob.status.inRoute then return end

    local playerCoords = GetEntityCoords(PlayerPedId())

    TaxiJob.fare.distance = #(TaxiJob.fare.destination - playerCoords)

    if not TaxiJob.fare.lastDistance then
        TaxiJob.fare.lastDistance = TaxiJob.fare.distance
    end

    TaxiJob.status.gettingCloser = TaxiJob.fare.distance <= TaxiJob.fare.lastDistance 
    if TaxiJob.status.gettingCloser then
        TaxiJob.warnings.lastTooFarWarning = GetGameTimer() -- Give some leeway to avoid insta-warning
    end

    TaxiJob.fare.lastDistance = TaxiJob.fare.distance

    if TaxiJob.fare.distance < TaxiJob.status.gettingCloseDistance and not TaxiJob.status.gettingClose then
        TaxiJob.status.gettingClose = true
        TaxiJob.fare.checkpoint = playerCoords

        local messages = Config.Messages.GettingClose
        local message = messages[GetRandomIntInRange(1, #messages)]

		TriggerEvent("chat:notify", {
			class = "inform",
			text = _type.Message,
		})
    elseif TaxiJob.fare.distance < TaxiJob.status.almostThereDistance and not TaxiJob.status.almostThere then
        TaxiJob.status.almostThere = true
        TaxiJob.fare.checkpoint = playerCoords

        local messages = Config.Messages.AlmostThere
        local message = messages[GetRandomIntInRange(1, #messages)]

        TriggerEvent("chat:notify", {
			class = "inform",
			text = _type.Message,
		})
    elseif TaxiJob.fare.distance < 50.0 and not TaxiJob.status.arrivedAtDestination then
        TaxiJob.status.arrivedAtDestination = true
        TaxiJob.fare.checkpoint = TaxiJob.fare.destination

        local messages = Config.Messages.ArrivedAtDestination
        local message = messages[GetRandomIntInRange(1, #messages)]

        TriggerEvent("chat:notify", {
			class = "inform",
			text = _type.Message,
		})
    end
end

function TaxiJob:CheckForDeadOrDyingNPC()
    if not TaxiJob.fare.id then return end

    if not DoesEntityExist(TaxiJob.fare.id) then
        TriggerEvent("chat:notify", "Fare is nowhere to be found", "inform") 

        if (Config.Debug) then
            print("Fare doesn't exist - Resetting...")
        end
        self:Reset()
    elseif IsPedDeadOrDying(TaxiJob.fare.id) then 
        TriggerEvent("chat:notify", "Fare appears to be dead :(", "inform")

        if (Config.Debug) then
            print("Fare dead - Resetting...")
        end
        self:Reset()
    end
end

function TaxiJob:CheckForStopVehicleForCanceledFare()
    if not TaxiJob.status.wantsToCancel then return end

    if IsPedInAnyVehicle(TaxiJob.fare.id, false) then
        local vehicle = GetVehiclePedIsIn(TaxiJob.fare.id, false)

        if GetEntitySpeed(vehicle) < 0.2 then
            SetBlockingOfNonTemporaryEvents(TaxiJob.fare.id, false)

            if (Config.Debug) then
                print("Fare fleeing vehicle - Resetting...")
            end
            self:Reset()
        end
    end
end

function TaxiJob:HandleMeterUpdates()
    if IsInService and IsTaxiDriver then
        local coords = GetEntityCoords(TaxiVehicle)

        if TaxiJob.meter.lastCoords and TaxiJob.meter and not IsEntityInAir(TaxiVehicle) then
            local dist = #(TaxiJob.meter.lastCoords - coords)
            if TaxiJob.meter.distanceDriven then
                TaxiJob.meter.distanceDriven = TaxiJob.meter.distanceDriven + dist
            end

            local fare = (TaxiJob.meter.fare or 0.0) + dist / 1609.34 * (TaxiJob.meter.rate or Config.DefaultMeterRate)
            TriggerServerEvent("taxi-job:updateVehicle", VehToNet(TaxiVehicle), "fare", fare)
        end

        TaxiJob.meter.lastCoords = coords
        TriggerServerEvent("taxi-job:requestVehicle", VehToNet(TaxiVehicle))
    else
        TaxiJob.meter.lastCoords = nil
    end
    
    if not WasTaxiDriver or IsTaxiDriver ~= WasTaxiDriver then
        SendNUIMessage({
            enabled = IsTaxiDriver
        })
    end

    WasTaxiDriver = IsTaxiDriver
end

function TaxiJob:HandleNPCWaitsForPickup()
    if not IsTaxiDriver then return end

	if not TaxiJob.status.waitingForPickup then 
        TaxiJob.status.isNearby = false
        return 
    end

    local ped = PlayerPedId()
    local dist = #(TaxiJob.fare.location - GetEntityCoords(ped))

    if dist < 50.0 then
        TaxiJob.status.isNearby = true

        if TaxiJob.status.waitingForPickup and not TaxiJob.status.isEnteringTaxi then 
            TaskTurnPedToFaceEntity(TaxiJob.fare.id, ped, 4000)

            local playingEmote = IsEntityPlayingAnim(TaxiJob.fare.id, Config.WaitingAnim.Dict, Config.WaitingAnim.Name, 3)
            if not playingEmote and (dist > 15.0 or GetEntitySpeed(TaxiVehicle) > 0.5) then
                exports.emotes:Play(Config.WaitingAnim, false, TaxiJob.fare.id, false)
            end
        end
    else
        TaxiJob.status.isNearby = false
    end
end

function TaxiJob:MonitorTotalFareTime()
    if TaxiJob.status.wantsToCancel then return end
    if not TaxiJob.status.inRoute then return end

    TaxiJob.status.totalFareTime = TaxiJob.status.totalFareTime + 1
    if TaxiJob.status.totalFareTime > Config.MaxFareTimeInMinutes  * 60 then -- minutes
        TriggerEvent("chat:notify", "This is taking too long...", "inform")

        self:NPCCancelsRide()
    end
end

function TaxiJob:CheckForPlayerOutOfVehicle()
    if not TaxiJob.status.inRoute then return end

    if not IsTaxiDriver then
        TaxiJob.status.secondsOutOfVehicle = TaxiJob.status.secondsOutOfVehicle + 1

        if TaxiJob.status.secondsOutOfVehicle > (Config.SecondsOutOfVehicleBeforeCancel / 2) and not TaxiJob.warnings.outOfCar then
            TaxiJob.warnings.outOfCar = true
			TriggerEvent("chat:notify", "Get back in, let's go...", "inform")
        end

        if TaxiJob.status.secondsOutOfVehicle > Config.SecondsOutOfVehicleBeforeCancel then
            self:NPCCancelsRide()
        end
    else
        TaxiJob.status.secondsOutOfVehicle = 0
    end    
end

function TaxiJob:EnsurePlayerIsCompletingFare()
    if not TaxiJob.status.inRoute then return end
    if not TaxiJob.fare.checkpoint then return end

    if (GetGameTimer() - TaxiJob.cooldowns.justStarted) < Config.SecondsAfterStartingFareBeforeWarningsOccur * 1000 then return end
    if (GetGameTimer() - TaxiJob.warnings.lastTooFarWarning) < Config.SecondsBetweenTooFarWarnings * 1000 then return end

    local playerCoords = GetEntityCoords(PlayerPedId())
    local dist = #(TaxiJob.fare.checkpoint - playerCoords)

    local multiplier = 3
    if TaxiJob.fare.checkpoint and TaxiJob.fare.checkpoint == TaxiJob.fare.destination then
        multiplier = multiplier * 2
    end

    if dist * multiplier > TaxiJob.fare.distance and not TaxiJob.status.gettingCloser then
        TaxiJob.warnings.tooFarWarnings = TaxiJob.warnings.tooFarWarnings + 1

        if (Config.Debug) then
            print("Increasing warning level to "..TaxiJob.warnings.tooFarWarnings)
        end

        TaxiJob.warnings.lastTooFarWarning = GetGameTimer()
        if TaxiJob.warnings.tooFarWarnings > Config.MaxTooFareWarningsAllowed then
            self:NPCCancelsRide()
        else
            local messages = Config.Messages.TooFar
            local message = messages[GetRandomIntInRange(1, #messages)]
            
            TriggerEvent("chat:notify", message, "inform")
        end
    end
end

function TaxiJob:MonitorTaxiSpeed()
    if not IsTaxiDriver then return end

    local speed = GetEntitySpeed(TaxiVehicle) * 2.236936
    if speed > Config.MaxSpeedAllowedInMPH then
        TaxiJob.status.secondsOverMaxSpeed = TaxiJob.status.secondsOverMaxSpeed + 1

        if GetGameTimer() > TaxiJob.cooldowns.speedWarning + Config.SecondsBetweenSpeedWarnings * 1000 then
            TaxiJob.cooldowns.speedWarning = GetGameTimer()
            
            local messages = Config.Messages.TooFast
            local message = messages[GetRandomIntInRange(1, #messages)]

            TriggerEvent("chat:notify", message, "inform")
        end

        if TaxiJob.status.secondsOverMaxSpeed >= Config.SecondsOverMaxSpeedAllowedInMPHToCancel then
            self:NPCCancelsRide()
        end
    else
        TaxiJob.status.secondsOverMaxSpeed = 0
    end
end

function TaxiJob:Update()
    self:MonitorFareDistance()
    self:CheckForDeadOrDyingNPC()
    self:CheckForStopVehicleForCanceledFare()
    self:HandleMeterUpdates()
    self:HandleNPCWaitsForPickup()
    self:MonitorTotalFareTime()
    self:CheckForPlayerOutOfVehicle()
    self:EnsurePlayerIsCompletingFare()
    self:MonitorTaxiSpeed()
end

function TaxiJob:WaitForNPCInteraction()
    if not IsTaxiDriver then return end
    if not TaxiJob.status.waitingForPickup then return end

    local ped = PlayerPedId()
    if TaxiJob.status.isNearby and not TaxiJob.status.isEnteringTaxi and IsControlJustPressed(0, 46)  then
        if (GetGameTimer() - TaxiJob.status.lastInteract) < 3000 then return end

        local dist = #(TaxiJob.fare.location - GetEntityCoords(ped))
        
        if dist < 15.0 and GetEntitySpeed(TaxiVehicle) < 0.2 then
            SetBlockingOfNonTemporaryEvents(TaxiJob.fare.id, true)
            self:InteractWithNPC()
        end
    end
end

function TaxiJob:WaitForArrivalAtDestination()
    if not IsTaxiDriver then return end
    if not TaxiJob.status.inRoute then return end
    if not TaxiJob.status.arrivedAtDestination then return end

    if TaxiJob.status.arrivedAtDestination and TaxiJob.fare.distance < 50.0 and GetEntitySpeed(TaxiVehicle) < 0.2 then
        if IsControlJustPressed(0, 46)  then
            self:DropOffFare()
        end
    end
end

function TaxiJob:Input()
    self:WaitForNPCInteraction()
    self:WaitForArrivalAtDestination()
end
    
function TaxiJob:IsPedCurrentTaxiFare(ped)
    if not TaxiJob.fare.id then return false end

    return ped == TaxiJob.fare.id
end

--[[ Exports ]]--
exports("IsPedCurrentTaxiFare", function(...)
	TaxiJob:IsPedCurrentTaxiFare(...)
end)

--[[ Events ]]--
AddEventHandler("onClientResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        TaxiJob:Init()
    end
end)

RegisterNetEvent("jobs:clock")
AddEventHandler("jobs:clock", function(name, message)
	if message ~= true and message ~= false then return end
	IsInService = message

	if message then
        TaxiJob.meter.rate = GetResourceKvpFloat("taxi-job:rate")
	end
	
    if (Config.Debug) then
        print(("Clocking %s - Resetting..."):format(message and "on" or "off"))
    end
	TaxiJob:Reset()
end)

RegisterNetEvent("taxi-job:receiveVehicle")
AddEventHandler("taxi-job:receiveVehicle", function(meterData)
    if not meterData.rate then
        local rate = GetResourceKvpFloat("taxi-job:rate") or Config.DefaultMeterRate

        TriggerServerEvent("taxi-job:updateVehicle", VehToNet(TaxiVehicle), "rate", rate)
    end

    TaxiJob.meter.fare = meterData.fare or 0.0
    TaxiJob.meter.rate = meterData.rate or Config.DefaultMeterRate

	SendNUIMessage({
		fare = TaxiJob.meter.fare,
		rate = TaxiJob.meter.rate,
	})
end)

RegisterNetEvent("taxi-job:updateSavedRate")
AddEventHandler("taxi-job:updateSavedRate", function(rate)
    if Config.Debug then
        print("Setting rate to: "..rate)
    end

	SetResourceKvpFloat('taxi-job:rate', rate)
end)

RegisterNetEvent("taxi-job:sendDropoffLocation")
AddEventHandler("taxi-job:sendDropoffLocation", function(property)
    if Config.Debug then
        print("Got dropoff location: "..json.encode(property))
    end

	local blip = AddBlipForCoord(taxi.inCoords.x, taxi.inCoords.y, taxi.inCoords.z)
	TaxiJob.fare.destination = vector3(property.x, property.y, property.z)

	TaxiJob.fare.distance = #(TaxiJob.fare.destination - GetEntityCoords(PlayerPedId()))
	TaxiJob.status.gettingCloseDistance = TaxiJob.fare.distance / 4
	TaxiJob.status.almostThereDistance = TaxiJob.fare.distance / 10

	TaxiJob.meter.distanceDriven = 0
	TaxiJob.status.inRoute = true

	TaxiJob.fare.checkpoint = TaxiJob.fare.location
	TaxiJob.cooldowns.justStarted = GetGameTimer()

	TaxiJob.meter.fare = 0.0

	TaxiJob.fare.destinationBlip = AddBlipForCoord(TaxiJob.fare.destination)
	SetBlipSprite(TaxiJob.fare.destinationBlip, 12)
	SetBlipScale(TaxiJob.fare.destinationBlip, 0.65)
	SetBlipColour(TaxiJob.fare.destinationBlip, 28)
	SetBlipRoute(TaxiJob.fare.destinationBlip, true)
	SetBlipRouteColour(TaxiJob.fare.destinationBlip, 28)

	local street = exports.oldutils:GetStreetText(vector3(property.x, property.y, property.z), true)
	local propertyType = property.type:gsub("_", " ")
	TriggerEvent("chat:notify", "Hey, drop me off at the %s near %s", "inform"):format(propertyType, street)
end)

--[[ Commands ]]--
RegisterCommand("meterrate", function(source, args, command)
    if not IsInService then return end
	if not IsTaxiDriver then return end

	local rate = tonumber(args[1])
	if not rate then return end

	TaxiJob.meter.rate = rate
    
	TriggerServerEvent("taxi-job:updateVehicle", VehToNet(TaxiVehicle), "rate", rate)
end)

RegisterCommand("meterreset", function(source, args, command)
    if not IsInService then return end
	if not IsTaxiDriver then return end

	TaxiJob.meter.fare = 0.0
	TaxiJob.meter.lastCoords = nil

	TriggerServerEvent("taxi-job:updateVehicle", VehToNet(TaxiVehicle), "fare", 0.0)
end)

RegisterCommand("gettaxinpc", function(source, args, command)
    if not IsInService then return end
	if not IsTaxiDriver then return end

    if (Config.Debug) then
        print("Searching for new NPC - Resetting...")
    end
    TaxiJob:Reset()

    TaxiJob.fare.id = TaxiJob:GetRandomOnFootNPC()
	if not TaxiJob.fare.id then return end

    if Config.Debug then
        print("NPC id = "..TaxiJob.fare.id)
    end

	SetEntityAsMissionEntity(TaxiJob.fare.id)

	SetBlockingOfNonTemporaryEvents(TaxiJob.fare.id, true)

	TaxiJob.fare.location = GetEntityCoords(TaxiJob.fare.id)
    local _, nodeCoords, _ = GetClosestVehicleNodeWithHeading(TaxiJob.fare.location.x, TaxiJob.fare.location.y, TaxiJob.fare.location.z, 1, 3.0, 0)
    local _, coordsSide = GetPointOnRoadSide(nodeCoords.x, nodeCoords.y, nodeCoords.z)
    
	TaxiJob.fare.blip = AddBlipForCoord(coordsSide.x, coordsSide.y, coordsSide.z)
	SetBlipSprite(TaxiJob.fare.blip, 12)
	SetBlipScale(TaxiJob.fare.blip, 0.65)
	SetBlipColour(TaxiJob.fare.blip, 28)
	SetBlipRoute(TaxiJob.fare.blip, true)
	SetBlipRouteColour(TaxiJob.fare.blip, 28)

	ClearPedTasksImmediately(TaxiJob.fare.id)
	TaskGoToCoordAnyMeans(TaxiJob.fare.id, coordsSide.x, coordsSide.y, coordsSide.z, 1.0, 0, 0, 786603, 0xbf800000)
	
    Citizen.CreateThread(function()
		if GetIsTaskActive(TaxiJob.fare.id, 224) then
			local failsafe = 10 * 1000
			local timer = 0

			while GetIsTaskActive(TaxiJob.fare.id, 224) and timer <= failsafe do               
				if (timer >= failsafe) then
					break
				end

				timer = timer + 100
				Citizen.Wait(100)
			end
		end

		ClearPedTasks(TaxiJob.fare.id)

		local scenarios = Config.WaitingScenarios
		local scenario = scenarios[GetRandomIntInRange(1, #scenarios)]
		exports.emotes:Play({ Scenario = scenario, PlayEnterAnim = true }, false, TaxiJob.fare.id)
		
        if Config.Debug then
            print("NPC waiting at coords: "..TaxiJob.fare.location)
        end

        TaxiJob.status.waitingForPickup = true
		TaxiJob.fare.location = GetEntityCoords(TaxiJob.fare.id)
		SetBlipCoords(TaxiJob.fare.blip, TaxiJob.fare.location.x, TaxiJob.fare.location.y, TaxiJob.fare.location.z)
	end)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        IsTaxiDriver, TaxiVehicle = TaxiJob:IsPlayerDrivingTaxi()

        if IsInService then 
            TaxiJob:Update()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsInService and IsTaxiDriver and TaxiJob.fare.id then 
            TaxiJob:Input()
        end
    end
end)