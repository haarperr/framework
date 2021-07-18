Players = {}
OnDuty = {}
Trackers = {}
Groups = {}

--[[ Functions ]]--
function Register(name, info)
	info.Name = info.Name or name
	name = name:lower()
	Jobs[name] = info
end
exports("Register", Register)

function Clock(source, name)
	if not name then return end
	name = name:lower()
	local job = Jobs[name]
	if not job then return end

	local message = nil
	local updateTracker = false
	local group = job.Group or "Civilian"
	local hasFaction = job.Public or exports.character:HasFaction(source, name)

	if IsOnDuty(source, name) then
		message = false
		Players[source] = nil
		if OnDuty[name] then
			OnDuty[name][source] = nil
		end
		if job.UseGroup and Groups[group] then
			Groups[group][source] = nil
		end
		updateTracker = true
	elseif IsOnDuty(source) then
		message = "onduty"
	elseif hasFaction then
		if job.Max and CountActiveDuty(job.Name) >= job.Max then
			message = "limit"
		else
			message = true
			Players[source] = name
			if not OnDuty[name] then
				OnDuty[name] = {}
			end
			OnDuty[name][source] = true
			if job.UseGroup then
				if not Groups[group] then
					Groups[group] = {}
				end
				Groups[group][source] = true
			end
			updateTracker = true
		end
	else
		message = "nojob"
	end
	TriggerClientEvent("jobs:clock", source, name, message)
	TriggerEvent("jobs:clock", source, name, message)
	if updateTracker and job.Tracker then
		UpdateTracker(source, name, message == true)
	end
	if message == true then
		exports.log:Add({
			source = source,
			verb = "clocked",
			noun = "on",
			extra = name,
		})
	elseif message == false then
		exports.log:Add({
			source = source,
			verb = "clocked",
			noun = "off",
			extra = name,
		})
	end
end
exports("Clock", Clock)

function IsOnDuty(source, name)
	if name == nil then
		return Players[source] ~= nil
	end
	return Players[source] == name
end
exports("IsOnDuty", IsOnDuty)

function GetActiveDuty(name)
	return OnDuty[name]
end
exports("GetActiveDuty", GetActiveDuty)

function CountActiveDuty(name)
	if type(name) ~= "string" then return 0 end
	name = name:lower()
	if OnDuty[name] then
		local count = 0
		for player, _ in pairs(OnDuty[name]) do
			count = count + 1
		end
		return count
	end
	return 0
end
exports("CountActiveDuty", CountActiveDuty)

function CountActiveEmergency(attribute)
	local count = 0
	for name, job in pairs(Jobs) do
		if job.Emergency and (not attribute or job.Emergency[attribute]) and OnDuty[name] then
			for player, _ in pairs(OnDuty[name]) do
				count = count + 1
			end
		end
	end
	return count
end
exports("CountActiveEmergency", CountActiveEmergency)

function GetActiveGroup(group)
	return Groups[group]
end
exports("GetActiveGroup", GetActiveGroup)

function GetGroup(source)
	local name = GetCurrentJob(source)
	if not name then return end

	return Jobs[name].Group
end
exports("GetGroup", GetGroup)

function GetCurrentJob(source, getJob)
	if getJob then
		return Jobs[Players[source]]
	end
	return Players[source]
end
exports("GetCurrentJob", GetCurrentJob)

function GetJob(name)
	return Jobs[name]
end
exports("GetJob", GetJob)

function GetTrackers(group)
	return Trackers[group]
end
exports("GetTrackers", GetTrackers)

function UpdateTracker(source, jobName, toggle)
	local sourceName
	if toggle then
		sourceName = exports.character:GetName(source)
	end
	
	local job = Jobs[jobName]
	if not job or not job.Tracker then return end

	local players = {}
	if job.Tracker.Group then
		if not Trackers[job.Tracker.Group] then
			Trackers[job.Tracker.Group] = {}
		end
		if toggle then
			Trackers[job.Tracker.Group][source] = toggle
			exports.trackers:AddToGroup(source, job.Tracker.Group, false, "job", jobName, exports.character:GetName(source))
		else
			Trackers[job.Tracker.Group][source] = nil
			exports.trackers:RemoveFromGroup(source, job.Tracker.Group)
		end
		players = Trackers[job.Tracker.Group]
	else
		players = OnDuty[jobName]
	end

	if not players then return end
	local payload = {}

	if toggle == 2 then
		exports.dispatch:Add({
			coords = GetEntityCoords(GetPlayerPed(source)),
			group = job.Group,
			hasBlip = true,
			message = "11-99",
			subMessage = IsInEmergency(source, "Panic"),
			messageType = 0,
			source = source
		})
		exports.trackers:Set(source, job.Group:lower(), 5, true)
	else
		exports.trackers:Set(source, job.Group:lower(), 5, nil)
	end
