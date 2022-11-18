Main.containers = {}
Main.currentTrunk = nil

AddEventHandler("vehicle:loaded", function(source, vehicle, entity, class)
	if entity == nil or not DoesEntityExist(entity) then return end

	local netId = NetworkGetNetworkIdFromEntity(entity)
	if not netId then return end

	local trunk = exports.inventory:LoadContainer({
		type = "trunk",
		sid = "t"..vehicle.id,
		entity = entity
	}, true)

	local glovebox = exports.inventory:LoadContainer({
		type = "glovebox",
		sid = "g"..vehicle.id
	}, true)
	
	Main.containers[netId] = {
		glovebox = glovebox.id,
		trunk = trunk.id,
	}
end)

RegisterNetEvent("vehicles:openTrunk", function(vehicle)
	if Main.containers[vehicle] then
		exports.inventory:Subscribe(source, Main.containers[vehicle].trunk, true)
		TriggerClientEvent("inventory:toggle", source, true)
		TriggerClientEvent("vehicles:inTrunk", source, vehicle, Main.containers[vehicle].trunk)
	else
		local trunk = exports.inventory:LoadContainer({
			type = "trunk",
			temporary = true
		}, true)
	
		local glovebox = exports.inventory:LoadContainer({
			type = "glovebox",
			temporary = true
		}, true)
		Main.containers[vehicle] = {
			glovebox = glovebox.id,
			trunk = trunk.id,
		}

		exports.inventory:Subscribe(source, Main.containers[vehicle].trunk, true)
		TriggerClientEvent("inventory:toggle", source, true)
		TriggerClientEvent("vehicles:inTrunk", source, vehicle, Main.containers[vehicle].trunk)
	end
end)

RegisterNetEvent("vehicles:openGlovebox", function(vehicle)
	if Main.containers[vehicle] then
		exports.inventory:Subscribe(source, Main.containers[vehicle].glovebox, true)
		TriggerClientEvent("inventory:toggle", source, true)
		TriggerClientEvent("vehicles:inGlovebox", source, vehicle, Main.containers[vehicle].glovebox)
	else
		local trunk = exports.inventory:LoadContainer({
			type = "trunk",
			temporary = true
		}, true)
	
		local glovebox = exports.inventory:LoadContainer({
			type = "glovebox",
			temporary = true
		}, true)
		Main.containers[vehicle] = {
			glovebox = glovebox.id,
			trunk = trunk.id,
		}

		exports.inventory:Subscribe(source, Main.containers[vehicle].glovebox, true)
		TriggerClientEvent("inventory:toggle", source, true)
		TriggerClientEvent("vehicles:inGlovebox", source, vehicle, Main.containers[vehicle].glovebox)
	end
end)