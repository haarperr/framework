RegisterNetEvent("health:checkIn", function(ratio)
	local source = source

	-- Check input.
	if type(ratio) ~= "number" then return end

	-- Trap for impossible prices.
	if ratio < -0.0 or ratio > 1.0001 then
		exports.user:TriggerTrap(source, true, ("health check-in injection, price ratio is not normalized (%s)"):format(ratio))
		return
	end
	
	-- Try check in.
	local value = false
	if PlayerUtil:CheckCooldown(source, 1.0, true) then
		-- Update value.
		value = true

		-- Log it.
		exports.log:Add({
			source = source,
			verb = "checked in",
		})

		-- TODO: add bill.
	end

	-- Check in player.
	TriggerClientEvent("health:checkIn", source, value)
end)

RegisterNetEvent("health:checkInOther", function(target, npc, bed)
	local source = source
	if not target then return end
	
	-- Try check in.
	local value = false
	if PlayerUtil:CheckCooldown(target, 1.0, true) then
		-- Update value.
		value = true

		-- Log it.
		exports.log:Add({
			source = source,
			target = target,
			verb = "checked in",
		})

		-- TODO: add bill.
	end

	if not value then return end

	-- Cancel the carry.
	TriggerClientEvent("players:carry", source)
	TriggerClientEvent("players:carry", target)

	-- Check in player.
	TriggerClientEvent("health:checkInOther", target, npc, bed)
end)