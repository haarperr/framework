local Cache = {}
local Jobs = { "LSSD", "DPS", "LSPD", "Detective", "Paramedic", "Doctor", "Lawyer", "Judge", "DOC", "Mechanic", "Taxi Driver" }
local Cooldowns = {}

RegisterNetEvent("interaction:stare")
AddEventHandler("interaction:stare", function()
	local source = source
	
	if Cache[source] and os.time() - Cache[source] < 30.0 then
		return
	end

	Cache[source] = os.time()

	exports.log:Add({
		source = source,
		verb = "stared",
	})
end)

RegisterNetEvent("interaction:requestJobs")
AddEventHandler("interaction:requestJobs", function()
	local source = source

	if os.clock() - (Cooldowns[source] or 0.0) < 1.0 then
		TriggerClientEvent("interaction:receiveJobs", source, {})
		return
	end

	Cooldowns[source] = os.clock()
	
	local jobs = { { "Population", GetNumPlayerIndices() } }

	for k, v in ipairs(Jobs) do
		jobs[k + 1] = { v, exports.jobs:CountActiveDuty(v) }
	end

	TriggerClientEvent("interaction:receiveJobs", source, jobs)
end)