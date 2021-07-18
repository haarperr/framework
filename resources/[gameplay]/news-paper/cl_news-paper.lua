NearestStand = 0
LastCoords = vector3(0.0, 0.0, 0.0)
IsOpen = false

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		
		if IsOpen then
			if IsDisabledControlJustPressed(0, 51) then
				SendNUIMessage({ display = false })
				IsOpen = false
				Citizen.Wait(1000)
			end
		elseif NearestStand and DoesEntityExist(NearestStand) and #(pedCoords - GetEntityCoords(NearestStand)) < Config.Distance then
			local stand = Config.Models[ModelsCache[GetEntityModel(NearestStand)]]
			local coords = GetEntityCoords(NearestStand)
			if exports.oldutils:DrawContext(Config.Text, coords + stand.Offset) then
				SendNUIMessage({ display = true })
				IsOpen = true
			end
		else
			LastCoords = pedCoords
			NearestStand = nil
			local objects = exports.oldutils:GetObjects()
			local nearestDist = 0.0
			for k, v in ipairs(objects) do
				if ModelsCache[GetEntityModel(v)] then
					local dist = #(pedCoords - GetEntityCoords(v))
					if not NearestStand or dist < nearestDist then
						NearestStand = v
						nearestDist = dist
					end
				end
			end
			Citizen.Wait(1000)
		end
		Citizen.Wait(0)
	end
end)