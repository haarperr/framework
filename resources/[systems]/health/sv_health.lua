Main = {
	history = {},
}

--[[ Functions: Main ]]--
function Main:Save(source, data)
	exports.character:Set(source, "health", data)
end

--[[ Events ]]--
AddEventHandler("playerDropped", function(reason)
	local source = source

	Main.history[source] = nil
end)

--[[ Events: Net ]]--
RegisterNetEvent("health:sync", function(data)
	local source = source

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, Config.Saving.Cooldown * 0.99 / 1000.0) then return end
	PlayerUtil:UpdateCooldown(source)

	-- Check player is loaded.
	if not exports.character:IsSelected(source) then
		return
	end

	-- Check payload is valid.
	local result, retval = IsPayloadValid(data)
	if not result then
		print(("[%s] sent an invalid payload! (%s)"):format(source, retval or ""))
		return
	end

	-- Save.
	Main:Save(source, data)
end)

RegisterNetEvent("health:subscribe", function(target, value)
	local source = source

	if type(value) ~= "boolean" or type(target) ~= "number" or target <= 0 then return end

	Main:Subscribe(source, target, value)
end)

RegisterNetEvent("health:damageBone", function(boneId, amount)
	local source = source

	if type(amount) ~= "number" then return end
	
	local bone = Config.Bones[boneId or false]
	if not bone then return end

	print(source, boneId, amount)
	
	local history = Main.history[source]
	if not history then
		history = {}
		Main.history[source] = history
	end

	table.insert(history, 1, {
		time = GetGameTimer(),
		bone = boneId,
		amount = amount,
	})

	if #history > 1000 then
		table.remove(history, #history)
	end
end)