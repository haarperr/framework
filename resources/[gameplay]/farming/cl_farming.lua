Blips = {}
LastZone = nil
CurrentZone = nil
CurrentZoneId = nil
Harvests = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		CurrentZone = nil
		CurrentZoneId = nil

		for k, zone in ipairs(Config.Zones) do
			if #(pedCoords - zone.Center) < zone.Radius then
				CurrentZoneId = k
				CurrentZone = zone
				break
			end
		end
		
		if LastZone ~= CurrentZoneId then
			ClearBlips()
			TriggerServerEvent("farming:subscribe", CurrentZoneId)
			LastZone = CurrentZoneId
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if CurrentZone and GetVehiclePedIsIn(ped, false) == 0 then
			local pedCoords = GetEntityCoords(ped)

			for k, v in ipairs(Harvests) do
				if #(v[2] - pedCoords) < CurrentZone.CooldownRadius then
					goto skip
				end
			end
			
			local camCoords = GetFinalRenderedCamCoord()
			local camRot = GetFinalRenderedCamRot(0)
			local camForward = exports.misc:FromRotation(camRot + vector3(0, 0, 90))
			local rayTarget = camCoords + camForward * 1000.0
			local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, rayTarget.x, rayTarget.y, rayTarget.z, -1, Ped, 0)
			local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = GetShapeTestResultIncludingMaterial(rayHandle)
			local startId = CurrentZoneId
			
			if materialHash == CurrentZone.Material and #(hitCoords - pedCoords) < Config.UseRange and exports.oldutils:DrawContext("Pick", hitCoords, 1, 70.0) then
				exports.mythic_progbar:Progress(Config.Actions[CurrentZone.Action], function(wasCancelled)
					if wasCancelled then return end
					if startId ~= CurrentZoneId then return end
					TriggerServerEvent("farming:harvest", pedCoords)
				end)
			end
			
			::skip::
		else
			Citizen.Wait(1000)
		end

		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
function AddBlipForHarvest(harvest)
	local blip = AddBlipForRadius(harvest[2].x, harvest[2].y, harvest[2].z, CurrentZone.CooldownRadius)
	SetBlipSprite(blip, 9)
	SetBlipColour(blip, 1)
	SetBlipAlpha(blip, 128)

	Blips[#Blips + 1] = blip
end

function ClearBlips()
	for k, blip in ipairs(Blips) do
		if DoesBlipExist(blip) then
			RemoveBlip(blip)
		end
	end
	Blips = {}
end

--[[ Events ]]--
RegisterNetEvent("farming:sync")
AddEventHandler("farming:sync", function(harvests)
	Harvests =  harvests
	ClearBlips()
	
	local blip = AddBlipForRadius(CurrentZone.Center.x, CurrentZone.Center.y, CurrentZone.Center.z, CurrentZone.Radius * 1.0)
	SetBlipSprite(blip, 9)
	SetBlipColour(blip, 0)
	SetBlipAlpha(blip, 32)
	Blips[1] = blip

	for k, v in ipairs(harvests) do
		AddBlipForHarvest(v)
	end
end)

RegisterNetEvent("farming:harvest")
AddEventHandler("farming:harvest", function(harvest)
	Harvests[#Harvests + 1] =  harvest
	AddBlipForHarvest(harvest)
end)