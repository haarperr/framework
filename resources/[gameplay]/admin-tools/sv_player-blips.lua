--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		for i = 0, GetNumPlayerIndices() - 1 do
			local player = tonumber(GetPlayerFromIndex(i))
			if not exports.trackers:IsInGroup(player, "admin") then
				exports.trackers:AddToGroup(player, "admin", true, "player", GetPlayerName(player))
			end
		end
		Citizen.Wait(5000)
	end
end)

--[[ Events ]]--
RegisterNetEvent("admin-tools:toggleBlips")
AddEventHandler("admin-tools:toggleBlips", function(toggle)
	local source = source
	if type(toggle) ~= "boolean" then return end

	exports.log:Add({
		source = source,
		verb = "toggled",
		noun = "player blips",
		extra = tostring(toggle),
		channel = "admin",
	})

	if toggle then
		exports.trackers:AddToGroup(source, "admin", false, "player", GetPlayerName(source))
	else
		exports.trackers:AddToGroup(source, "admin", true, "player", GetPlayerName(source))
	end
end)