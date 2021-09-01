Main.vehicles = {}

--[[ Functions: Main ]]--
function Main:Spawn(model, coords, heading)
	local entity = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)

	return entity
end

function Main:Enter(source, entity)
	local vehicle = self.vehicles[entity]
	if not vehicle then
		vehicle = Vehicle:Create(entity)
	end

	exports.log:Add({
		source = source,
		verb = "entered",
		noun = "vehicle",
		extra = entity,
	})
end

--[[ Events ]]--
AddEventHandler("entityCreated", function(entity)
	if not entity or not DoesEntityExist(entity) then return end

	math.randomseed(entity)

	Entity(entity).state.locked = math.random() < 0.8
end)

AddEventHandler("entityRemoved", function(entity)
	if not entity then return end

	local vehicle = Main.vehicles[entity]
	if vehicle then
		vehicle:Destroy()
	end
end)

--[[ Events: Net ]]--
RegisterNetEvent("vehicles:enter", function(netId)
	local source = source
	
	local entity = Main:GetEntityFromNetworkId(netId)
	if not entity then return end

	Main:Enter(source, entity)
end)