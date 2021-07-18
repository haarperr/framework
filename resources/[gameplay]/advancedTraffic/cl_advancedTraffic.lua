Cache = {}
NearbyLights = {}

--[[ Initialization ]]--
for k, trafficLight in ipairs(Config.TrafficLights) do
	Cache[GetHashKey(trafficLight.Model)] = k
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		for object, trafficLight in pairs(NearbyLights) do
			if DoesEntityExist(object) then
				SetEntityTrafficlightOverride(object, 0)
			else
				NearbyLights[object] = nil
			end
		end
	end
end)

--[[ Grids ]]--
AddEventHandler("grids:enter1", function(grid, nearbyGrids)
	local objects = exports.oldutils:GetObjects()
	for _, object in ipairs(objects) do
		local key = Cache[GetEntityModel(object)]
		if key then
			NearbyLights[object] = Config.TrafficLights[key]
		end
	end
end)