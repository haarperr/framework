RegisterNetEvent("hotwire:finish", function(netId)
	local source = source

	if type(netId) ~= "number" then return end

	local entity = NetworkGetEntityFromNetworkId(netId)
	if not DoesEntityExist(entity) then return end
	
	local state = (Entity(entity) or {}).state
	if not state then return end

	state.hotwired = true
	
	exports.log:Add({
		source = source,
		verb = "hotwired",
		noun = "vehicle",
	})
end)