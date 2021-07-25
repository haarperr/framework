RegisterNetEvent(Admin.event.."requestPlayer", function(serverId)
	local source = source
	print("req", source, serverId)

	data = {
		name = exports.character:Get(serverId, "first_name"),
	}

	TriggerClientEvent(Admin.event.."receivePlayer", source, serverId, data)
end)