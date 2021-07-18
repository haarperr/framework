local TimeCache = {}

RegisterNetEvent("interaction:me")
AddEventHandler("interaction:me", function(text, range)
	local source = source
	local lastTime = TimeCache[source]
	if lastTime and os.time() - lastTime < 3 then return end
	TimeCache[source] = os.time()

	if type(range) ~= "number" then return end
	
	if text:len() > 512 or text:gsub("%s+", "") == "" then return end
	
	exports.log:Add({
		source = source,
		verb = "me",
		extra = text,
	})
	
	local nearbyPlayers = exports.grids:GetNearbyPlayers(source)
	for k, player in ipairs(nearbyPlayers) do
		TriggerClientEvent("interaction:me", player, source, text, range)
	end
end)

-- exports.chat:RegisterCommand("me", function(source, args, rawCommand)
-- end, {
-- 	help = "",
-- 	params = {
-- 		{ name = "Text", help = "What are you doing?" },
-- 	}
-- }, -1)