CombatCache = {}

--[[ Commands ]]--
exports.chat:RegisterCommand("a:revive", function(source, args, command)
	local source = source
	local target = args[1] or source
	if target == "*" then
		target = -1
	else
		target = tonumber(target)
	end
	-- TODO.
	TriggerClientEvent("health:revive", target)
	
	-- Log the event.
	exports.log:Add({
		source = source,
		target = target,
		verb = "revived",
		channel = "admin",
	})

end, {
	description = "Cause another person to resurrect from the (temproary) dead.",
	powerLevel = 25,
	parameters = {
		{ name = "Target", description = "The player you want to revive." },
	},
})

exports.chat:RegisterCommand("a:slay", function(source, args, command)
	local target = args[1] or source
	target = tonumber(target)
	-- TODO.
	TriggerClientEvent("health:slay", target)
	
	-- Log the event.
	exports.log:Add({
		source = source,
		target = target,
		verb = "slayed",
		channel = "admin",
	})
end, {
	description = "Cause another person to die.",
	powerLevel = 25,
	parameters = {
		{ name = "Target", description = "The player you want to slay." },
	},
})

--[[ Events ]]--
RegisterNetEvent("health:heal")
AddEventHandler("health:heal", function(target, partial, slotId)
	local source = source
	if not source then return end

	target = tonumber(target)
	if not target or target <= 0 then return end

	local slot = exports.inventory:GetSlot(source, slotId, true)
	if not slot or exports.inventory:GetItem(slot[1]).name ~= "Medical Bag" then return end

	exports.inventory:DecayItem(source, slotId, 0.01, true)

	if partial ~= nil and type(partial) ~= "boolean" then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "healed",
	})

	TriggerClientEvent("health:heal", target, partial)
end)

RegisterNetEvent("health:requestInjuries")
AddEventHandler("health:requestInjuries", function(target)
	local source = source
	if not source then return end

	target = tonumber(target)
	if not target then return end

	TriggerClientEvent("health:requestInjuries", target, source)
end)

RegisterNetEvent("health:sendInjuries")
AddEventHandler("health:sendInjuries", function(info, target)
	local source = source
	if not source then return end

	target = tonumber(target)
	if not target then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "sent",
		noun = "injuries",
	})

	TriggerClientEvent("health:receiveInjuries", target, source, info)
end)

RegisterNetEvent("health:beginCombat")
AddEventHandler("health:beginCombat", function(target, weaponHash)
	local source = source
	if type(target) ~= "number" then return end

	local cache = CombatCache[source]
	if cache then
		for k, v in ipairs(cache) do
			local delta = os.time() - v.time
			if delta >= 60 then
				cache[k] = nil
			elseif v.target == target and delta < 60 then
				v.time = os.time()
				return
			end
		end
	else
		cache = {}
		CombatCache[source] = cache
	end

	table.insert(cache, {
		time = os.time(),
		target = target,
	})

	exports.log:Add({
		source = source,
		target = target,
		verb = "started",
		noun = "combat",
		extra = ("weapon: %s"):format(exports.weapons:GetName(weaponHash) or "?"),
	})
end)

RegisterNetEvent("health:respawned")
AddEventHandler("health:respawned", function()
	local source = source

	exports.log:Add({
		source = source,
		verb = "respawned",
	})
	
	if exports.jobs:CountActiveDuty("paramedic") >= 2 then
		exports.inventory:ClearItems(exports.inventory:GetPlayerContainer(source))
		exports.inventory:GiveItem(source, "Mobile Phone")
	end
end)

RegisterNetEvent("health:killed")
AddEventHandler("health:killed", function(weaponHash, killer)
	local source = source
	local weapon = exports.weapons:GetName(weaponHash) or "?"
	if type(killer) == "number" then
		exports.log:Add({
			source = source,
			target = killer,
			verb = "killed",
			extra = ("weapon: %s"):format(weapon),
			switch = true,
		})
	else
		exports.log:Add({
			source = source,
			verb = "died",
			extra = ("weapon: %s"):format(weapon),
		})
	end
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	CombatCache[source] = nil
end)