local GetPeds = exports.oldutils.GetPeds
local ShouldUpdate = true
local Events = {}
local Positions =  {}

Peds = {}
PedsCache = {}
Debug = false

--[[ Threads ]]--
Citizen.CreateThread(function()
	DecorRegister("No_Report", 2)

	SetCreateRandomCops(false)
	SetCreateRandomCopsNotOnScenarios(false)
	SetCreateRandomCopsOnScenarios(false)
	
	while true do
		Citizen.Wait(0)

		SetPedDensityMultiplierThisFrame(1.0)

		if IsControlJustPressed(0, 46) then
			local nearestPed = exports.oldutils:GetNearestPed() or 0
			if DoesEntityExist(nearestPed) and #(GetEntityCoords(nearestPed) - GetEntityCoords(PlayerPedId())) < 3.0 then
				TriggerEvent("peds:interact", nearestPed)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		if Debug then
			Citizen.Wait(0)
		else
			Citizen.Wait(100)
		end

		local playerPed = PlayerPedId()
		local playerPos = GetEntityCoords(playerPed)
		
		if ShouldUpdate then
			PedsCache = GetPeds()
			for k, ped in ipairs(PedsCache) do
				if Peds[ped] == nil and not IsPedAPlayer(ped) and IsPedHuman(ped) then
					Peds[ped] = {}

					-- SetPedCombatMovement(ped, 4)
					-- SetPedCombatAbility(ped, 2)
					-- TaskCombatPed(ped, playerPed, 0, 16)
					-- GiveWeaponToPed(ped, GetHashKey("WEAPON_PISTOL"), 60, true, true)
				end
			end
			ShouldUpdate = false
		end

		local reporting = {}
		local color = {255,255,255}
		local pos, alertness, fleeing, watching

		local addReport = function(ped, pos)
			for _, otherPos in ipairs(Positions) do
				if #(otherPos - pos) < Config.DistanceBetweenReports then
					return
				end
			end
			reporting[#reporting + 1] = ped
			table.insert(Positions, pos)
			if #Positions > 20 then
				table.remove(Positions, 1)
			end
		end

		for ped, info in pairs(Peds) do
			if DoesEntityExist(ped) and not IsPedDeadOrDying(ped) then
				-- 0 : Neutral
				-- 1 : Heard something (gun shot, hit, etc)
				-- 2 : Knows (the origin of the event)
				-- 3 : Fully alerted (is facing the event?)
				pos = GetEntityCoords(ped)
				alertness = GetPedAlertness(ped)
				fleeing = IsPedFleeing(ped)
				color = {255,255,255}

				local nearestEventIndex = GetNearestEvent(pos)
				local nearestEvent = Events[nearestEventIndex]
				
				if alertness == 1 then
					color = {255,0,0}
				elseif alertness == 2 then
					color = {255,255,0}
				elseif alertness == 3 then
					color = {0,255,0}
				end

				-- 12 = CTaskShockingEvent ?
				-- 55 = CTaskShovePed
				-- 427 = CTaskReactToDeadPed
				-- 444 = CTaskReactAndFlee
				-- 441 = CTaskReactToExplosion
				-- 448 = CTaskReactToBuddyShot
				-- 89 = CTaskShockingNiceCarPicture
				-- 144 - CTaskReactToGunAimedAt

				if GetIsTaskActive(ped, 80) then
					-- CTaskShockingEventWatch
					color = {255,0,0}
					watching = true
				elseif GetIsTaskActive(ped, 82) then
					-- CTaskShockingEventGoto
					color = {0,255,0}
				elseif GetIsTaskActive(ped, 83) then
					-- CTaskShockingEventHurryAway
					color = {0,0,255}
				elseif GetIsTaskActive(ped, 85) then
					-- CTaskShockingEventReact
					color = {255,255,0}
				elseif GetIsTaskActive(ped, 86) then
					-- CTaskShockingEventBackAway
					color = {255,0,255}
				elseif GetIsTaskActive(ped, 88) then
					-- CTaskShockingEventStopAndStare
					color = {0,255,255}
					watching = true
				elseif GetIsTaskActive(ped, 90) then
					-- CTaskShockingEventThreatResponse
					color = {255,0,128}
				end

				-- The ped is alerted to something.
				if nearestEvent ~= nil and ShouldReport(ped, nearestEvent.name) then
					-- print("NEAR",nearestEvent.name)
					-- Get an event to react to.
					if not info.event then
						local eventConfig = Config.Events[nearestEvent.name]
						if not eventConfig or not eventConfig.MaxDistance or #(pos - playerPos) < eventConfig.MaxDistance then
							info.event = nearestEventIndex
							info.coords = pos
							-- SetPedAlertness(ped, eventConfig.Alert or alertness)
						end
					end
				end

				-- Check if should report the event.
				if info.event and not info.reported then
					if watching then
						-- Report immediately.
						addReport(ped, pos)
					else
						-- Check safety before reporting.
						local event = Events[info.event]
						if event then
							local eventConfig = Config.Events[event.name]
							if not eventConfig or not eventConfig.MinDistance or #(pos - playerPos) > eventConfig.MinDistance then
								addReport(ped, pos)
							end
						end
					end
				end
				
				if Debug then
					DrawLine(pos.x, pos.y, pos.z, pos.x, pos.y, pos.z + 3.0, color[1], color[2], color[3], 255)
				end
			else
				Peds[ped] = nil
			end
		end

		for k, ped in ipairs(reporting) do
			Report(ped)
		end

		Events = {}
	end
end)

--[[ Functions ]]--
function AddEvent(name, coords, ped)
	if not coords then coords = GetEntityCoords(PlayerPedId()) end
	
	Events[#Events + 1] = { name = name, coords = coords }
	
	if DoesEntityExist(ped) then
		local pedInfo = Peds[ped]
		if not pedInfo then
			pedInfo = {}
			Peds[ped] = pedInfo
		end
		pedInfo.event = #Events
		pedInfo.coords = GetEntityCoords(ped)
	end
end
exports("AddEvent", AddEvent)

function ShouldReport(ped, event)
	if not event then return false end
	if DecorGetBool(ped, "No_Report") then return false end

	local playerPed = PlayerPedId()
	
	if IsPedInCombat(ped, playerPed) then
		return false
	end
	
	local eventConfig = Config.Events[event]
	if not eventConfig then return false end

	local willReport = true
	local zoneChance = Config.Zones[GetNameOfZone(GetEntityCoords(ped)):upper()] or 1.0

	math.randomseed(ped)

	willReport = math.random() <= (eventConfig.Chance or 1.0) * zoneChance

	math.randomseed(GetGameTimer())

	return willReport
end
exports("ShouldReport", ShouldReport)

function Report(ped)
	if not ped then return end

	local info = Peds[ped]
	if not info then return end

	info.reported = true
	-- print(ped.." wants to report "..info.event)

	local event = Events[info.event]
	if not event then return end

	local eventConfig = Config.Events[event.name]
	if not eventConfig then return end

	Citizen.CreateThread(function()
		Citizen.Wait(GetRandomIntInRange(Config.ReportTimeframe[1], Config.ReportTimeframe[2]))

		local doesExist = DoesEntityExist(ped)
		
		if doesExist and IsPedDeadOrDying(ped) then return end
		
		local coords = nil
		
		if doesExist then
			coords = GetEntityCoords(ped)
			Citizen.CreateThread(function()
				if not IsPedInAnyVehicle(ped, true) and exports.oldutils:RequestAccess(ped) then
					TaskStartScenarioInPlace(ped, "WORLD_HUMAN_TOURIST_MOBILE", 0, true)
					Citizen.Wait(8000)
					if DoesEntityExist(ped) then
						ClearPedTasks(ped)
					end
				end
			end)
		else
			coords = info.coords
		end

		local dir = exports.misc:Normalize(coords - event.coords)
		local rotation = math.ceil(math.atan2(dir.y, dir.x) * 57.29578)

		local playerVheicle = GetVehiclePedIsIn()
		local reportVehicle = #(event.coords - coords) < Config.ReportVehicleDistance
		
		-- print("reporting",event.name)
		local message = eventConfig.Code
		local messageType = 0

		if message == nil then
			messageType = 3
			message = eventConfig.Messages[GetRandomIntInRange(1, #eventConfig.Messages + 1)]
		end

		exports.dispatch:Report("Emergency", message, messageType, event.coords, reportVehicle, { coords = coords, rotation = rotation })

		info.reported = false
		info.event = nil
		info.coords = nil

		Citizen.Wait(30000)
		RemoveBlip(blip)
	end)
end

function GetNearestEvent(coords)
	local nearestEvent = nil
	local nearestDist = 0.0

	for k, event in ipairs(Events) do
		local dist = #(event.coords - coords)
		if nearestEvent == nil or dist < nearestDist then
			nearestEvent = k
			nearestDist = dist
		end
	end

	return nearestEvent
end

--[[ Events ]]--
AddEventHandler("populationPedCreating", function(x, y, z, model, setters)
	ShouldUpdate = true
end)