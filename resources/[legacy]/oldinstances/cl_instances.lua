CurrentInstance = nil
Entering = false
EventData = {}
Objects = {}
Peds = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if CurrentInstance then
			-- print(json.encode((CurrentInstance or {}).players))
			local ped = PlayerPedId()
			local selfPlayer = PlayerId()
			
			for k, player in ipairs(GetActivePlayers()) do
				local serverId = GetPlayerServerId(player)
				if NetworkIsPlayerActive(player) then
					local isConcealed = NetworkIsPlayerConcealed(player)
					local shouldConceal = not CurrentInstance.players[tostring(serverId)]
					if isConcealed ~= shouldConceal then
						NetworkConcealPlayer(player, shouldConceal, shouldConceal)
					end
				end
			end

			for k, object in pairs(Objects) do
				local owner = NetworkGetEntityOwner(object)
				local isConcealed = NetworkIsEntityConcealed(object)
				local shouldConceal = not CurrentInstance.players[tostring(GetPlayerServerId(owner))]
				if isConcealed ~= shouldConceal then
					NetworkConcealEntity(object, shouldConceal)
				end
			end
			
			for k, ped in pairs(Peds) do
				if not IsPedAPlayer(ped) then
					local owner = NetworkGetEntityOwner(ped)
					local isConcealed = NetworkIsEntityConcealed(ped)
					local shouldConceal = not CurrentInstance.players[tostring(GetPlayerServerId(owner))]
					if isConcealed ~= shouldConceal then
						NetworkConcealEntity(ped, shouldConceal)
					end
				end
			end

			Objects = exports.oldutils:GetObjects()
			Peds = exports.oldutils:GetPeds()

			Citizen.Wait(20)
		else
			Citizen.Wait(40)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		if CurrentInstance then
			local ped = PlayerPedId()
			local playerCoords = GetEntityCoords(ped)
			local coords = CurrentInstance.inCoords
			coords = vector3(coords.x, coords.y, coords.z)
			
			if #(playerCoords - coords) < 2.0 and exports.oldutils:DrawContext("Exit", coords) then
				LeaveInstance(true)
			elseif not Entering and #(playerCoords - coords) > 100.0 then
				-- exports.teleporters:TeleportTo(CurrentInstance.inCoords)
				SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z)
				SetEntityHeading(ped, CurrentInstance.inCoords.w)
				Citizen.Wait(1000)
			end
			
			if CurrentInstance then
				SetPlayerBlipPositionThisFrame(CurrentInstance.outCoords.x, CurrentInstance.outCoords.y)
			end

			SetPedDensityMultiplierThisFrame(0.0)
			SetParkedVehicleDensityMultiplierThisFrame(0.0)
			SetRandomVehicleDensityMultiplierThisFrame(0.0)

			Citizen.Wait(0)
		else
			Citizen.Wait(1000)
		end
	end
end)

--[[ Functions ]]--
function IsInstanced()
	return CurrentInstance ~= nil
end
exports("IsInstanced", IsInstanced)

function GetPlayerInstance()
	return CurrentInstance
end
exports("GetPlayerInstance", GetPlayerInstance)

function GetInstance()
	if CurrentInstance then
		return CurrentInstance.id
	else
		return nil
	end
end
exports("GetInstance", GetInstance)

function LeaveInstance(teleportTo, isLeaving)
	if not CurrentInstance then return end
	
	if teleportTo then
		local coords = CurrentInstance.outCoords
		
		local state = (LocalPlayer or {}).state
		--exports.interaction:StopEscorting()
		exports.teleporters:TeleportTo(vector4(coords.x, coords.y, coords.z, coords.w + 180.0))
	end

	TriggerServerEvent("containers:subscribe", CurrentInstance.id, false)

	if not isLeaving then
		TriggerServerEvent("oldinstances:left")
	end

	for k, player in ipairs(GetActivePlayers()) do
		NetworkConcealPlayer(player, false, false)
	end

	for k, object in pairs(Objects) do
		NetworkConcealEntity(object, false)
	end
	
	for k, ped in pairs(Peds) do
		if not IsPedAPlayer(ped) then
			NetworkConcealEntity(ped, false)
		end
	end

	CurrentInstance = nil
end
exports("LeaveInstance", LeaveInstance)

function AddInstance(resource, coords, id, blip, data)
	local callbackId = "EnterInstance_"..id
	exports.markers:CreateUsable(resource, coords, callbackId, "Enter", 3.0, 1.5, blip, data)

	if not EventData[resource] then
		EventData[resource] = {}
	end

	table.insert(EventData[resource], AddEventHandler("markers:use_"..callbackId, function()
		TriggerServerEvent("oldinstances:join", id)
	end))
end
exports("AddInstance", AddInstance)

--[[ Events ]]--
RegisterNetEvent("oldinstances:join")
AddEventHandler("oldinstances:join", function(instance)
	-- print("entering", instance)
	-- Cache first.
	CurrentInstance = instance

	Entering = true

	-- Teleport and trigger events.
	exports.teleporters:TeleportTo(instance.inCoords)

	Entering = false

	TriggerServerEvent("containers:subscribe", instance.id, true)

	RemoveDecalsInRange(instance.inCoords.x, instance.inCoords.y, instance.inCoords.z, 100.0)
end)

RegisterNetEvent("oldinstances:left")
AddEventHandler("oldinstances:left", function()
	-- print("leaving instance")
	LeaveInstance(false, true)
end)

RegisterNetEvent("oldinstances:playerEntered")
AddEventHandler("oldinstances:playerEntered", function(player)
	-- print("player entered", CurrentInstance, player)
	if not CurrentInstance then return end
	CurrentInstance.players[tostring(player)] = true
end)

RegisterNetEvent("oldinstances:playerExited")
AddEventHandler("oldinstances:playerExited", function(player)
	-- print("player exited", CurrentInstance, player)
	if not CurrentInstance then return end
	CurrentInstance.players[tostring(player)] = nil
end)

RegisterNetEvent("character:switch")
AddEventHandler("character:switch", function()
	LeaveInstance()
end)

AddEventHandler("onResourceStop", function(resourceName)
	if EventData[resourceName] then
		for _, eventData in ipairs(EventData[resourceName]) do
			RemoveEventHandler(eventData)
		end
	end
end)