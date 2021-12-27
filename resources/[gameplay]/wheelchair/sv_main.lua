Main = Main or {}
Main.vehicles = {}

--[[ Functions ]]--
function Main:Activate(source, siteId)
	local site = Config.Sites[siteId or false]
	if not site then return false end

	local coords = site.Spawn
	if not coords then return false end

	local vehicle = CreateVehicle(Config.Model, coords.x, coords.y, coords.z, coords.w, true, true)

	self.vehicles[vehicle] = true

	return true
end

--[[ Events ]]--
AddEventHandler("entityRemoved", function(entity)
	if not entity then return end
	
	Main.vehicles[entity] = nil
end)

--[[ Events: Net ]]--
RegisterNetEvent(Main.event.."spawn", function(siteId)
	local source = source

	if type(siteId) ~= "number" then return end

	if Main:Activate(source, siteId) then
		exports.log:Add({
			source = source,
			verb = "spawned",
			noun = "wheelchair",
		})
	end
end)

RegisterNetEvent(Main.event.."store", function(netId)
	if type(netId) ~= "number" then return end

	local vehicle = NetworkGetEntityFromNetworkId(netId)
	if not vehicle or not DoesEntityExist(vehicle) or not Main.vehicles[vehicle] then return end

	DeleteEntity(vehicle)

	exports.log:Add({
		source = source,
		verb = "stored",
		noun = "wheelchair",
	})
end)