ControlZone = nil
LastReputation = 0
LastRequest = nil
LastInteract = 0

--[[ Threads ]]--
Citizen.CreateThread(function()
	-- Create the territory grid.
	local grid = 100.0
	local w1, h1 = 8000.0, 12000.0
	local w2, h2 = math.ceil(w1 / grid), math.ceil(h1 / grid)
	local size = w2 * h2

	for i = 0, size - 1 do
		local x, y, z = math.floor(i % w2) * grid - 3500.0, math.floor(i / w2) * grid - 4000.0, 0.0
		local territory = GetTerritoryAtCoord(x, y, z)
		if territory and territory.Type ~= "Community" then
			local blip = AddBlipForArea(x, y, z, grid, grid)
			SetBlipAlpha(blip, 48)
			SetBlipAsShortRange(blip, true)
			SetBlipColour(blip, territory.Color or 0)
			SetBlipDisplay(blip, 3)
			SetBlipHighDetail(blip, true)
			SetBlipPriority(blip, 0)
			SetBlipRotation(blip, 0)
			SetBlipShrink(blip, true)
		end

		if i % 128 == 0 then
			Citizen.Wait(0)
		end
	end

	for zone, settings in pairs(Config.Zones) do
		if settings.Name then
			AddTextEntry(zone, settings.Name)
		end
	end

	-- Print name of zone.
	-- while true do
	-- 	print(GetNameOfZone(GetFinalRenderedCamCoord()))
	-- 	Citizen.Wait(100)
	-- end
end)

Citizen.CreateThread(function()
	while true do
		if IsPedShooting(PlayerPedId()) then
			didShoot = true
		end
		
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if ped and DoesEntityExist(ped) then
			local coords = GetEntityCoords(ped)
			local settings, zone = GetTerritoryAtCoord(coords.x, coords.y, coords.z)
			local hasWeapon, weapon = GetCurrentPedWeapon(ped)
			local weaponGroup

			if hasWeapon then
				weaponGroup = GetWeapontypeGroup(weapon)
			end

			local data = {
				aiming = IsAimCamActive() == 1,
				shooting = didShoot,
				weaponGroup = weaponGroup,
			}

			-- print(zone, json.encode(data))

			didShoot = false

			TriggerServerEvent("territories:update", zone, data)
		end
		
		Citizen.Wait(1000)
	end
end)

--[[ Functions ]]--
function AddNpc(info)
	Citizen.CreateThread(function()
		exports.npcs:Add(info)
	end)
end

function GetTerritoryAtCoord(x, y, z)
	local nearest = nil
	local nearestDist = 0.0

	for k, v in pairs(Config.Zones) do
		if v.Coords then
			local dist = #(v.Coords - vector3(x, y, z))
			if (not nearest or dist < nearestDist) and dist < v.Radius then
				nearestDist = dist
				nearest = k
			end
		end
	end

	if nearest then
		return Config.Zones[nearest], nearest
	end

	local zone = GetNameOfZone(x, y, z or 0.0)
	if not zone then return end

	local settings = Config.Zones[zone]
	if not settings or settings.Coords then return end

	if settings.Fallback then
		return Config.Zones[settings.Fallback], settings.Fallback
	else
		return settings, zone
	end
end
exports("GetTerritoryAtCoord", GetTerritoryAtCoord)

function GetCurrentTerritory()
	local coords = GetEntityCoords(PlayerPedId())

	return GetTerritoryAtCoord(coords.x, coords.y, coords.z)
end
exports("GetCurrentTerritory", GetCurrentTerritory)

function RequestStatus(callback, ...)
	if LastRequest then RemoveEventHandler(LastRequest) end
	
	LastRequest = AddEventHandler("territories:receiveStatus", function(data)
		if LastRequest then RemoveEventHandler(LastRequest) end

		callback(data)
	end)

	TriggerServerEvent("territories:requestStatus", ...)
end

function GetReputationExtra(value)
	if value > -0.001 and value < Config.Reputation.ControlAt then
		return "•", "rgb(200, 200, 200)"
	end

	local symbol, max, color
	if value > 0.0 then
		symbol = "▲"
		value = value - Config.Reputation.ControlAt
		max = 100.0 - Config.Reputation.ControlAt
		color = "rgb(0, 255, 0)"
	else
		symbol = "▼"
		max = -100.0
		color = "rgb(255, 0, 0)"
	end

	local count = math.ceil(value / max * 4)
	local text = ""
	for i = 1, count do
		text = text..symbol
	end

	return text, color
end

-- function AddReputation(zoneId, amount)
-- 	if (GetGameTimer() - LastReputation) / 1000.0 <= Config.Reputation.Cooldown then return end

-- 	TriggerServerEvent("territories:reputationAdd", zoneId, math.min(math.max(amount, -1.0), 1.0))
	
-- 	LastReputation = GetGameTimer()
-- end
-- exports("AddReputation", AddReputation)

--[[ Events ]]--
RegisterNetEvent("territories:receiveStatus")

AddEventHandler("territories:clientStart", function()
	for _, location in ipairs(Config.Labs.Locations) do
		local typeSettings = Config.Labs.Types[location.Type]
		exports.instances:AddInstance(GetCurrentResourceName(), location.Coords, location.Instance, false, {
			condition = function()
				return ControlZone == location.Zone
				-- return true
			end
		})
	end

	-- for _, settings in ipairs(Config.Instances) do
	-- 	exports.instances:AddInstance(GetCurrentResourceName(), settings.outCoords, settings.id)
	-- end
end)

RegisterNetEvent("territories:update")
AddEventHandler("territories:update", function(controlZone)
	ControlZone = controlZone
	-- print("control", ControlZone)
end)

AddEventHandler("peds:interact", function(ped)
	local playerPed = PlayerPedId()
	local territory, zone = GetCurrentTerritory()

	if
		(GetGameTimer() - LastInteract) < 5000 or
		not territory or
		IsPedAPlayer(ped) or
		IsEntityAMissionEntity(ped) or
		IsPedArmed(playerPed, 4) or
		IsPedDeadOrDying(ped, 1) or
		IsPedFleeing(ped) or
		IsPedInAnyVehicle(ped)
	then
		return
	end

	local performEmote = function(ped, dict, anim)
		while not HasAnimDictLoaded(dict) do
			RequestAnimDict(dict)
			Citizen.Wait(20)
		end
		exports.oldutils:RequestAccess(ped)
		TaskPlayAnim(ped, dict, anim, 6.0, 6.0, -1, 48, 0.0)
	end

	LastInteract = GetGameTimer()

	exports.oldutils:RequestAccess(ped)
	TaskTurnPedToFaceEntity(ped, playerPed, 3000)

	Citizen.Wait(2000)

	local message = ""

	if zone == ControlZone then
		message = "They seem to recognize you!"
		performEmote(ped, "friends@frj@ig_1", "wave_a")
	else
		message = "They don't seem to know you..."
		performEmote(ped, "gestures@m@standing@casual", "gesture_shrug_hard")
	end

	exports.mythic_notify:SendAlert("inform", message, 7000)
end)