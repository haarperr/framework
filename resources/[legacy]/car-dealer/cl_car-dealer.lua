Markers = {}
Dealer = nil
SpawnCoords = nil
LastVehicle = 0
LastView = 0

--[[ Functions ]]--
function ViewVehicle(name)
	if DoesEntityExist(LastVehicle) then
		DeleteEntity(LastVehicle)
	end

	if not ViewVehicle then return end
	if Dealer == nil then end

	local coords = Dealer.VehicleDisplay
	local model = GetHashKey(name)
	local vehicleSettings = exports.vehicles:GetSettings(name)

	LastView = name

	Citizen.CreateThread(function()
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(1)
		end

		if not LastView == name then
			SetModelAsNoLongerNeeded(model)
			return
		end

		if DoesEntityExist(LastVehicle) then
			DeleteEntity(LastVehicle)
		end
	
		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, false, false)
		SetVehicleUndriveable(vehicle, true)
		
		LastVehicle = vehicle
		
		SetModelAsNoLongerNeeded(model)
		
		while DoesEntityExist(vehicle) do
			Citizen.Wait(0)
			SetVehicleEngineOn(vehicle, false, true, true)
		end
	end)
end

function PurchaseVehicle(name)
	TriggerServerEvent("car-dealer:purchase", Dealer.id, name, GetVehicleClassFromName(GetHashKey(name)))
end

--[[ Events ]]--
RegisterNetEvent("car-dealer:confirmPurchase")
AddEventHandler("car-dealer:confirmPurchase", function(vehicle)
	exports.garages:Retrieve(vehicle.id, SpawnCoords)
end)

--[[ Resource Events ]]--
AddEventHandler("car-dealer:clientStart", function()
	if GetResourceState("cache") ~= "started" then return end

	for k, dealer in ipairs(Config.Dealers) do
		local callbackId = "CarDealer-"..dealer.Name.."_"..tostring(k)

		Markers[#Markers + 1] = exports.markers:CreateUsable(GetCurrentResourceName(), dealer.Kiosk, callbackId, "Kiosk", Config.Markers.DrawRadius, Config.Markers.Radius, dealer.Blip)

		AddEventHandler("markers:use_"..callbackId, function()
			if dealer.Faction and not exports.factions:Has(dealer.Faction, dealer.Group) then
				TriggerEvent("chat:notify", "You don't work here!", "error")
				return
			end

			if dealer.License and not exports.licenses:HasLicense(dealer.License) then
				TriggerEvent("chat:notify", "You are unlicensed for these vehicles!", "error")
				return
			end

			SpawnCoords = dealer.VehicleSpawn
			Dealer = dealer
			Dealer.id = k
			Menu:Open()
		end)
	end

	for k, coords in ipairs(Config.Buyer.Coords) do
		local callbackId = "CarBuyer-"..tostring(k)

		exports.markers:CreateUsable(GetCurrentResourceName(), coords, callbackId, "Sell Vehicle", Config.Markers.DrawRadius, Config.Markers.Radius, Config.Buyer.Blip)

		AddEventHandler("markers:use_"..callbackId, function()
			local vehicle = exports.oldutils:GetNearestVehicle() or 0
			if not DoesEntityExist(vehicle) or #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle)) > Config.Markers.DrawRadius then
				TriggerEvent("chat:notify", "Vehicle not found!", "error")
				return
			end
			local netId = VehToNet(vehicle)
			TriggerServerEvent("car-dealer:sellBack", netId)
		end)
	end
end)