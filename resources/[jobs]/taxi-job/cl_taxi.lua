Enabled = false
WasEnabled = false
LastCoords = nil
Data = nil

local IsInService, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle = false, false, false, false
local CurrentCustomer, CurrentCustomerBlip, DestinationBlip, targetCoords, LastZone

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local Enabled, vehicle = IsInTaxi()
		
		local isDriver = false
		if Enabled then
			isDriver = GetPedInVehicleSeat(vehicle, -1) == ped
		end

		if Enabled and isDriver then
			local coords = GetEntityCoords(vehicle)

			if LastCoords and Data and not IsEntityInAir(vehicle) then
				local dist = #(LastCoords - coords)
				TriggerServerEvent("taxi-job:updateVehicle", VehToNet(vehicle), "fare", (Data.fare or 0.0) + dist / 1609.34 * (Data.rate or 0.0))
			end

			LastCoords = coords
		else
			LastCoords = nil
		end

		if Enabled then
			TriggerServerEvent("taxi-job:requestVehicle", VehToNet(vehicle))
		end
		
		if Enabled ~= WasEnabled then
			Data = nil
			SendNUIMessage({
				enabled = Enabled
			})
		end

		WasEnabled = Enabled
		
		Citizen.Wait(1000)
	end
end)

--[[ Functions ]]--
function IsInTaxi()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	
	if DoesEntityExist(vehicle) then
		local model = GetEntityModel(vehicle)
		return Config.Taxis[model] ~= nil, vehicle
	else
		return false
	end
end

function GetRandomWalkingNPC()
	local search = {}
	local peds = exports.oldutils:GetPeds()

	for i = 1, #peds, 1 do
		if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
			table.insert(search, peds[i])
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end

	for i = 1, 250, 1 do
		local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

		if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
			table.insert(search, ped)
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end
end

function ClearCurrentTask()
	if DoesBlipExist(CurrentCustomerBlip) then
		RemoveBlip(CurrentCustomerBlip)
	end

	if DoesBlipExist(DestinationBlip) then
		RemoveBlip(DestinationBlip)
	end

	CurrentCustomer = nil
	CurrentCustomerBlip = nil
	DestinationBlip = nil
	targetCoords = nil
	IsNearCustomer = false
	CustomerIsEnteringVehicle = false
	CustomerEnteredVehicle = false
end

function StartTaxiJob()
	exports.mythic_notify:SendAlert("inform", "Started taxi service! Look around for people to take.", 6000)
	ClearCurrentTask()

	IsInService = true
end

--[[ Events ]]--
RegisterNetEvent("taxi-job:receiveVehicle")
AddEventHandler("taxi-job:receiveVehicle", function(data)
	Data = data
	SendNUIMessage({
		fare = data.fare or 0.0,
		rate = data.rate or 0.0,
	})
end)

RegisterCommand("meterrate", function(source, args, command)
	local rate = tonumber(args[1])
	if not rate then return end

	local isTaxi, vehicle = IsInTaxi()
	if not isTaxi then return end
	if GetPedInVehicleSeat(vehicle, -1) ~= PlayerPedId() then return end
	TriggerServerEvent("taxi-job:updateVehicle", VehToNet(vehicle), "rate", rate)
end)

RegisterCommand("meterreset", function(source, args, command)
	local isTaxi, vehicle = IsInTaxi()
	if not isTaxi then return end
	if GetPedInVehicleSeat(vehicle, -1) ~= PlayerPedId() then return end
	Data.fare = 0.0
	LastCoords = nil
	TriggerServerEvent("taxi-job:updateVehicle", VehToNet(vehicle), "fare", 0.0)
end)