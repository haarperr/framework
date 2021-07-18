local repairs = nil
local components = {}
local targetComponent = nil

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if DoesEntityExist(Repairing) then
			-- Setup health values.
			if not InitializeVehicle(Repairing) then
				repairs = {
					["Engine"] = GetVehicleEngineHealth(Repairing) / 1000.0,
					["Fuel Tank"] = GetVehiclePetrolTankHealth(Repairing) / 1000.0,
					["Axle"] = DecorGetFloat(Repairing, "Vehicle_AxleHealth"),
					["Brakes"] = DecorGetFloat(Repairing, "Vehicle_BrakeHealth"),
					["Electronics"] = DecorGetFloat(Repairing, "Vehicle_ElectronicsHealth"),
					["Fuel Injector"] = DecorGetFloat(Repairing, "Vehicle_FuelInjectorHealth"),
					["Radiator"] = DecorGetFloat(Repairing, "Vehicle_RadiatorHealth"),
					["Transmission"] = DecorGetFloat(Repairing, "Vehicle_TransmissionHealth"),
				}
			end

			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)
			local vehicleCoords = GetEntityCoords(Repairing)

			-- Get camera info.
			local camCoords = GetFinalRenderedCamCoord()
			local camRot = GetFinalRenderedCamRot(0)
			local camForward = exports.misc:FromRotation(camRot + vector3(0, 0, 90))
			
			-- First component pass.
			local bones = {}
			local nearestDot = 0.0

			for k, component in ipairs(Config.Repairing.Components) do
				local index = GetEntityBoneIndexByName(Repairing, component.Name)
				if index ~= -1 and (not component.Condition or component.Condition(Repairing, bones)) then
					local coords = vehicleCoords - GetOffsetFromEntityInWorldCoords(Repairing, component.Offset) + GetWorldPositionOfEntityBone(Repairing, index)
					
					bones[component.Name] = true
					components[k] = coords

					local dist = #(coords - pedCoords)
					local dot = exports.misc:Dot(exports.misc:Normalize(coords - camCoords), camForward)

					if dist < Config.Repairing.ActionDistance and dot > Config.Repairing.MinDotProduct and (not targetComponent or dot > nearestDot) then
						targetComponent = k
						nearestDot = dot
					end
				end
			end

			if Debug then
				Citizen.Wait(0)
			else
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		if DoesEntityExist(Repairing) then
			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)
			local vehicleCoords = GetEntityCoords(Repairing)

			if not repairs or #(vehicleCoords - pedCoords) > Config.Repairing.ViewDistance or (IsPedInAnyVehicle(ped) and not Debug) then
				Repairing = 0
				repairs = nil
				goto skip
			end

			-- Second component pass.
			LookingAt = nil
			for k, component in ipairs(Config.Repairing.Components) do
				local coords = components[k]
				if coords then
					local id = 2
					if targetComponent == k then
						id = 1
					end

					local status = nil
					local value = repairs[component.Repair] or 1.0

					for k, v in ipairs(Config.Repairing.Levels) do
						if v[1] < value then
							status = v[2]
							break
						end
					end

					if component.Mod then
						local mod = GetVehicleMod(Repairing, component.Mod) + 1
						if mod > 0 then
							status = ("%s ~w~(Level %s)"):format(status, mod)
						end
					end

					if not status then
						status = Config.Repairing.Levels[#Config.Repairing.Levels][2]
					end
					
					if Debug then
						status = status.." "..value
					end
					
					Draw3DText(nil, coords, component.Repair.." - "..status, 4, 0.4, id)

					if targetComponent == k then
						LookingAt = targetComponent
						-- Put material check here and tell player whne pressing E?.
					end
				end
			end

			::skip::
		else
			Citizen.Wait(1000)
		end

		Citizen.Wait(1)
	end
end)

--[[ Functions ]]--
function Repair(vehicle, isBasic, isFull, slotId)
	local engineHealth, bodyHealth, fuelHealth = GetVehicleEngineHealth(vehicle), GetVehicleBodyHealth(vehicle), GetVehiclePetrolTankHealth(vehicle)
	local fuelLevel = GetVehicleFuelLevel(vehicle)
	local oldBodyHealth = bodyHealth

	if isBasic then
		local enginePart = Config.Repairing.Parts["Engine"]
		local fuelPart = Config.Repairing.Parts["Fuel Tank"]
		local bodyPart = Config.Repairing.Parts["Body"]

		if engineHealth < enginePart.MaxBasic then
			engineHealth = math.min(engineHealth + enginePart.BasicAmount, enginePart.MaxBasic)
		end
		
		if fuelHealth < fuelPart.MaxBasic then
			fuelHealth = math.min(fuelHealth + fuelPart.BasicAmount, fuelPart.MaxBasic)
		end
		
		bodyHealth = math.min(bodyHealth + bodyPart.BasicAmount, 1000.0)
	elseif isFull then
		engineHealth = 1000.0
		bodyHealth = 1000.0
		fuelHealth = 1000.0

		for k, part in pairs(Config.Repairing.Parts) do
			if part.Decor then
				DecorSetFloat(vehicle, part.Decor, 1.0)
			end
		end

		fuelLevel = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume")
		
		SetVehicleFixed(vehicle)
	else
		if not RepairingComponent then return end
		local component = Config.Repairing.Components[RepairingComponent]
		if not component then return end

		local part = Config.Repairing.Parts[component.Repair]
		if not part then return end

		if part.Decor then
			DecorSetFloat(vehicle, part.Decor, math.min(DecorGetFloat(vehicle, part.Decor) + 0.2, 1.0))
		elseif part.IsEngine then
			engineHealth = engineHealth + 200.0
			bodyHealth = bodyHealth + 200.0
			fuelHealth = fuelHealth + 200.0
		end
	end

	if not isFull then
		TriggerServerEvent("vehicles:repair", slotId, RepairingComponent)
	end

	if bodyHealth >= 900.0 and engineHealth >= 750.0 then
		SetVehicleFixed(vehicle)
	end

	SetVehicleEngineHealth(vehicle, engineHealth * 1.0)
	SetVehicleBodyHealth(vehicle, bodyHealth * 1.0)
	SetVehiclePetrolTankHealth(vehicle, fuelHealth * 1.0)
	SetVehicleFuelLevel(vehicle, fuelLevel)
	
	DecorSetFloat(vehicle, "Vehicle_LastEngineHealth", engineHealth)
	DecorSetFloat(vehicle, "Vehicle_LastBodyHealth", bodyHealth)
	DecorSetFloat(vehicle, "Vehicle_LastFuelHealth", fuelHealth)
end

--[[ Events ]]--
RegisterNetEvent("vehicles:fix")
AddEventHandler("vehicles:fix", function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if not DoesEntityExist(vehicle) then return end
	Repair(vehicle, false, true)
end)

RegisterNetEvent("vehicles:unfix")
AddEventHandler("vehicles:unfix", function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if not DoesEntityExist(vehicle) then return end
	for k, part in pairs(Config.Repairing.Parts) do
		if part.Decor then
			DecorSetFloat(vehicle, part.Decor, 0.0)
		end
	end
end)

RegisterNetEvent("vehicles:clean")
AddEventHandler("vehicles:clean", function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if not DoesEntityExist(vehicle) then return end
	SetVehicleDirtLevel(vehicle, 0.0)
end)

--[[ Commands ]]--
RegisterCommand("repair", function(source, args, rawCommand)
	if DoesEntityExist(Repairing) then
		Repairing = 0
		return
	end

	Repairing = exports.oldutils:GetNearestVehicle() or 0
end, false)