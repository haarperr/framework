AppHooks["jobs"] = function(content)
	local factions = exports.character:Get("factions")

	for k, v in pairs(factions) do
		local job = exports.jobs:GetJob(k)
		if job then
			for _k, rank in pairs(job.Ranks) do
				if rank == v.level then
					v.rank = _k
					break
				end
			end
			v.isOnDuty = exports.jobs:IsOnDuty(k)
			factions[k].job = job
		else
			factions[k] = nil
		end
	end
	
	local payload = {
		factions = factions
	}
	
	return payload
end

RegisterNUICallback("jobClock", function(data)
	TriggerServerEvent("jobs:tryClock", data.id, data.value)
end)

RegisterNUICallback("jobInfo", function(data)
	local name = data.id
	-- TriggerServerEvent("jobs:requestInfo", name)
	local job = exports.jobs:GetJob(name)
	
	LoadApp("jobs-info", { job = job }, true)
end)

RegisterNetEvent("jobs:clock")
AddEventHandler("jobs:clock", function(name, message)
	if message ~= true and message ~= false then return end

	LoadApp("jobs", { clock = { name = name, message = message } }, false)
end)