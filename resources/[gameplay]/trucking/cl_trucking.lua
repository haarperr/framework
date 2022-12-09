TruckingJob = {}

IsInService = false

IsTruckDriver = false
TruckVehicle = nil

TrailerVehicle = nil
IsTrailerAttached = false

ShowMarker = false
ShowContext = false 
ContextAction = nil

MarkerCoords = nil
Marker = { scaleX = 1.0, scaleY = 1.0, scaleZ = 1.0, r = 255, g = 255, b = 255, a = 255, bob = false, face = true, rotate = false, drawOnEntsOnly = false }


--[[ Functions ]]--
function AddNpc(info)
	Citizen.CreateThread(function()
		exports.oldnpcs:Add(info)
	end)
end

function TruckingJob:Init()
    self:Reset()

    AddTextEntry("TruckingJob_Trailer", "Trucking Job: Trailer")
    AddTextEntry("TruckingJob_Destination", "Trucking Job: Destination")

    IsInService = exports.jobs:GetCurrentJob("truckdriver")
end

function TruckingJob:Reset()   
    if TruckingJob.trailer then 
        exports.oldutils:Delete(TruckingJob.trailer)
    end
    
    if DoesBlipExist(TruckingJob.destinationBlip) then 
        RemoveBlip(TruckingJob.destinationBlip)
    end

    if DoesBlipExist(TruckingJob.trailerBlip) then 
        RemoveBlip(TruckingJob.trailerBlip)
    end

    TruckingJob.trailer = nil
    TruckingJob.destination = nil

    TruckingJob.destinationBlip = nil
    TruckingJob.trailerBlip = nil

    TruckingJob.destinationMarker = nil

    TruckingJob.jobName = nil
    TruckingJob.job = nil 
    TruckingJob.jobList = {}

    TruckingJob.stageNum = nil
    TruckingJob.stageIteration = 1
    TruckingJob.stageDestinations = {}

    TruckingJob.maleBone = nil 
    TruckingJob.femaleBone = nil 

    TruckingJob.totalTravelDistance = 0
    TruckingJob.currentDestinationDistance = 0

    IsTruckDriver = false
    TruckVehicle = nil

    TrailerVehicle = nil
    IsTrailerAttached = false

    ShowMarker = false
    ShowContext = false 
    ContextAction = nil

    MarkerCoords = nil 

    for _, job in pairs(Config.Deliveries) do 
        TruckingJob.jobList[job.Name] = job
    end
end

