--[[ Initialization ]]--
Blips = {}
Data = nil
IsDelivering = false
LastRouteBlip = 0
NearestDestination = nil
Vehicle = 0
Emote = nil

--[[ Threads ]]--
Citizen.CreateThread(function()
	AddTextEntry("DeliveryBlip", "Delivery")
end)

Citizen.CreateThread(function()
	while true do
		while not Data do
			Citizen.Wait(1000)
		end

		NearestDestination = nil
		local nearestDist = 0.0
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for _, destination in pairs(Data.destinations) do
			if destination.coords and not destination.complete then
				local dist = #(coords - destination.coords)
				if not NearestDestination or dist < nearestDist then
					nearestDist = dist
					NearestDestination = destination
				end
			end
		end

		if NearestDestination then
			local blip = NearestDestination.blip or 0
			if DoesBlipExist(blip) and LastRouteBlip ~= blip then
				if DoesBlipExist(LastRouteBlip) then
					SetBlipRoute(LastRouteBlip, false)
				end
				SetBlipRoute(blip, true)
				LastRouteBlip = blip
			end
		end

		Citizen.Wait(2000)
	end
end)

Citizen.CreateThread(function()
	while true do
		while not Data do
			Citizen.Wait(1000)
			print("no data")
		end

		while not DoesEntityExist(Vehicle) do
			Citizen.Wait(200)
			Vehicle = exports.jobs:GetVehicle()
		end

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)

		-- Getting the goods.
		local trunkBone = GetEntityBoneIndexByName(Vehicle, "boot")
		local doorR = GetEntityBoneIndexByName(Vehicle, "door_dside_r")
		local doorL = GetEntityBoneIndexByName(Vehicle, "door_pside_r")
		local targetCoords = GetEntityCoords(Vehicle)
		
		if trunkBone ~= -1 then
			targetCoords = GetWorldPositionOfEntityBone(Vehicle, trunkBone)
		else
			if doorR ~= -1 and doorL ~= -1 then
				targetCoords = (GetWorldPositionOfEntityBone(Vehicle, doorR) + GetWorldPositionOfEntityBone(Vehicle, doorL)) * 0.5
			elseif doorR ~= -1 then
				targetCoords = GetWorldPositionOfEntityBone(Vehicle, doorR)
			elseif doorL ~= -1 then
				targetCoords = GetWorldPositionOfEntityBone(Vehicle, doorL)
			end
		end

		if #(targetCoords - pedCoords) < 2.0 and exports.oldutils:DrawContext("Receive Delivery", targetCoords) then
			IsDelivering = true
			Emote = exports.emotes:Play(Config.Delivery.Anim)
		end
		
		-- Delivering the goods.
		if NearestDestination then
			local destinationCoords = NearestDestination.coords
			local destinationState = 1
			if not IsDelivering or NearestDestination.complete then
				destinationState = 2
			end
			if destinationCoords and #(destinationCoords - pedCoords) < 2.0 and exports.oldutils:DrawContext({ {183,"Deliver"} }, destinationCoords, destinationState) and destinationState == 1 then
				exports.emotes:Play(Config.Deliver.Anim)
				TriggerServerEvent("deliveries:finishDelivery", NearestDestination.id, exports.jobs:GetCurrentJob().Name)
				
				NearestDestination.complete = true
				UpdateDestination(NearestDestination)
				
				NearestDestination = nil
				IsDelivering = false
				exports.emotes:Stop(Emote)
			end
		end
		
		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
function ClearDelivery()
	for blip, coords in pairs(Blips) do
		if DoesBlipExist(blip) then
			RemoveBlip(blip)
		end
	end
	Blips = {}
	Data = nil
end

function AddBlipForDestination(destination)
	local coords = destination.coords
	if not coords then return end

	blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 478)
	SetBlipScale(blip, 0.65)
	SetBlipAsShortRange(blip, true)
	
	BeginTextCommandSetBlipName("DeliveryBlip")

	destination.blip = blip

	UpdateDestination(destination)
	Blips[blip] = destination
end

function UpdateDestination(destination)
	local blip = destination.blip
	local complete = destination.complete
	if not blip then return end
	if complete then
		SetBlipColour(blip, 6)
		SetBlipAlpha(blip, 128)
	else
		SetBlipColour(blip, 2)
		SetBlipAlpha(blip, 255)
	end
	EndTextCommandSetBlipName(blip)
end

--[[ Events ]]--
AddEventHandler("deliveries:start", function()
	Data = exports.cache:Get("DeliveryData") or Data

	if Data then
		TriggerEvent("deliveries:update", Data)
	end
end)

AddEventHandler("deliveries:stop", function()
	exports.cache:Set("DeliveryData", Data)
end)

RegisterNetEvent("deliveries:update")
AddEventHandler("deliveries:update", function(data)
	Data = data

	if not data.destinations then return end
	for _, destination in pairs(data.destinations) do
		local coords = destination.coords
		local propertyId = destination.property
		if propertyId then
			local property = exports.properties:GetProperty(propertyId)
			if property then
				coords = vector3(property.x, property.y, property.z)
			end
		end
		if coords then
			destination.coords = coords
			AddBlipForDestination(destination)
		end
	end
end)

RegisterNetEvent("jobs:clocked")
AddEventHandler("jobs:clocked", function(name, message)
	if message ~= false and message ~= true then return end

	local job = exports.jobs:GetJob(name)
	print(job)
	if not job then return end

	local delivery = job.Delivery
	if not delivery then return end

	if message then
		exports.mythic_notify:SendAlert("inform", Config.Messages.Start, 15000)
	else
		ClearDelivery()
	end
end)

RegisterNetEvent("deliveries:clearCache")
AddEventHandler("deliveries:clearCache", function(name, message)
	ClearDelivery()
end)

AddEventHandler("emotes:cancel", function(id)
	if Emote == id then
		IsDelivering = false
	end
end)