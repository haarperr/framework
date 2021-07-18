RegisterNetEvent("health:checkIn")
AddEventHandler("health:checkIn", function(target, value)
	local source = source

	if not source then return end
	if target and (type(target) ~= "number" or target <= 0 or not DoesEntityExist(GetPlayerPed(target))) then return end
	
	if target then
		exports.log:Add({
			source = source,
			target = target,
			verb = "checked in",
		})
		
		local currentJob = exports.jobs:GetCurrentJob(source, true)
		local checkIn = ((currentJob or {}).Emergency or {}).CheckIn
		if checkIn then
			TriggerClientEvent("health:checkIn", target)
			if checkIn ~= 2 then
				exports.character:AddBank(source, Config.Beds.Payout, true)
				exports.log:AddEarnings(source, "Checked In", Config.Beds.Payout)
			end
		end
	else
		local cost = Config.Beds.MaxCost
		if type(value) == "number" then
			cost = math.max(math.floor(cost * math.min(value / 10.0, 1.0)), 1)
		end
		
		exports.log:Add({
			source = source,
			verb = "checked in",
			extra = ("cost: $%s"):format(cost),
		})
		
		exports.character:AddBank(source, -cost, true)
		exports.log:AddEarnings(source, "Medical", -cost)
	end
end)
