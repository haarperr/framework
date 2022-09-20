--[[ Functions: Main ]]--
function Main:OnRegister(job)
	if job.Clocks then
		job:RegisterClocks(job.Clocks)
	end
end

function Main:GetActiveJobs(getJob)
	local factions = exports.factions:GetFactions()
	local jobs = {}
	
	for id, job in pairs(self.jobs) do
		local faction = factions[job.Faction]
		local level = faction and faction[job.Group or ""]

		if level then
			jobs[id] = getJob and job or level
		end
	end

	return jobs
end

function Main:GetCurrentJob(getJob)
	local id = LocalPlayer.state.job
	if not id then return end

	if getJob then
		return self.jobs[id]
	end

	return id
end

function Main:IsInEmergency(attribute)
	local id = LocalPlayer.state.job
	if not id then return end

	local job = self.jobs[id]
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

function Main:HasEmergency()
	local jobs = self:GetActiveJobs()
	for id, job in pairs(jobs) do
		local jobInfo = self.jobs[id]
		if jobInfo and jobInfo.Emergency then
			return true
		end
	end
	return false
end

function Main:IsInGroup(group)
	local id = LocalPlayer.state.job
	if not id then return end

	local job = self.jobs[id]
	if not job then return end

	if job.Tracker then
		return job.Tracker.Group == group
	end

	return false
end

function Main:IsInFaction(faction)
	local id = LocalPlayer.state.job
	if not id then return end

	local job = self.jobs[id]
	if not job then return end

	return job.Faction == faction
end

function Main:GetRank(id)
	local job = self.jobs[id]
	if not job then return end

	local faction = exports.factions:Get(job.Faction, job.Group)
	if not faction then return end

	return job:GetRankByHash(faction.level, true)
end

function Main:GetRankByHash(id, hash, getName)
	local job = self.jobs[id]
	if not job then return end

	local rank = job:GetRankByHash(hash, true)

	return rank and getName and rank.Name or rank
end

--[[ Functions: Job ]]--
function Job:RegisterClocks(clocks)
	local job = self

	self.clockEntities = {}

	for k, clock in ipairs(clocks) do
		self.clockEntities[k] = exports.entities:Register({
			id = "clock-"..self.id..k,
			name = "Clock ("..self.id..")",
			coords = clock.Coords,
			radius = clock.Radius,
			navigation = {
				icon = "work",
				text = "Clock",
				job = self.id,
				clock = k,
			},
			condition = function(self)
				return job.IsPublic or job:IsHired()
			end,
		})
	end
end

function Job:IsHired()
	return exports.factions:Has(self.Faction, self.Group)
end

--[[ Events ]]--
AddEventHandler("interact:onNavigate", function(id, option)
	if not option.job and not option.clock then return end

	TriggerServerEvent("jobs:clock", option.job)
end)

--[[ Exports ]]--
exports("GetActiveJobs", function(...)
	return Main:GetActiveJobs(...)
end)

exports("GetRank", function(...)
	return Main:GetRank(...)
end)

exports("GetCurrentJob", function(...)
	return Main:GetCurrentJob(...)
end)

exports("GetRankByHash", function(...)
	return Main:GetRankByHash(...)
end)

exports("IsInEmergency", function(...)
	return Main:IsInEmergency(...)
end)

exports("IsInFaction", function(...)
	return Main:IsInFaction(...)
end)

exports("HasEmergency", function(...)
	return Main:HasEmergency(...)
end)

exports("IsInGroup", function(...)
	return Main:IsInGroup(...)
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("a:jobs", function(source, args, command, cb)
	local output = ""

	for id, job in pairs(Main.jobs) do
		if output ~= "" then
			output = output..", "
		end
		output = output.."'"..id.."'"
	end

	TriggerEvent("chat:addMessage", "Jobs: "..output)
end, {
	description = "Look at all the jobs.",
}, "Admin")

-- Panic Button
RegisterCommand("panic", function(source, args, command)
	local state = LocalPlayer.state or {}
	if
		not exports.jobs:GetCurrentJob(source, "pd", "federal", "ems")
		or state.restrained
	then
		TriggerEvent("chat:notify", { class = "error", text = "You can't do that right now!" })
		return
	end

	exports.mythic_progbar:Progress(Config.Panic, function(wasCancelled)
		if wasCancelled then return end
		TriggerServerEvent("jobs:togglePanic")
	end)
end)
