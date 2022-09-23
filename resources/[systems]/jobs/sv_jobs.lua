Main.players = {}
Main.cached = {}
Main.panic = {}

--[[ Functions: Main ]]--
function Main:Init()
	-- Load cache.
	local cache = exports.cache:Get("jobs")
	if cache then
		self.temp = cache
	end

	-- Create tables.
	WaitForTable("characters")
	RunQuery("sql/jobs_sessions.sql")

	-- Load sessions.
	exports.GHMattiMySQL:QueryAsync("UPDATE `jobs_sessions` SET end_time=current_timestamp() WHERE end_time IS NULL")
end

function Main:OnRegister(job)
	job.count = 0
	job.duty = {}

	if self.temp then
		for source, id in pairs(self.temp) do
			if id == job.id then
				job:Clock(source, true, true)
				self.temp[source] = nil
			end
		end
	end
end

function Main:Update()
	-- for id, job in pairs(self.jobs) do
	-- 	job:Update()
	-- end

	for source, cached in pairs(self.cached) do
		if os.clock() - cached.time > Config.LogCache then
			self.cached[source] = nil
		end
	end
end

function Main:CachePlayer(source)
	local jobId = self.players[source]
	if not jobId then return end

	local job = self.jobs[jobId]
	if not job then return end

	local characterId = job.duty[source]
	if not characterId then return end
	
	self.cached[characterId] = {
		time = os.clock(),
		job = jobId,
	}

	self.panic = nil,
	
	job:Clock(source, false)
end

function Main:GetRank(source, id)
	local job = self.jobs[id]
	if not job then return end

	local faction = exports.factions:Get(source, job.Faction, job.Group)
	if not faction then return end

	return job:GetRankByHash(faction.level, true)
end

function Main:SetRank(source, id, rank)
	local job = self.jobs[id]
	if not job then return false, "no job" end

	return job:SetRank(source, rank)
end

function Main:IsHired(source, id)
	local job = self.jobs[id]
	if not job then return false end

	return job:IsHired(source)
end

function Main:GetCurrentJob(id)
	return self.jobs[self.players[id]]
end

function Main:CountActiveDuty(attribute)
    local count = 0
    for id, job in pairs(self.jobs) do
        if job.Emergency and (not attribute or job.Emergency[attribute]) then
            count = count + job.count
        end
    end

    return count
end

function Main:IsInEmergency(id, attribute)
	local job = self.jobs[self.players[id]]
	if not job then return end

	if job.Emergency then
		return not attribute or job.Emergency[attribute]
	elseif attribute then
		return false
	end

	for id, job in pairs(self.jobs) do
		if job and job.Emergency and exports.factions:Has(job.Faction, job.Group) then
			return true
		end
	end

	return false
end

function Main:IsInGroup(id, group)
	local job = self.jobs[self.players[id]]
	if not job then return end

	if job.Tracker then
		return job.Tracker.Group == group
	end

	return false
end

function Main:IsInFaction(id, faction)
	local job = self.jobs[self.players[id]]
	if not job then return end

	return job.Faction == faction
end

--[[ Functions: Job ]]--
-- function Job:Update()
	
-- end

function Job:SetRank(source, rank)
	local faction = exports.factions:Get(source, self.Faction, self.Group)

	if not faction then
		return false, "not hired"
	end

	if type(rank) == "string" then
		rank = GetHashKey(rank)
	end

	if faction.level == rank then
		return false, "already set"
	end

	return exports.factions:UpdateFaction(source, self.Faction, self.Group, "level", rank)
end

function Job:Hire(source, rank)
	if self:IsHired(source) then
		return false, "already hired"
	end

	return exports.factions:JoinFaction(source, self.Faction, self.Group or false, type(rank) == "string" and GetHashKey(rank) or tonumber(rank) or 0)
end

function Job:Fire(source)
	if not self:IsHired(source) then
		return false, "not hired"
	end

	return exports.factions:LeaveFaction(source, self.Faction, self.Group)
end