function TruckingJob:GetDestinationsForRepeatedStage(index, stage) 
    if not stage.Repeat then return end
    
    if #TruckingJob.job.SharedDestinations < stage.Repeat then 
        stage.Repeat = #TruckingJob.job.SharedDestinations
    end

    TruckingJob.stageDestinations[index] = {}
    local stageDestination = TruckingJob.stageDestinations[index]

    local shuffledDestinations = FYListShuffle(TruckingJob.job.SharedDestinations)

    -- non-repeating destinations
    for i = 1, stage.Repeat do 
        local destination = nil 

        for j = 1, 10 do 
            math.randomseed(GetGameTimer() + i + j + math.pi) -- I hate "pseudorandom"
            destination = shuffledDestinations[math.random(#shuffledDestinations)]

            local found = false
            for k, v in ipairs(stageDestination) do 
                if v == destination then  
                    found = true
                    break
                end
            end

            if not found then 
                if Config.Debug then  
                    print(("Adding destination for repeated stage #%s at: %s"):format(index, destination))
                end

                stageDestination[i] = destination
                break
            end
        end
    end

    if Config.Debug then 
        print(("Stage %s Destinations: %s"):format(index, json.encode(stageDestination)))
    end
end

function TruckingJob:SelectJob(jobName)
    if TruckingJob.jobList[jobName] == nil then return end

    TruckingJob.jobName = jobName
    TruckingJob.job = TruckingJob.jobList[jobName]

    if not TruckingJob.job.Stages or not TruckingJob.job.Stages[1] or not TruckingJob.job.Stages[1].TrailerModel then 
        if (Config.Debug) then
            print(("Invalid job: %s"):format(json.encode(TruckingJob.job)))
        end

        return
    end

    for index, stage in ipairs(TruckingJob.job.Stages) do
        if stage.Repeat then 
            self:GetDestinationsForRepeatedStage(index, stage)
        end
    end

    TriggerServerEvent("trucking-job:logJobStart", jobName)

    local message = ("Job Assigned: %s - %s"):format(TruckingJob.job.Name, TruckingJob.job.Description)
	exports.mythic_notify:SendAlert("inform", message, 7000)

    if Config.Debug then print(message) end

    TruckingJob.stageNum = 1
    self:NextStage()
end

function TruckingJob:IsJobValid(jobName)
    return (TruckingJob.jobList[jobName] ~= nil)
end

function TruckingJob:HasJob() 
    return (TruckingJob.job ~= nil), TruckingJob.job
end

function TruckingJob:IsPlayerDrivingTruck()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)

    if not DoesEntityExist(vehicle) then 
        vehicle = GetVehiclePedIsIn(ped, true)
    end

	if IsInService and DoesEntityExist(vehicle) then
        local isValidTruck = Config.Trucks[GetEntityModel(vehicle)] ~= nil
        
        if isValidTruck then            
            return GetPedInVehicleSeat(vehicle, -1) == ped, vehicle
        else 
            return false, vehicle
        end
	end

    if not DoesEntityExist(vehicle) then vehicle = nil end

    return false, vehicle
end

function TruckingJob:IsTruckTrailerAttached()
    local trailer = TruckingJob.trailer

    if IsInService and DoesEntityExist(trailer) then
        local retval, attachedTrailer = GetVehicleTrailerVehicle(TruckVehicle)

        if attachedTrailer == trailer then 
            return retval, attachedTrailer
        else
            return false, trailer
        end
    end

    return false, nil
end

function TruckingJob:HandleBlipsAndRoutes()
    if not DoesEntityExist(TruckingJob.trailer) then return end

    if IsTrailerAttached then 
        if TruckingJob.trailerBlip then  
            RemoveBlip(TruckingJob.trailerBlip)
            TruckingJob.trailerBlip = nil
        end

        if TruckingJob.destination and not TruckingJob.destinationBlip then 
            TruckingJob.destinationBlip = AddBlipForCoord(TruckingJob.destination)
            SetBlipSprite(TruckingJob.destinationBlip, 515)
            SetBlipScale(TruckingJob.destinationBlip, 0.5)
            SetBlipColour(TruckingJob.destinationBlip, 64)
            SetBlipRoute(TruckingJob.destinationBlip, true)
            SetBlipRouteColour(TruckingJob.destinationBlip, 64)
            BeginTextCommandSetBlipName("TruckingJob_Destination")
            EndTextCommandSetBlipName(TruckingJob.destinationBlip)
        end
    else
        if not TruckingJob.trailerBlip then
            local trailerCoords = GetEntityCoords(TruckingJob.trailer)
    
            TruckingJob.trailerBlip = AddBlipForCoord(trailerCoords)
            SetBlipSprite(TruckingJob.trailerBlip, 479)
            SetBlipScale(TruckingJob.trailerBlip, 0.5)
            SetBlipColour(TruckingJob.trailerBlip, 64)
            SetBlipRoute(TruckingJob.trailerBlip, true)
            SetBlipRouteColour(TruckingJob.trailerBlip, 64)
            BeginTextCommandSetBlipName("TruckingJob_Trailer")
            EndTextCommandSetBlipName(TruckingJob.trailerBlip)
        end

        if TruckingJob.destinationBlip then 
            RemoveBlip(TruckingJob.destinationBlip)
            TruckingJob.destinationBlip = nil
        end
    end
end

function TruckingJob:HandleDistanceChecking()
    if not TruckVehicle or not TruckingJob.job or not TruckingJob.destination or not MarkerCoords or not IsTrailerAttached then
        ShowMarker = false 
        ShowContext = false
        return
    end

    local trailerCoords = GetEntityCoords(TrailerVehicle)

    local dist = #(trailerCoords - MarkerCoords)
    if dist < 50.0 then 
        ShowMarker = true
    else 
        ShowMarker = false
    end

    local ped = PlayerPedId()
    local pedDist  = #(GetEntityCoords(ped) - MarkerCoords)
    local inVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
    if dist < 7.5 and pedDist < 7.5 and not inVehicle then 
        ShowContext = true

        local stage = TruckingJob.stage
    
        local action = nil
        if stage.Type == "Load" then 
            action = Config.LoadAction
            action.Label = "Loading trailer..."
        elseif stage.Type == "Unload" then 
            action = Config.UnloadAction
            action.Label = "Unloading trailer..."
        elseif stage.Type == "DropOff" then 
            action = Config.UnloadAction
            action.Label = "Dropping off trailer..."
        end

        ContextAction = action
    else 
        ShowContext = false
    end
end

function TruckingJob:Update()
    self:HandleBlipsAndRoutes()
    self:HandleDistanceChecking()
end

function TruckingJob:ShowMarkerAndContext() 
    if not ShowMarker and not ShowContext then return end
    if not TruckVehicle or not TruckingJob.job or not TruckingJob.destination or not MarkerCoords or not IsTrailerAttached then return end

    if ShowMarker then 
        DrawMarker(39, MarkerCoords.x, MarkerCoords.y, MarkerCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Marker.scaleX, Marker.scaleY, Marker.scaleZ, Marker.r, Marker.g, Marker.b, Marker.a, Marker.bob, Marker.face, 2, Marker.rotate, nil, nil, Marker.drawOnEntsOnly)
    end

    if ShowContext then 
        local trailerCoords = GetEntityCoords(TrailerVehicle)
        local stage = TruckingJob.stage
        
        if exports.oldutils:DrawContext(("%s Trailer"):format(stage.Type), trailerCoords) then     
            exports.mythic_progbar:Progress(ContextAction, function(wasCancelled)
                if wasCancelled then return end
    
                if TruckingJob.stageNum >= #TruckingJob.job.Stages then
                    self:CompleteJob()
                    return
                end
    
                if stage.Repeat and TruckingJob.stageIteration < stage.Repeat then 
                    TruckingJob.stageIteration = TruckingJob.stageIteration + 1
                    
                    if Config.Debug then 
                        print(("Progressing to stage %s - interation %s..."):format(TruckingJob.stageNum, TruckingJob.stageIteration))
                    end
    
                    self:GetStageDestination()
                    return
                end
    
                TruckingJob.stageNum = TruckingJob.stageNum + 1
                self:NextStage()
            end)
        end
    end
end

function TruckingJob:Input()
    self:ShowMarkerAndContext()
end

function TruckingJob:SpawnStageTrailer(model)
    local stage = TruckingJob.stage

    local trailerCoords = nil
    local locationName = nil 

    if TruckingJob.trailer then 
        trailerCoords = GetEntityCoords(TruckingJob.trailer)
        trailerCoords = vector4(trailerCoords.x, trailerCoords.y, trailerCoords.z, GetEntityHeading(TruckingJob.trailer))

        exports.oldutils:Delete(TruckingJob.trailer)
    end

    if stage.TrailerCoords then 
        if #stage.TrailerCoords < 1 then  
            local bays = FYListShuffle(Config.TrailerBays)

            for _, bay in pairs(bays) do
                if not IsPositionOccupied(bay.Coords[1], bay.Coords[2], bay.Coords[3], 0.2, false, true, true, false, false, 0, false) then
                    trailerCoords = bay.Coords
                    locationName = bay.Name
                    break
                end
            end
        else     
            local locations = FYListShuffle(stage.TrailerCoords)

            for _, location in pairs(locations) do
                if not IsPositionOccupied(location[1], location[2], location[3], 0.2, false, true, true, false, false, 0, false) then
                    trailerCoords = location
                    break
                end
            end

            locationName = exports.oldutils:GetStreetText(vector3(trailerCoords[1], trailerCoords[2], trailerCoords[3]), true)
        end
    end

    if not trailerCoords then 
        print("Unable to spawn trailer")
        self.Reset()
        return 
    end
    
    local trailer = exports.oldutils:CreateVehicle(model, trailerCoords[1], trailerCoords[2], trailerCoords[3], trailerCoords[4], true, true)

    if DoesEntityExist(trailer) then
        SetEntityAsMissionEntity(trailer)

        if stage.ForceAttached then 
            AttachVehicleToTrailer(TruckVehicle, trailer, 1.0)
        end
    
        TruckingJob.trailer = trailer

        local dist = #(GetEntityCoords(PlayerPedId()) - vector3(trailerCoords[1], trailerCoords[2], trailerCoords[3]))
        TruckingJob.currentDestinationDistance = dist
        TruckingJob.totalTravelDistance = math.floor((TruckingJob.totalTravelDistance or 0) + dist)

        if stage.Message then 
            local message = stage.Message:gsub("STREETNAME", locationName)
            exports.mythic_notify:SendAlert("inform", message, 7000)
    
            if Config.Debug then print(message) end
        end
    end
end

function TruckingJob:GetStageDestination() 
    if not TruckingJob.job or not TruckingJob.trailer or not IsTrailerAttached then return end

    self:HandleProgressPayment()

    local stage = TruckingJob.stage

    if not stage.Destination and not stage.ReturnTrailer and not (stage.Repeat and TruckingJob.stageIteration < stage.Repeat) then 
        TruckingJob.stageNum = TruckingJob.stageNum + 1
        self:NextStage()

        return 
    end

    local destination = nil 

    if stage.Destination and #stage.Destination > 0 then 
        math.randomseed(GetGameTimer())
        destination = stage.Destination[math.random(1, #stage.Destination)] 
    end 

    if stage.Repeat and TruckingJob.stageIteration <= stage.Repeat then 
        local pedCoords = GetEntityCoords(PlayerPedId())
        local shortestIndex = nil 
        local shortestDist = nil

        for k, v in pairs(TruckingJob.stageDestinations[TruckingJob.stageNum]) do
            local v3Destination = vector3(v.x, v.y, v.z)
            local dist = #(pedCoords - v3Destination)

            if shortestDist == nil or dist < shortestDist then 
                shortestIndex = k
                shortestDist = dist  
            end
        end

        destination = TruckingJob.stageDestinations[TruckingJob.stageNum][shortestIndex]
        TruckingJob.stageDestinations[TruckingJob.stageNum][shortestIndex] = nil -- remove
    end

    if stage.ReturnTrailer then 
        if #stage.ReturnTrailer < 1 then 
            destination = Config.TrailerDropOff
        else 
            math.randomseed(GetGameTimer())
            destination = stage.ReturnTrailer[math.random(1, #stage.ReturnTrailer)]
        end
    end

    if not destination then 
        print("Unable to find destination...")
        self:Reset()
        return
    end

    TruckingJob.destination = destination

    if DoesBlipExist(TruckingJob.destinationBlip) then 
        RemoveBlip(TruckingJob.destinationBlip)
        TruckingJob.destinationBlip = nil
    end

    if Config.Debug then 
        print(("Found destination at coords: %s"):format(TruckingJob.destination))
    end

    local v3Destination = vector3(destination.x, destination.y, destination.z)

    local dist = #(GetEntityCoords(PlayerPedId()) - v3Destination)
    TruckingJob.currentDestinationDistance = dist
    TruckingJob.totalTravelDistance = math.floor((TruckingJob.totalTravelDistance or 0) + dist)

    if Config.Debug then 
        print("Current destination distance: "..TruckingJob.currentDestinationDistance)
        print("Total travel distance increased to: "..TruckingJob.totalTravelDistance)
    end

    local streetName = exports.oldutils:GetStreetText(v3Destination, true)
    if stage.Message then 
        local message = stage.Message:gsub("STREETNAME", streetName)
        exports.mythic_notify:SendAlert("inform", message, 7000)

        if Config.Debug then print(message) end
    end

    MarkerCoords = v3Destination
end

function TruckingJob:HandleProgressPayment()
    if not TruckingJob.job or not TruckingJob.currentDestinationDistance then return end 
    if TruckingJob.currentDestinationDistance < 100 then return end 

    TriggerServerEvent("trucking-job:doProgressPayment", TruckingJob.currentDestinationDistance, TruckingJob.jobName)
    TruckingJob.currentDestinationDistance = 0
end

function TruckingJob:CompleteJob() 
    DetachVehicleFromTrailer(TruckVehicle)

    if Config.Debug then 
        print("Total travel distance: "..TruckingJob.totalTravelDistance)
    end
    
    self:HandleProgressPayment()

    Citizen.Wait(1000)
    self:Reset()
end
    
function TruckingJob:NextStage()
    if not TruckingJob.stageNum then return end

    if Config.Debug then 
        print("Progressing to stage: "..TruckingJob.stageNum)
    end

    local stage = TruckingJob.job.Stages[TruckingJob.stageNum]
    TruckingJob.stage = stage

    if stage.TrailerModel then 
        local model = stage.TrailerModel 
        
        if model ~= GetEntityModel(TruckingJob.trailer) then         
            self:SpawnStageTrailer(model)
        end
    end

    Citizen.CreateThread(function() 
        while not TruckingJob.trailer or not IsTrailerAttached do 
            if not TruckingJob.job then break end

            Citizen.Wait(1000)
        end
        
        self:GetStageDestination()
    end)
end

-- Fisher-Yates shuffle by hjpotter92 - https://stackoverflow.com/a/35574006
function FYListShuffle(original)
    math.randomseed(GetGameTimer())

    local shuffled = {}
    for i = #original, 1, -1 do
        local j = math.random(i)
        original[i], original[j] = original[j], original[i]
        table.insert(shuffled, original[i])
    end

    return shuffled
end

--[[ Events ]]--
AddEventHandler("trucking:start", function()
    TruckingJob:Init()
end)

RegisterNetEvent("jobs:clock")
AddEventHandler("jobs:clock", function(name, message)
	if message ~= true and message ~= false then return end
	IsInService = message
	
    if (Config.Debug) then
        print(("Clocking %s - Resetting..."):format(message and "on" or "off"))
    end

	TruckingJob:Reset()
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        IsTruckDriver, TruckVehicle = TruckingJob:IsPlayerDrivingTruck()
        IsTrailerAttached, TrailerVehicle = TruckingJob:IsTruckTrailerAttached()

        if IsInService then 
            TruckingJob:Update()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsInService then 
            TruckingJob:Input()
        end
    end
end)

--[[ Commands ]]--
--[[RegisterCommand("tj", function(source, args, command)
    if not IsInService then return end

    TruckingJob:Reset()
    TruckingJob:SelectJob("Fuel Delivery")
end)

RegisterCommand("tcancel", function(source, args, command)
    TruckingJob:Reset()
end)

RegisterCommand("tduty", function(source, args, command)
    TriggerServerEvent("jobs:tryClock", "truck driver", true)
end)

RegisterCommand("tstage", function(source, args, command)
    if not TruckingJob.job then return end 
    if TruckingJob.stageNum == 1 then return end

    local stage = nil 
    if #args > 0 then 
        stage = tonumber(args[1])
    end

    if stage then 
        if stage > #TruckingJob.job.Stages then 
            stage = #TruckingJob.job.Stages
        end

        TruckingJob.stageNum = stage
    else  
        TruckingJob.stageNum = TruckingJob.stageNum + 1
    end
    
    TruckingJob:NextStage()
end)]]