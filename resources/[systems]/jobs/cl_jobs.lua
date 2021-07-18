Markers = {}
Events = {}
OnDuty = nil
Vehicle = 0
LastVehicle = 0

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		while not OnDuty do
			Citizen.Wait(1000)
		end

		Citizen.Wait(0)

		local job = GetCurrentJob()
		local pedCoords = GetEntityCoords(PlayerPedId())
		local vehicle = GetVehicle()
		local isVehicleOut = DoesEntityExist(vehicle)

		if job and job.Vehicles then
			for k, spawn in ipairs(job.Vehicles) do
				local dist = #(spawn.In - pedCoords)

				if dist > 3.0 then
					goto continue
				end

				local canUse = GetGameTimer() - LastVehicle > 5000
				local id = 1

				if not canUse then
					id = 2
				end

				local text
				if isVehicleOut then
					text = "Store Vehicle"
				else
					text = "Retrieve Vehicle"
				end

				if exports.oldutils:DrawContext(text, spawn.In, id) and canUse then
					if DoesEntityExist(vehicle) then
						exports.oldutils:Delete(vehicle)
						Vehicle = 0
					else
						TrySpawn(spawn)
					end
					LastVehicle = GetGameTimer()
				end
				::continue::
			end
		end
	end
end)

--[[ Functions ]]--
function IsOnDuty(name)
	return name == OnDuty
end
exports("IsOnDuty", IsOnDuty)

function IsInGroup(group)
	if Jobs[OnDuty] then
		return group == Jobs[OnDuty].Group
	end
	return false
end
exports("IsInGroup", IsInGroup)

function GetCurrentJob()
	return Jobs[OnDuty]
end
exports("GetCurrentJob", GetCurrentJob)

function GetJob(name)
	return Jobs[name]
end
exports("GetJob", GetJob)

function Register(name, info)
	info.Name = info.Name or name
	name = name:lower()
	Jobs[name] = info

	if info.Clocks then
		if info.Blip then
			info.Blip.name = info.Name
		end
		if Markers[name] then
			for k, v in pairs(Markers[name]) do
				exports.markers:Remove(v)
			end
		end
		Markers[name] = {}
		for k, pos in ipairs(info.Clocks) do
			local id = info.Name.."-clock"..tostring(k)
			
			Markers[name][k] = exports.markers:CreateUsable(GetCurrentResourceName(), pos, id, "Clock ("..info.Name..")", Config.Markers.DrawRadius, Config.Markers.Radius, info.Blip)
			if Events[id] then
				RemoveEventHandler(Events[id])
			end
			Events[id] = AddEventHandler("markers:use_"..id, function()
				TriggerServerEvent("jobs:tryClock", name, OnDuty == name)
			end)
		end
	end
end
exports("Register", Register)

function MustBeOnDuty(name)
	if IsOnDuty(name) then
		return true
	else
		exports.mythic_notify:SendAlert("error", "You must be on duty!", 7000)
		return false
	end
end
exports("MustBeOnDuty", MustBeOnDuty)

function ShowJobs()
	local message = ""
	local factions = exports.character:GetFactions()

	for faction, info in pairs(factions) do
		if Jobs[faction] then
			if message ~= "" then
				message = message..", "
			end
			message = message..Jobs[faction].Name.." ("..tostring(info.level)..")"
		end
	end
	if message == "" then
		message = "You are unemployed."
	else
		message = "Employeed to: "..message
	end

	TriggerEvent("chat:addMessage", message)
end

function ShowPower()
	local message = ""
	local user = exports.user:GetUser()
	local controlAll = exports.user:IsGroup(user, Config.UserGroup)

	for name, info in pairs(Jobs) do
		local power = GetPower(0, name)
		if controlAll then
			power = 9999
		end
		if power > 0 then
			if message ~= "" then
				message = message..", "
			end
			message = message..info.Name.." ("..power..")"
		end
	end
	if message == "" then
		message = "You cannot access any jobs."
	end

	TriggerEvent("chat:addMessage", message)
end