function Job:Clock(source, value, wasCached)
	-- Check hired.
	if value and (not self:IsHired(source) and not self.IsPublic) then
		return false, "not hired"
	end

	-- Flip states.
	if value == nil then
		value = not self.duty[source]
	end

	-- Check same states.
	if (value or nil) == self.duty[source] then
		return false, "same state"
	end

	-- Check already clocked.
	local currentJob = Main.players[source]
	if currentJob and currentJob ~= self.id then
		return false, "already clocked"
	end

	-- Get faction.
	local faction = exports.factions:Get(source, self.Faction, self.Group) or {}

	-- Get/check character id.
	local characterId = value and exports.character:Get(source, "id") or self.duty[source]
	if not characterId then
		return false, "no character id"
	end

	-- Cache state.
	self.duty[source] = value and characterId or nil
	Main.players[source] = value and self.id or nil

	-- Update count.
	if value then
		self.count = self.count + 1
	else
		self.count = self.count - 1
	end

	-- Set player state.
	local state = Player(source).state
	if state then
		state.job = value and self.id or nil
	end

	-- Trigger events.
	TriggerEvent("jobs:clocked", self.id, source, value)
	TriggerClientEvent("jobs:clocked", source, self.id, value)

	-- Trackers.
	local tracker = self.Tracker
	if self.Tracker then
		if value then
			exports.trackers:JoinGroup(tracker.Group, source, tracker.State, tracker.Mask or 6)
		else
			exports.trackers:LeaveGroup(tracker.Group, source)
		end
	end

	-- Query stuff.
	if value then
		exports.GHMattiMySQL:QueryAsync([[
			INSERT INTO `jobs_sessions`
			SET
				character_id=@characterId,
				job_id=@jobId,
				level=@level,
				start_time=current_timestamp(),
				was_cached=@wasCached
		]], {
			["@jobId"] = self.id,
			["@level"] = faction.level or 0,
			["@characterId"] = characterId,
			["@wasCached"] = wasCached == true,
		})
	else
		exports.GHMattiMySQL:QueryAsync("UPDATE `jobs_sessions` SET end_time=current_timestamp() WHERE character_id=@characterId AND job_id=@jobId AND end_time IS NULL", {
			["@jobId"] = self.id,
			["@characterId"] = characterId,
		})
	end

	return true
end

function Job:IsHired(source)
	return exports.factions:Has(source, self.Faction, self.Group)
end

--[[ Events: Net ]]--
RegisterNetEvent("jobs:clock", function(jobId)
	local source = source

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0) then return end
	PlayerUtil:UpdateCooldown(source)

	-- Get/check job.
	local job = Main.jobs[jobId]
	if not job then return end

	-- Try to clock.
	if job:Clock(source) then
		local state = job.duty[source]

		-- Log it.
		exports.log:Add({
			source = source,
			verb = "clocked",
			noun = state and "on" or "off",
		})

		-- Play sound.
		exports.sound:PlaySoundPlayer(source, "flipcard", 0.5, 0.1)

		-- Inform client.
		TriggerClientEvent("chat:notify", source, "Clocked "..(state and "on" or "off").."!", "success")
	end
end)

RegisterNetEvent("jobs:togglePanic")
AddEventHandler("jobs:togglePanic", function()
	local source = source

	local jobId = Main.players[source]
	if not jobId then return end

	local job = Main.jobs[jobId]
	if not job then return end

	local tracker = job.Tracker
	if not tracker then return end

	if not Main.panic then Main.panic = {} end

	local toggled = "off"
	local message = "Panic turned OFF!"
	if not Main.panic[source] then
		exports.trackers:LeaveGroup(tracker.Group, source)
		exports.trackers:JoinGroup(tracker.Group, source, "panic", tracker.Mask or 6)
		Main.panic[source] = true
		toggled = "on"
		message = "Panic turned ON!"

		exports.dispatch:Add({
			coords = GetEntityCoords(GetPlayerPed(source)),
			group = (tracker.Group):lower(),
			hasBlip = true,
			message = "11-99",
			subMessage = Main:IsInEmergency(source, "Panic"),
			messageType = 0,
			source = source
		})
	else
		exports.trackers:LeaveGroup(tracker.Group, source)
		exports.trackers:JoinGroup(tracker.Group, source, tracker.State, tracker.Mask or 6)
		Main.panic[source] = nil
	end

	exports.log:Add({
		source = source,
		target = target,
		verb = "toggled",
		noun = "panic",
		extra = toggled
	})

	TriggerClientEvent("chat:notify", source, message, 7000)
end)

--[[ Events ]]--
AddEventHandler("jobs:start", function(...)
	Main:Init()
end)

AddEventHandler("jobs:stop", function()
	exports.cache:Set("jobs", Main.players)
end)

AddEventHandler("character:selected", function(source, character, wasActive)
	if not character then
		Main:CachePlayer(source)
		return
	end
end)

AddEventHandler("factions:loaded", function(source, characterId, factions)
	if not characterId then
		return
	end

	local cached = Main.cached[characterId]
	if not cached then return end

	local job = cached.job and Main.jobs[cached.job]
	if not job then return end

	job:Clock(source, true, true)

	Main.cached[characterId] = nil
end)

AddEventHandler("playerDropped", function(reason)
	local source = source

	Main:CachePlayer(source)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(5000)
	end
end)

--[[ Exports ]]--
exports("GetCurrentJob", function(...)
	return Main:GetCurrentJob(...)
end)

exports("GetRank", function(...)
	return Main:GetRank(...)
end)

exports("IsHired", function(...)
	return Main:IsHired(...)
end)

