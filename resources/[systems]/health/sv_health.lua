Main = {
	history = {},
	players = {},
}

--[[ Functions: Main ]]--
function Main:Save(source, data)
	exports.character:Set(source, "health", data)
end

function Main:Subscribe(source, target, value)
	local health = nil
	local player = self.players[target]

	if value then
		-- Get health.
		health = exports.character:Get(target, "health")
		if not health then
			return false
		end

		-- Create player.
		if not player then
			player = {}
			self.players[target] = player
		end
	elseif not player then
		return false
	end

	player[source] = value == true or nil

	if value then
		TriggerClientEvent("health:sync", source, target, health)
	else
		local next = next
		if next(player) == nil then
			self.players[target] = nil
		end
	end

	return true
end

--[[ Events ]]--
AddEventHandler("playerDropped", function(reason)
	local source = source

	Main.history[source] = nil
	Main.players[source] = nil
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

	-- Inform viewers.
	local player = Main.players[source]
	if player then
		for viewer, _ in pairs(player) do
			TriggerClientEvent("health:sync", viewer, source, data)
		end
	end

	-- Save.
	Main:Save(source, data)
end)

RegisterNetEvent("health:subscribe", function(target, value)
	local source = source

	-- Check input.
	if type(value) ~= "boolean" or type(target) ~= "number" or target <= 0 then return end

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0) then return end
	PlayerUtil:UpdateCooldown(source)

	-- Subscribe.
	if Main:Subscribe(source, target, value) and value then
		exports.log:Add({
			source = source,
			target = target,
			verb = "examined",
		})
	end
end)

RegisterNetEvent("health:damageBone", function(boneId, amount, name)
	local source = source

	if type(amount) ~= "number" or (name and not Config.Injuries[name]) then return end
	
	local bone = Config.Bones[boneId or false]
	if not bone then return end

	local history = Main.history[source]
	if not history then
		history = {}
		Main.history[source] = history
	end

	table.insert(history, 1, {
		time = GetGameTimer(),
		bone = boneId,
		amount = amount,
		name = name,
	})

	if #history > 512 then
		table.remove(history, #history)
	end
end)

RegisterNetEvent("health:treat", function(target, groupName, treatmentName)
	local source = source

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0) then return end
	PlayerUtil:UpdateCooldown(source)
	
	-- Check types.
	target = target or source

	if type(target) ~= "number" or type(groupName) ~= "string" or type(treatmentName) ~= "string" then return end

	-- Check player.
	if source ~= target and not Main.players[target] then
		return
	end

	-- Check group.
	if not Config.Groups[groupName] then
		return
	end

	-- Check treatment.
	if not Config.Treatment.Options[treatmentName] then
		return
	end

	-- Broadcast.
	exports.players:Broadcast(target, "health:treat", target, groupName, treatmentName)
end)