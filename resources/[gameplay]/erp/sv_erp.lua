Players = {}
Enabled = false

--[[ Events ]]--
RegisterNetEvent("erp:startSex")
AddEventHandler("erp:startSex", function(target)
	local source = source
	if not Enabled then return end

	local role = 1

	local targetPlayer = Players[target]
	if targetPlayer then
		if targetPlayer.target == source then
			role = 2
		else
			return
		end
	end

	Players[source] = { target = target, role = role }
	
	if targetPlayer and targetPlayer.target == source then
		TriggerClientEvent("erp:startSex", source, role)
		TriggerClientEvent("erp:startSex", target, targetPlayer.role)
	end
end)

RegisterNetEvent("erp:stopSex")
AddEventHandler("erp:stopSex", function()
	local source = source
	if not Enabled then return end

	local player = Players[source]

	if not player then return end

	if player.target then
		TriggerClientEvent("erp:stopSex", player.target)
		Players[player.target] = nil
	end
	
	Players[source] = nil
end)

RegisterNetEvent("erp:changePosition")
AddEventHandler("erp:changePosition", function(position)
	local source = source
	if not Enabled then return end

	local player = Players[source]

	if not player or type(position) ~= "number" then return end

	if player.target then
		TriggerClientEvent("erp:changePosition", player.target, position)
	end
	
	TriggerClientEvent("erp:changePosition", source, position)
end)

RegisterNetEvent("erp:enter")
AddEventHandler("erp:enter", function()
	local source = source

	if exports.instances:DoesInstanceExist(Config.Instance) then
		exports.instances:JoinInstance(Config.Instance, source)
	else
		exports.instances:CreateInstance(Config.Instance, {
			inCoords = vector4(-1569.4666748046875, -3017.457275390625, -74.40612030029297, 358.1445922851563),
			outCoords = vector4(-576.9678344726562, 239.3473358154297, 82.63858032226562, 353.163818359375),
		}, source)
	end
end)