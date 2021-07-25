RegisterNetEvent(Admin.event.."requestPlayer", function(serverId)
	local source = source

	if (exports.user:Get(source, "power_level") or 0) < 25 then return end

	data = {
		name = exports.character:GetName(serverId),
	}

	TriggerClientEvent(Admin.event.."receivePlayer", source, serverId, data)
end)