end

function ResetUser(source)
	local source = source
	local name = Players[source]
	if name ~= nil then
		local job = Jobs[name]
		local group = job.Group or "Civilian"

		if OnDuty[name] then
			OnDuty[name][source] = nil
		end
		if job.UseGroup and Groups[group] then
			Groups[group][source] = nil
		end
		if Trackers[name] then
			Trackers[name][source] = nil
		end
		UpdateTracker(source, name, false)
		TriggerClientEvent("jobs:clock", source, name, false)
		Players[source] = nil
	end
end

function CanLicense(source, license)
	if source == 0 then return true end
	
	local job = GetCurrentJob(source)
	if not job then return false end
	
	local faction = exports.character:GetFaction(source, job)
	if not faction then return false end

	job = Jobs[job]
	if not job.Licenses then return false end

	for k, v in ipairs(job.Licenses) do
		if faction.level >= v.Level and v.Name:lower() == license then
			return true
		end
	end
	return false
end

function IsInEmergency(source, attribute)
	local job = GetCurrentJob(source, true)
	if job and job.Emergency then
		return not attribute or job.Emergency[attribute]
	elseif attribute then
		return false
	end

	for name, job in pairs(Jobs) do
		if job.Emergency and exports.character:HasFaction(source, name) then
			return true
		end
	end
	return false
end
exports("IsInEmergency", IsInEmergency)

--[[ Functions: Checks ]]--
function CheckTarget(source, target, faction, rank)
	if not target or not GetPlayerPed(target) then
		if source == 0 then
			print("Invalid target")
		else
			TriggerClientEvent("chat:addMessage", source, "Target does not exist!")
		end
		return false
	end
	if source ~= 0 and faction and not CanTarget(source, target, faction) then
		TriggerClientEvent("chat:addMessage", source, "You cannot target that person in this job!")
		return false
	end
	if source ~= 0 and rank then
		local sourcePower = GetPower(source, faction)
		if sourcePower > rank then
			TriggerClientEvent("chat:addMessage", source, "You cannot target that rank!")
			return false
		end
	end
	return true
end

function CheckJob(source, name)
	if not Jobs[name] then
		if source == 0 then
			print("invalid job")
		else
			TriggerClientEvent("chat:addMessage", source, "Invalid job!")
		end
		return false
	end
	return true
end
exports("CheckJob", CheckJob)

function CheckLicense(source, license)
	if not CanLicense(source, license) then
		TriggerClientEvent("chat:addMessage", source, "You cannot control that license!")
		return false
	end
	return true
end

function CheckFaction(source)
	local factions = { "judge", "lssd", "dps", "lspd", "mrpd staff" }
	
	local hasFaction = false

	for _, faction in ipairs(factions) do
		if exports.character:HasFaction(source, faction) then
			hasFaction = true
			break
		end
	end
	
	if not hasFaction then
		TriggerClientEvent("chat:addMessage", source, "Missing faction!")
	end
	
	return hasFaction
end

--[[ Commands ]]--
exports.chat:RegisterCommand("jobs", function(source, args, command)
	if source == 0 then return end
	TriggerClientEvent("jobs:command", source, "jobs")
end, {}, -1, 0)

exports.chat:RegisterCommand("jobcontrols", function(source, args, command)
	if source == 0 then return end
	TriggerClientEvent("jobs:command", source, "power")
end, {}, -1, 0)

exports.chat:RegisterCommand("jobinfo", function(source, args, command)
	if source == 0 then return end
	TriggerClientEvent("jobs:command", source, "info", args)
end, {
	help = "View info regarding a certain job.",
	params = {
		{ name = "Name", help = "Name of the job you want to view." },
	}
}, 1, 0)

exports.chat:RegisterCommand("jobhire", function(source, args, command)
	local target = tonumber(args[1])
	local faction = tostring(args[2]):lower()

	if not CheckTarget(source, target, faction) then return end
	
	-- TODO: Distance check to target.
	
	if exports.character:JoinFaction(target, faction) then
		TriggerClientEvent("chat:addMessage", source, "Hired "..target.." to: "..faction.."!")
		exports.log:Add({
			source = source,
			target = target,
			verb = "hired",
			extra = faction,
		})
	elseif source ~= 0 then
		TriggerClientEvent("chat:addMessage", source, "They are already hired as: "..faction.."!")
	end
end, {
	help = "Hire somebody into a job.",
	params = {
		{ name = "Target", help = "ID of who's being hired." },
		{ name = "Job", help = "Job they're being hired to." },
	}
}, 2, 0)

