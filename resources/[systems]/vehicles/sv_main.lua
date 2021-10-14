Main.vehicles = {}
Main.vinCache = {}

--[[ Functions: Main ]]--
function Main:Spawn(model, coords, heading, info)
	local entity = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)
	
	if info then
		while not DoesEntityExist(entity) do
			Citizen.Wait(0)
		end

		local netId = NetworkGetNetworkIdFromEntity(entity)
		local vehicle = Vehicle:Create(netId, info)
	end

	return entity
end

function Main:Enter(source, netId)
	local vehicle = self.vehicles[netId]
	if not vehicle then
		vehicle = Vehicle:Create(netId)
	end

	vehicle:Subscribe(source, true)

	exports.log:Add({
		source = source,
		verb = "entered",
		noun = "vehicle",
		extra = vehicle:Get("vin"),
	})
end

function Main:GetUniqueVin()
	local vin

	while true do
		vin = GetRandomText(17, UpperCase, Numbers)

		if not self.vinCache[vin] then
			break
		else
			Citizen.Wait(0)
		end
	end

	self.vinCache[vin] = true

	return vin
end

--[[ Events ]]--
AddEventHandler("entityCreated", function(entity)
	if not entity or not DoesEntityExist(entity) then return end

	-- Do something with vehicle when created?
end)

AddEventHandler("entityRemoved", function(entity)
	if not entity then return end
	
	local netId = NetworkGetNetworkIdFromEntity(entity)
	local vehicle = Main.vehicles[netId or false]
	if vehicle then
		vehicle:Destroy()
	end
end)

--[[ Events: Net ]]--
RegisterNetEvent("vehicles:enter", function(netId)
	local source = source

	if type(netId) ~= "number" then return end

	Main:Enter(source, netId)
end)

RegisterNetEvent("vehicles:subscribe", function(netId, value)
	local source = source
	value = value == true

	if type(netId) ~= "number" then return end
	
	local vehicle = Main.vehicles[netId]
	if vehicle then
		vehicle:Subscribe(source, value)
	end
end)