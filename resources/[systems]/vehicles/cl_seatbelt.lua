local Seatbelt = {
	Active = false,
	MinSpeed = 60.0,
	Difference = 0.255,
}

function SeatbeltActive()
	local state =  (LocalPlayer or {}).state
	return state.seatbelt
end

function Seatbelt.CalculateForwardPosition(PlayerPed)
	local Heading = (GetEntityHeading(PlayerPed) + 90.0) * 0.0174533
	return {x = math.cos(Heading) * 2.0, y = math.sin(Heading) * 2.0}
end

Citizen.CreateThread(function()
	local Buffer = {
		Speed = {},
		Velocity = {},
	}
	while true do
		Citizen.Wait(0)
		local PlayerPed = PlayerPedId()
		local state =  (LocalPlayer or {}).state

		if IsPedSittingInAnyVehicle(PlayerPed) then
			local Vehicle = GetVehiclePedIsIn(PlayerPed, false)

			if DoesEntityExist(Vehicle) then
				local Model = GetEntityModel(Vehicle)
				if IsThisModelACar(Model) or IsThisModelAQuadbike(Model) or IsThisModelABike(Model) then
					Buffer.Speed[2] = Buffer.Speed[1] or 0.0
					Buffer.Speed[1] = GetEntitySpeed(Vehicle) * 2.23694

					if state.seatbelt then
						DisableControlAction(0, 75, true)
						DisableControlAction(1, 75, true)
						DisableControlAction(2, 75, true)
					elseif GetEntitySpeedVector(Vehicle, true).y > 1.0 and Buffer.Speed[2] > Seatbelt.MinSpeed and (Buffer.Speed[2] - Buffer.Speed[1]) > (Buffer.Speed[2] * Seatbelt.Difference) then
						local ForwardPosition = Seatbelt.CalculateForwardPosition(PlayerPed)
						local PlayerPosition = GetEntityCoords(PlayerPed, false)

						SetEntityCoords(PlayerPed, PlayerPosition.x + ForwardPosition.x, PlayerPosition.y + ForwardPosition.y, PlayerPosition.z + 0.47, true, true, true)
						SetEntityVelocity(PlayerPed, Buffer.Velocity[2].x, Buffer.Velocity[2].y, Buffer.Velocity[2].z)
						
						Citizen.Wait(500)
						
						SetPedToRagdoll(PlayerPed, 1000, 1000, 0, 0, 0, 0)
					end

					Buffer.Velocity[2] = Buffer.Velocity[1]
					Buffer.Velocity[1] = GetEntityVelocity(Vehicle)

					if IsControlJustPressed(1, 29) then
						Seatbelt.Active = not Seatbelt.Active
						state:set("seatbelt", not state.seatbelt, true)
						if state.seatbelt then
							TriggerEvent("chat:notify", "Seatbelt On!", "success")
							TriggerEvent("sound:play", "seatbelt-buckle", 0.1)
						else
							TriggerEvent("chat:notify", "Seatbelt Off!", "error")
							TriggerEvent("sound:play", "seatbelt-unbuckle", 0.1)
						end
						exports.hud:SetSeatbeltHUD(state.seatbelt)
					end
				else
					Buffer.Speed[1], Buffer.Speed[2] = 0.0, 0.0
					Buffer.Velocity[1], Buffer.Velocity[2] = 0.0, 0.0
					
					if state.seatbelt then
						state:set("seatbelt", false, true)
					end
				end
			end
		end
	end
end)

RegisterNetEvent("seatbelt:toggle")
AddEventHandler("seatbelt:toggle", function(status)
	local state =  (LocalPlayer or {}).state
	state:set("seatbelt", status, true)
	exports.hud:SetSeatbeltHUD(state.seatbelt)
	if state.seatbelt then
		TriggerEvent("chat:notify", "Seatbelt on!", "success")
		TriggerEvent("sound:play", "seatbelt-buckle", 0.1)
	else
		TriggerEvent("chat:notify", "Seatbelt off!", "error")
		TriggerEvent("sound:play", "seatbelt-unbuckle", 0.1)
	end
end)