exports("IsInEmergency", function(...)
	return Main:IsInEmergency(...)
end)

exports("IsInFaction", function(...)
	return Main:IsInFaction(...)
end)

exports("IsInGroup", function(...)
	return Main:IsInGroup(...)
end)

exports("CountActiveDuty", function(...)
	return Main:CountActiveDuty(...)
end)

--[[ Commands ]]--
local function HireOrFire(source, args, cb, isHire)
	-- Get/check job.
	local jobId = (args[1] or ""):lower()
	local job = Main.jobs[jobId]
	if not job then
		cb("error", "Invalid job!")
		return
	end
	
	-- Get/check target.
	local target = tonumber(args[2]) or source
	if not target or target == 0 or target < -1 or not exports.character:IsSelected(target) then
		cb("error", "Invalid target!")
		return
	end

	-- Get/check rank.
	local rank
	if isHire and args[3] then
		rank = job:GetRankByHash(GetHashKey(args[3]))
		if not rank then
			cb("error", "Invalid rank!")
			return
		end
	end

	-- Hire or fire.
	local success, reason
	if isHire then
		success, reason = job:Hire(target, rank and rank.Hash)
	else
		success, reason = job:Fire(target)
	end

	-- Client callbacks.
	if success then
		cb("success", ("%s [%s] %s '%s'!"):format(isHire and "Hired" or "Fired", target, isHire and "to" or "from", jobId))

		exports.log:Add({
			source = source,
			target = target,
			verb = isHire and "hired" or "fired",
			extra = jobId..(rank and " - "..rank.Name or ""),
		})
	else
		cb("error", ("Failed to %s [%s] %s '%s' (%s)!"):format(isHire and "hire" or "fire", target, isHire and "to" or "from", jobId, reason or "?"))
	end
end

exports.chat:RegisterCommand("a:jobrank", function(source, args, command, cb)
	-- Get/check job.
	local jobId = (args[1] or ""):lower()
	local job = Main.jobs[jobId]
	if not job then
		cb("error", "Invalid job!")
		return
	end

	-- Get/check rank.
	local rank = args[2] and job:GetRankByHash(GetHashKey(args[2]:lower()))
	if not rank then
		cb("error", "Invalid rank! "..json.encode(job.Ranks))
		return
	end
	
	-- Get/check target.
	local target = tonumber(args[3]) or source
	if not target or target == 0 or target < -1 or not exports.character:IsSelected(target) then
		cb("error", "Invalid target!")
		return
	end

	-- Set rank.
	local retval, result = Main:SetRank(target, jobId, rank.Hash)
	if retval then
		cb("success", ("Set [%s]'s rank in '%s' to '%s'!"):format(target, jobId, rank.Name))

		exports.log:Add({
			source = source,
			target = target,
			verb = "set",
			noun = "rank",
			extra = ("%s - %s"):format(jobId, rank.Name),
		})
	else
		cb("error", ("Couldn't set [%s]'s rank (%s)!"):format(target, result or "?"))
	end
end, {
	description = "Set's the rank of somebody's job.",
	parameters = {
		{ name = "Job", description = "Use the job's id." },
		{ name = "Rank", description = "What rank to hire them as? Default is the lowest rank." },
		{ name = "Target", description = "Who you are setting the rank for. Default = you." },
	}
}, "Admin")

exports.chat:RegisterCommand("a:jobhire", function(source, args, command, cb)
	HireOrFire(source, args, cb, true)
end, {
	description = "Hire any person to any job.",
	parameters = {
		{ name = "Job", description = "Use the job's id." },
		{ name = "Target", description = "Who you are hiring. Default = you." },
		{ name = "Rank", description = "What rank to hire them as? Default is the lowest rank." },
	}
}, "Admin")

exports.chat:RegisterCommand("a:jobfire", function(source, args, command, cb)
	HireOrFire(source, args, cb, false)
end, {
	description = "Fire any person from any job.",
	parameters = {
		{ name = "Job", description = "Use the job's id." },
		{ name = "Target", description = "Who you are firing. Default = you." },
	}
}, "Admin")

exports.chat:RegisterCommand("fingerprint", function(source, args, rawCommand)
	if not exports.jobs:IsInEmergency(source) then
		TriggerClientEvent("chat:addMessage", source, { class = "emergency", text = "You must be on duty!" })
		return
	end

	local target = tonumber(args[1])
	if not target then return end

	local character = exports.character:GetCharacter(target)
	if not character then return end

	local message = ("[%s] comes back to %s %s, %s."):format(target, character.first_name, character.last_name, character.license_text)
	TriggerClientEvent("chat:addMessage", source, { class = "emergency", text = message })
end, {
	description = "",
	parameters = {
		{ name = "Target", help = "ID of the target." },
	}
})

