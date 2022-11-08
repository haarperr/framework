local Vehicle = 0
local LastVehicle = 0

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		while not LocalPlayer.state.job do
			Citizen.Wait(1000)
		end

		Citizen.Wait(0)

		local job = Main:GetJobData(Main:GetCurrentJob())
		local pedCoords = GetEntityCoords(PlayerPedId())
		local vehicle = GetVehicle()
		local isVehicleOut = DoesEntityExist(vehicle)

		if job and job.Vehicles then
			print("has vics")
			for k, spawn in ipairs(job.Vehicles) do
				local dist = #(spawn.In - pedCoords)
				print("A")

				if dist > 3.0 then
					goto continue
				end

				local canUse = GetGameTimer() - LastVehicle > 5000
				local id = 1

				if not canUse then
					id = 2
				end

				local text
				if isVehicleOut then
					text = "Store Vehicle"
				else
					text = "Retrieve Vehicle"
				end

				if exports.oldutils:DrawContext(text, spawn.In, id) and canUse then
					if DoesEntityExist(vehicle) then
						exports.oldutils:Delete(vehicle)
						Vehicle = 0
					else
						TrySpawn(spawn)
					end
					LastVehicle = GetGameTimer()
				end
				::continue::
			end
		end
	end
end)

--[[ Functions ]]--
function GetVehicle()
	if not NetworkDoesNetworkIdExist(Vehicle) then
		return 0
	end
	return NetToVeh(Vehicle) or 0
end
exports("GetVehicle", GetVehicle)

function TrySpawn(spawn)
	local coords = nil
	for k, v in ipairs(spawn.Coords) do
		if not IsPositionOccupied(v.x, v.y, v.z, 0.5, false, true, true, false, false, 0, false) then
			coords = v
			break
		end
	end

	if not coords then return end
	
	local vehicle = exports.oldutils:CreateVehicle(GetHashKey(spawn.Model), coords.x, coords.y, coords.z, coords.w, true, true, true)
	SetVehicleLivery(vehicle, spawn.Livery or 0)
	SetVehicleColours(vehicle, spawn.PrimaryColor or 0, spawn.SecondaryColor or 0)
	if spawn.PearlColor then SetVehicleExtraColours(vehicle, spawn.PearlColor, 0) end
	SetVehicleDirtLevel(vehicle, 0.0)
	SetVehicleModKit(vehicle, 0)
	
	if spawn.Extras then
		for i = 1, 14 do
			SetVehicleExtra(vehicle, i, spawn.Extras[i] ~= true)
		end
	end

	if spawn.Mods then
		for k, v in pairs(spawn.Mods) do
			SetVehicleMod(vehicle, k, v)
		end
	end

	Vehicle = VehToNet(vehicle)
    TriggerServerEvent("vehicles:subscribe", Vehicle, true)
	TriggerServerEvent("jobs:getKeys", Vehicle)
end

--[[ Commands ]]--
RegisterCommand("impound", function()
	local dist = 4.0
    local state = LocalPlayer.state or {}
    if state.immobile or state.restrained then return end
	
	if not exports.jobs:IsInEmergency("CanImpound") then
		return
	end

	local vehicle = exports.oldutils:GetNearestVehicle()
	if not DoesEntityExist(vehicle) then return end

	local ped = PlayerPedId()
	if #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > dist then return end

	exports.mythic_progbar:Progress({
		Anim = {
			Dict = "amb@world_human_stand_mobile_fat@female@standing@call@idle_a",
			Name = "idle_b",
			Flag = 49,
			DisableMovement = true,
		},
		Label = "Impounding...",
		Duration = 15000,
		UseWhileDead = false,
		CanCancel = true,
		Disarm = false,
	}, function(wasCancelled)
		if wasCancelled then return end

		if not DoesEntityExist(vehicle) or #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > dist then return end

		exports.oldutils:Delete(vehicle)
	end)
end)