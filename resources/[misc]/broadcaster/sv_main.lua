RegisterNetEvent("broadcaster:toggle", function(stationId)
	local source = source

	local station = Config.Stations[stationId]
	if not station then
		return
	end

	local id = "broadcaster"..stationId
	local state = not GlobalState[id]
	GlobalState[id] = state

	exports.log:Add({
		source = source,
		verb = state and "enabled" or "disabled",
		noun = "broadcast",
	})
end)

RegisterNetEvent("broadcaster:setState", function(slotId, key, value)
	local source = source

	-- TODO: update item.
end)