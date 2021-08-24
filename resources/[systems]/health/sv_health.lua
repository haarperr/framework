Main = {
	cooldowns = {},
}

--[[ Functions: Main ]]--
function Main:Save(source, data)
	exports.character:Set(source, "health", data)
end

--[[ Events ]]--
AddEventHandler("playerDropped", function(reason)
	local source = source
	Main.cooldowns[source] = nil
end)

RegisterNetEvent("health:sync", function(data)
	local source = source

	-- Check cooldown.
	local cooldown = Main.cooldowns[source]
	if cooldown and os.clock() - cooldown < Config.Saving.Cooldown * 0.99 / 1000.0 then
		return
	end

	-- Update cooldown.
	Main.cooldowns[source] = os.clock()

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