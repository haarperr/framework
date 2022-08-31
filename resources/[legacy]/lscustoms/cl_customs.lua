Coords = nil
Vehicle = 0
VehicleInfo = nil

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Coords and DoesEntityExist(Vehicle) then
			SetVehicleUndriveable(Vehicle, true)
			DisableControlAction(0, 51, true)

			exports.markers:HideThisFrame()
		else
			Citizen.Wait(500)
		end
		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
function Open(debugMode)
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	if not DoesEntityExist(vehicle) or GetPedInVehicleSeat(vehicle, -1) ~= ped then return end

	Vehicle = vehicle

	SetVehicleModKit(vehicle, 0)
	SetVehicleDoorsLocked(vehicle, 4)
	SetVehicleUndriveable(vehicle, true)

	Menu:Open(debugMode)
end
exports("Open", Open)

function Close()
	SetVehicleAutoRepairDisabled(Vehicle, true)
	Menu:Close()
end
exports("Close", Close)

function EnterCustoms(coords)
	Coords = coords

	Open()
	
	SetEntityCoords(Vehicle, coords.x, coords.y, coords.z)
	SetEntityHeading(Vehicle, coords.w)
	PlaceObjectOnGroundProperly(Vehicle)
	SetEntityCollision(Vehicle, false, false)
	FreezeEntityPosition(Vehicle, true)
end

function ExitCustoms()
	SetEntityCollision(Vehicle, true, true)
	SetVehicleDoorsLocked(Vehicle, 1)
	FreezeEntityPosition(Vehicle, false)
	
	Coords = nil
	Vehicle = 0

	Close()
end

function BeginPreview()
	if DoesEntityExist(Vehicle) then
		VehicleInfo = exports.garages:GetVehicleInfo(Vehicle)
	else
		VehicleInfo = nil
	end
end

function RestorePreview()
	if VehicleInfo then
		exports.garages:SetVehicleInfo(Vehicle, VehicleInfo)
	end
end

--[[ Events ]]--
AddEventHandler("lscustoms:clientStart", function()
	for k, v in ipairs(Config.Shops) do
		local callbackId = "VehicleCustoms-"..tostring(k)
		exports.markers:CreateUsable(GetCurrentResourceName(), v.Coords, callbackId, "Enter", Config.Markers.DrawRadius, Config.Markers.Radius, nil, {
			useWhileInVehicle = true,
		})

		AddEventHandler("markers:use_"..callbackId, function()
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped, false)
			if not DoesEntityExist(vehicle) or GetPedInVehicleSeat(vehicle, -1) ~= ped then return end

			if not v.Condition or v.Condition(vehicle) then
				EnterCustoms(v.Coords)
			end
		end)
	end
end)