exports.chat:RegisterCommand("jobfire", function(source, args, command)
	local target = tonumber(args[1])
	local faction = tostring(args[2]):lower()

	if not CheckTarget(source, target, faction) then return end
	
	if exports.character:LeaveFaction(target, faction) then
		TriggerClientEvent("chat:addMessage", source, "Fired "..target.." from: "..faction.."!")
		exports.log:Add({
			source = source,
			target = target,
			verb = "fired",
			extra = faction,
		})
	elseif source ~= 0 then
		TriggerClientEvent("chat:addMessage", source, "They are not hired as: "..faction.."!")
	end
end, {
	help = "Hire somebody into a job.",
	params = {
		{ name = "Target", help = "ID of who's being fired." },
		{ name = "Job", help = "Job they're being fired from." },
	}
}, 2, 0)

exports.chat:RegisterCommand("jobpromote", function(source, args, command)
	local target = tonumber(args[1])
	local faction = tostring(args[2]):lower()
	
	if not CheckJob(source, faction) then return end
	
	local rank = args[3]
	if tonumber(rank) then
		local job = GetJob(faction)
		local rankExists = false
		local findRank = tonumber(rank)
		rank = -1
		
		for _name, _rank in pairs(job.Ranks or {}) do
			if _rank == findRank then
				rank = _rank
				break
			end
		end
	else
		rank = GetPowerFromRank(faction, tostring(args[3]):lower())
	end
	if rank == -1 then
		if source == 0 then
			print("invalid rank")
		else
			TriggerClientEvent("chat:addMessage", source, "Invalid rank!")
		end
		return
	end
	
	if not CheckTarget(source, target, faction, rank) then return end
	
	if exports.character:UpdateFaction(target, faction, { level = rank }) then
		if source ~= 0 then
			TriggerClientEvent("chat:addMessage", source, "Set rank of ["..target.."] to "..tostring(rank).." in: "..faction.."!")
		end
		exports.log:Add({
			source = source,
			target = target,
			verb = "set",
			noun = "rank",
			extra = ("%s - rank: %s"):format(faction, rank),
		})
	elseif source ~= 0 then
		TriggerClientEvent("chat:addMessage", source, "They are not hired as: "..faction.."!")
	else
		print("user must be hired")
	end
end, {
	help = "Hire somebody into a job.",
	params = {
		{ name = "Target", help = "ID of who's being promoted/demoted." },
		{ name = "Job", help = "Job you want to affect." },
		{ name = "Rank", help = "Rank to set somebody as. Use /jobinfo <job> to see the ranks." },
	}
}, 3, 0)

-- exports.chat:RegisterCommand("jobquit", function(source, args, command)
-- 	local faction = tostring(args[1]):lower()
	
-- 	if Fire(source, faction) then
-- 		TriggerClientEvent("chat:addMessage", source, "You quit: "..faction)
-- 	elseif source ~= 0 then
-- 		TriggerClientEvent("chat:addMessage", source, "You are not hired as: "..faction)
-- 	end
-- end, {
-- 	help = "Quit one of your jobs.",
-- 	params = {
-- 		{ name = "Job", help = "Job they're being hired to." },
-- 	}
-- }, 1, 0)

exports.chat:RegisterCommand("licenses", function(source, args, command)
	if source == 0 then return end
	TriggerClientEvent("jobs:command", source, "licenses")
end, {
	help = "Check your licenses.",
	params = {}
}, -1, 0)

exports.chat:RegisterCommand("licenseadd", function(source, args, command)
	local target = tonumber(args[1])
	if not CheckTarget(source, target) then return end

	local license = tostring(args[2]):lower()
	if not CheckLicense(source, license) then return end
	
	if exports.character:AddLicense(target, license) then
		if source ~= 0 then
			TriggerClientEvent("chat:addMessage", source, ("You gave a %s license to [%s]"):format(license, target))
		end
		exports.log:Add({
			source = source,
			target = target,
			verb = "gave",
			noun = "license",
			extra = license,
		})
	elseif source ~= 0 then
		TriggerClientEvent("chat:addMessage", source, "They already have that license!")
	end
end, {
	help = "Assign somebody a license.",
	params = {
		{ name = "Target", help = "Who to give the license to." },
		{ name = "License", help = "The license to give." },
	}
}, 2, 0)

