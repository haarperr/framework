Playbacks = {}

--[[ Events ]]--
RegisterNetEvent("playback:request")
AddEventHandler("playback:request", function(coords, time)
	local source = source
	if not Playbacks[source] then return end

	if type(coords) ~= "vector3" then return end
	if type(time) ~= "number" then return end

	local result = exports.GHMattiMySQL:QueryResult([[
		SELECT * FROM logs
		WHERE
			is_sensitive = 0 AND
			time_stamp > DATE_ADD(FROM_UNIXTIME(0), INTERVAL @time - 45 second) AND
			time_stamp < DATE_ADD(FROM_UNIXTIME(0), INTERVAL @time + 45 second) AND
			ABS(@y - pos_y) < 300.0 AND
			ABS(@x - pos_x) < 300.0
	]], {
		["@time"] = time,
		["@x"] = coords.x,
		["@y"] = coords.y,
	})

	TriggerClientEvent("playback:receive", source, time, result)
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("a:playback", function(source, args, rawCommand)
	local toggle = not Playbacks[source]
	local data

	if toggle then
		data = {
			time = os.time()
		}
	end

	TriggerClientEvent("playback:toggle", source, toggle, data)

	if not toggle then
		Playbacks[source] = nil
	else
		Playbacks[source] = true
	end
end, {
	help = "Rewind time.",
	params = {}
}, -1, 25)