Cams = {}
Players = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		for siteId, site in ipairs(Config.Sites) do
			local cam = Cams[siteId]
			if not cam then goto continue end
			
			local info = cam.info
			if not info then goto continue end

			if info.target then
				info.position = info.target
				info.target = nil
			end
			for viewer, _ in pairs(cam.viewers) do
				TriggerClientEvent("satCam:update", viewer, info)
			end

			::continue::
		end
		Citizen.Wait(1000)
	end
end)

--[[ Events ]]--
RegisterNetEvent("satCam:subscribe")
AddEventHandler("satCam:subscribe", function(id, subscribe)
	local source = source
	local cam = Cams[id]
	if not cam then return end

	local lastId = Players[source]
	if lastId then
		Cams[lastId].viewers[source] = nil
		Players[source] = nil
	end

	if not subscribe then return end

	Players[source] = id
	cam.viewers[source] = true

	TriggerClientEvent("satCam:update", source, cam.info)
end)

RegisterNetEvent("satCam:setCoords")
AddEventHandler("satCam:setCoords", function(id, coords)
	local source = source
	if not id then return end

	local cam = Cams[id]
	if not cam or Players[source] ~= id or type(coords) ~= "vector3" then return end

	cam.info.target = { coords.x, coords.y }
end)

AddEventHandler("satCam:start", function()
	local seed = os.time()

	for siteId, site in ipairs(Config.Sites) do
		math.randomseed(seed)
		seed = math.random(-2147483648, 2147483648)

		local x = math.random(Config.HorizontalRange[1], Config.HorizontalRange[2])
		local y = math.random(Config.VerticalRange[1], Config.VerticalRange[2])

		Cams[siteId] = {
			info = {
				position = { x, y },
			},
			viewers = {},
		}
	end
end)