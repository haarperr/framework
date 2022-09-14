local CruiseControl = nil
local CruiseVehicle = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		if DoesEntityExist(CruiseVehicle) then
			local isDriver = GetPedInVehicleSeat(CruiseVehicle, -1) == ped
			if isDriver then
				if CruiseControl then
					SetControlNormal(0, 71, 1.0)
					if IsControlPressed(0, 72) then
						CruiseControl = nil
					end
				end
				SetVehicleMaxSpeed(CruiseVehicle, CruiseControl)
            end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		CruiseVehicle = GetVehiclePedIsIn(ped, false)
		Citizen.Wait(1000)
	end
end)

RegisterCommand("+cruisecontrol", function()
	if CruiseControl then
		CruiseControl = nil
		exports.mythic_notify:SendAlert("inform", "Cruise control disabled!")
	elseif DoesEntityExist(CruiseVehicle) then
		CruiseControl = GetEntitySpeed(CruiseVehicle)
		SetVehicleMaxSpeed(CruiseVehicle, CruiseControl)
		exports.mythic_notify:SendAlert("inform", "Cruise control set to "..math.floor(CruiseControl * 2.24).."!")
	end
end, true)

RegisterKeyMapping("+cruisecontrol", "Toggle Cruise Control", "keyboard", "k")