exports.chat:RegisterCommand("licenserevoke", function(source, args, command)
	local target = tonumber(args[1])
	if not CheckTarget(source, target) then return end

	local license = tostring(args[2]):lower()
	if not CheckLicense(source, license) then return end
	
	if exports.character:RemoveLicense(target, license) then
		if source ~= 0 then
			TriggerClientEvent("chat:addMessage", source, ("You revoked a %s license for [%s]"):format(license, target))
		end
		exports.log:Add({
			source = source,
			target = target,
			verb = "revoked",
			noun = "license",
			extra = license,
		})
	elseif source ~= 0 then
		TriggerClientEvent("chat:addMessage", source, "They don't have that license!")
	end
end, {
	help = "Revoke somebody's license.",
	params = {
		{ name = "Target", help = "Who to give the license to." },
		{ name = "License", help = "The license to give." },
	}
}, 2, 0)

exports.chat:RegisterCommand("licensepoints", function(source, args, command)
	local target = tonumber(args[1])
	if not CheckTarget(source, target) then return end

	local license = tostring(args[2]):lower()
	if not CheckLicense(source, license) then return end

	local points = tonumber(args[3])
	if not points then return end
	
	if exports.character:AddPointsToLicense(target, license, points) then
		local verb = "gave"
		local preposition = "to"
		if points < 0 then
			verb = "took"
			preposition = "from"
		end
		local message = ("%s %s points %s the %s license for [%s]"):format(verb, math.abs(points), preposition, license, target)
		if source ~= 0 then
			TriggerClientEvent("chat:addMessage", source, "You "..message..".")
		end
		exports.log:Add({
			source = source,
			target = target,
			verb = "gave",
			noun = "license points",
			extra = ("%s - points: %s"):format(license, points),
		})
	else
		TriggerClientEvent("chat:addMessage", source, "They don't have that license!")
	end
end, {
	help = "Give or take points on somebody's license.",
	params = {
		{ name = "Target", help = "Who's license to change." },
		{ name = "License", help = "The license to change." },
		{ name = "Points", help = "The points to give (positive) or take (negative)." },
	}
}, 3, 0)

exports.chat:RegisterCommand("licensecheck", function(source, args, rawCommand)
	if not CheckFaction(source) then return end
	
	local message = ""

	local target = tonumber(args[1])
	if not target then return end

	local character = exports.character:GetCharacter(target)
	if not character then return end

	local licenses = exports.character:GetLicenses(target)

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
		message = ("Current points on licenses for %s %s: %s."):format(character.first_name, character.last_name, message)
	end

	TriggerClientEvent("chat:addMessage", source, message, "emergency")
end, {
	help = "",
	params = {
		{ name = "Target", help = "ID of the target." },
	}
}, 1)

--[[ Character Events ]]--
RegisterNetEvent("character:switch")
AddEventHandler("character:switch", function()
	ResetUser(source)
end)

--[[ Events ]]--
RegisterNetEvent("jobs:tryClock")
AddEventHandler("jobs:tryClock", function(name, toggle)
	local source = source
	Clock(source, name, toggle)
end)

RegisterNetEvent("jobs:requestInfo")
AddEventHandler("jobs:requestInfo", function(name)
	local source = source
	
	if not exports.character:HasFaction(source, name) then return end

	
end)

AddEventHandler("playerDropped", function()
	ResetUser(source)
end)

RegisterNetEvent("jobs:togglePanic")
AddEventHandler("jobs:togglePanic", function()
	local source = source
	local group = GetGroup(source)
	if not group then return end

	local trackers = GetTrackers(group:lower())
	if not trackers then return end

	local tracker = trackers[source]
	if not tracker then return end

	local jobName = GetCurrentJob(source, false)
	if tracker == true then
		tracker = 2
	else
		tracker = true
	end
	UpdateTracker(source, jobName, tracker)
	local message
	if tracker == 2 then
		message = "Panic turned ON!"
	else
		message = "Panic turned OFF!"
	end
	TriggerClientEvent("notify:sendAlert", source, "error", message, 7000)
end)

--[[exports.chat:RegisterCommand("a:jobremove", function(source, args, command)
	local target = tonumber(args[1])
	local faction = tostring(args[2]):lower()

	local character = exports.GHMattiMySQL:QueryResult("SELECT * FROM factions WHERE character_id=@target", {
		["@target"] = target,
	})[1]

	if not character then
		TriggerClientEvent("chat:addMessage", source, "Person not found!")
		return
	end

	
	if exports.character:LeaveFaction(target, faction) then
		TriggerClientEvent("chat:addMessage", source, "Fired "..target.." from: "..faction.."!")
		exports.log:Add({
			source = source,
			target = target,
			verb = "fired",
			extra = faction,
		})
	elseif source ~= 0 then
		TriggerClientEvent("chat:addMessage", source, "They are not hired as: "..faction.."!")
	end
end, {
	help = "Hire somebody into a job.",
	params = {
		{ name = "Target", help = "ID of who's being fired." },
		{ name = "Job", help = "Job they're being fired from." },
	}
}, 2, 25) --]]