exports.chat:RegisterCommand("doa", function(source, args, rawCommand)
	if not exports.jobs:IsInEmergency(source) then
		TriggerClientEvent("chat:addMessage", source, { class = "emergency", text = "You must be on duty!" })
		return
	end

	local target = tonumber(args[1])
	local character = exports.character:GetCharacter(target or 0)
	
	if not character then
		TriggerClientEvent("chat:addMessage", source, { class = "emergency", text = "Invalid target!" })
		return
	end

	exports.interact:SendConfirm(source, target, "You are being reported dead", function(response)
		if response then
			exports.character:Kill(target)

			TriggerClientEvent("chat:addMessage", source, "They are dead now.")
		else
			TriggerClientEvent("chat:addMessage", source, "They declined the DOA.")
		end
	end, true)

	-- TriggerClientEvent("chat:addMessage", source, message, "emergency")
end, {
	description = "Send a confirmation to kill somebody.",
	parameters = {
		{ name = "Target", help = "Person to report dead." },
	}
})

exports.chat:RegisterCommand("callsign", function(source, args, command)
	local sign = args[1]
	if not sign or sign == "" then return end

	sign = string.upper(sign)

	if not Main:IsInGroup(source, "emergency") then
		TriggerClientEvent("chat:notify", source, { class = "error", text = "You must be on duty!" })
		return
	end

	local job = Main:GetCurrentJob(source)
	if not job then
		TriggerClientEvent("chat:notify", source, { class = "error", text = "You need to be clocked in!" })
		return
	end

	if not (string.find(sign, "^[A-Z][A-Z]") or string.find(sign, "^[A-Z][-]%d%d$") or string.find(sign, "^[A-Z][A-Z][-]%d%d$") or string.find(sign, "^[123569]%d%d$")) then
		TriggerClientEvent("chat:notify", source, { class = "error", text = "Improper callsign. Formatting allowed: [AA-ZZ], [A-Z/AA-ZZ]-##, or [1,2,3,5,6,9]##" })
		return
	end

	local characterId = exports.character:Get(source, "id")
	if not characterId then
		TriggerClientEvent("chat:notify", source, { class = "error", text = "Failed to set callsign!" })
		return
	end

	local success = exports.factions:UpdateFaction(characterId, job.Faction, job.Group, "callsign", sign, true)

	if success then
		TriggerClientEvent("chat:notify", source, { class = "success", text = "Callsign successfully changed to: "..sign })

		-- Log the event.
		exports.log:Add({
			source = source,
			verb = "changed",
			noun = "callsign to",
			extra = sign,
		})
	else
		TriggerClientEvent("chat:notify", source, { class = "error", text = "Unable to set callsign!" })
	end

end, {
	description = "Change your Emergency callsign.",
	parameters = {
		{ name = "Callsign", help = "Accepted Formats: [AA-ZZ], [A-Z/AA-ZZ]-##, or [1,2,3,5,6,9]##" },
	}
})

exports.chat:RegisterCommand("rollcall", function(source, args, command)
	local job = Main:GetCurrentJob(source)

	if not job or job == "" then 
		TriggerClientEvent("notify:sendAlert", source, "error", "You must be on duty!")
		return
	end

	if not Main:IsInGroup(source, "emergency") and string.match(job, "staff") ~= "staff" then
		TriggerClientEvent("notify:sendAlert", source, "error", "You must be on duty!")
		return
	end

	local categories = {}
	local count = 0

	for _, player in ipairs(GetPlayers()) do
		local currentPlayer = tonumber(player)
		if Main:IsInGroup(currentPlayer, "emergency") then
			local character = exports.character:GetCharacter(currentPlayer)
			local job = Main:GetCurrentJob(currentPlayer)
			if job == "staffteam" then goto continue end
g
			local faction = exports.factions:Get(currentPlayer, job.Faction, job.Group)
			if not faction then goto continue end

			local extra = faction and faction.fields and faction.fields.callsign
			
			local category = job.Name
			local output = categories[category]
			if not output then
				output = ""
			end
			if output ~= "" then
				output = output.."<br>"
			end
			if extra then
				output = output..extra.." - "..character.first_name.." "..character.last_name
			else
				output = output..character.first_name.." "..character.last_name
			end
			categories[category] = output
			count = count + 1
			::continue::
		end
	end

	local output = "Active Emergency Personnel:"
	for category, text in pairs(categories) do
		if output ~= "" then
			output = output.."<br><br>"
		end
		output = output.."<span style='font-weight: 800; font-size: 90%; text-decoration: underline'>"..category.."</span><br>"..text
	end

	TriggerClientEvent("notify:persistentAlert", source, "START", "onduty", "inform", output, false, true)

end, {
	description = "Lists all clocked on Emergency Services.",
	parameters = {
}
})