function ShowInfo(name)
	name = name:lower()
	local job = Jobs[name]
	if not job then
		TriggerEvent("chat:addMessage", "Invalid job!")
		return
	end

	local sortedRanks = {}
	for rank, power in pairs(job.Ranks) do
		sortedRanks[#sortedRanks + 1] = { rank, power }
	end
	table.sort(sortedRanks, function(a, b) return a[2] < b[2] end)

	local message = ""
	for _, sortedRank in ipairs(sortedRanks) do
		if message ~= "" then
			message = message..", "
		end
		message = message..sortedRank[1].." ("..sortedRank[2]..")"
	end
	TriggerEvent("chat:addMessage", "Ranks ("..job.Name.."): "..message)
end

function ShowLicenses()
	local message = ""
	local licenses = exports.character:GetLicenses()

	if licenses then
		for license, info in pairs(licenses) do
			if message ~= "" then
				message = message..", "
			end
			message = ("%s%s (%s)"):format(message, license, info.points)
		end
	end
	if message == "" then
		message = "You have no licenses."
	else
		message = ("Licenses: %s."):format(message)
	end

	TriggerEvent("chat:addMessage", message)
end

function TrySpawn(spawn)
	local coords = nil
	for k, v in ipairs(spawn.Coords) do
		if not IsPositionOccupied(v.x, v.y, v.z, 0.5, false, true, true, false, false, 0, false) then
			coords = v
			break
		end
	end

	if not coords then return end
	
	local vehicle = exports.oldutils:CreateVehicle(GetHashKey(spawn.Model), coords.x, coords.y, coords.z, coords.w, true, true, true)
	SetVehicleLivery(vehicle, spawn.Livery or 0)
	SetVehicleColours(vehicle, spawn.PrimaryColor or 0, spawn.SecondaryColor or 0)
	
	if spawn.Extras then
		for i = 1, 14 do
			SetVehicleExtra(vehicle, i, spawn.Extras[i] ~= true)
		end
	end

	Vehicle = VehToNet(vehicle)

	TriggerServerEvent("vehicles:requestKey", Vehicle, "job")
end

function GetVehicle()
	if not NetworkDoesNetworkIdExist(Vehicle) then
		return 0
	end
	return NetToVeh(Vehicle) or 0
end
exports("GetVehicle", GetVehicle)

function IsInEmergency(attribute)
	local job = GetCurrentJob()
	if job and job.Emergency then
		return not attribute or job.Emergency[attribute]
	elseif attribute then
		return false
	end

	for id, job in pairs(Jobs) do
		if job.Emergency and exports.character:HasFaction(id) then
			return true
		end
	end
	return false
end
exports("IsInEmergency", IsInEmergency)

--[[ Events ]]--
RegisterNetEvent("jobs:command")
AddEventHandler("jobs:command", function(command, args)
	if command == "jobs" then
		ShowJobs()
	elseif command == "power" then
		ShowPower()
	elseif command == "info" then
		ShowInfo(args[1])
	elseif command == "licenses" then
		ShowLicenses()
	end
end)

RegisterNetEvent("jobs:clock")
AddEventHandler("jobs:clock", function(name, message)
	if message == "nojob" then
		message = "You are not employed here!"
	elseif message == "onduty" then
		message = "You are already on-duty somewhere else!"
	elseif message == "limit" then
		message = "Limit reached!"
	end
	if message == true or message == false then
		if message then
			OnDuty = name
			message = "Clocked on!"
		else
			OnDuty = nil
			message = "Clocked off!"

			local vehicle = GetVehicle()
			if DoesEntityExist(vehicle) then
				exports.oldutils:Delete(vehicle)
				vehicle = 0
			end
		end
		exports.mythic_notify:SendAlert("inform", message, 7000)
	else
		exports.mythic_notify:SendAlert("error", message, 7000)
	end
end)

AddEventHandler("jobs:start", function()
	if GetResourceState("cache") ~= "started" then return end

	Markers = exports.cache:Get("Markers") or {}
	Jobs = exports.cache:Get("Jobs") or {}

	for job, info in pairs(Jobs) do
		Register(job, info)
	end
end)

AddEventHandler("jobs:stop", function()
	if GetResourceState("cache") ~= "started" then return end
	if GetResourceState("markers") ~= "started" then return end
	
	exports.cache:Set("Markers", Markers)
end)

--[[ Commands ]]--
RegisterCommand("panic", function(source, args, command)
	if
		not exports.jobs:IsInGroup("Emergency")
		or exports.interaction:IsHandcuffed()
		or exports.interaction:IsZiptied()
		or exports.emotes:AreHandsUp()
	then
		exports.mythic_notify:SendAlert("error", "You can't do that right now!", 8000)
		return
	end

	TriggerServerEvent("jobs:togglePanic")
end)