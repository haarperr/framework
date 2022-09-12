Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 311) then
            TriggerEvent ("set:cruiseSpeed")
        end
    end
end)

local cruisecontrol = 0

AddEventHandler("set:cruiseSpeed", function()
    if cruisecontrol == 0 and IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        if GetEntitySpeedVector(GetVehiclePedIsIn(GetPlayerPed(-1), false), true) ['y'] > 0 then
            cruisecontrol = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
            local speedKm = math.floor(cruisecontrol * 3.6 + 0.5)
            local speedMph = math.floor(cruisecontrol * 2.23694 + 0.5)

            TriggerEvent("chat:notify", "Cruise Control Activated!", "inform")


            Citizen.CreateThread(function()
                while cruisecontrol > 0 and GetPedInVehicleSeat((GetVehiclePedIsIn(GetPlayerPed(-1), false)), -1) == GetPlayerPed(-1) do 
                    local vehCruise = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    if IsVehicleOnAllWheels(vehCruise) and GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) > (cruisecontrol - 2.0) then
                        SetVehicleForwardSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), cruisecontrol)
                    else
                        cruisecontrol = 0
                        TriggerEvent("chat:notify", "Cruise Not Active!", "error")
                        break
                    end
                    if IsControlJustPressed(1, 311) then
                        cruisecontrol = 0
                        TriggerEvent("chat:notify", "Cruise Control Activated!", "inform")
                    end
                    if IsControlJustPressed(1, 311) then
                        cruisecontrol = 0
                        TriggerEvent('set:cruiseSpeed')
                    end
                    if cruisecontrol > 85 then
                        cruisecontrol = 0 
                        TriggerEvent("chat:notify", "You are going too fast. Cruise Control Cancelled!", "error")
                    end
                    Wait(200)
                end
                cruisecontrol = 0
    end)

            AddEventHandler("set:cruiseNew", function()
                Citizen.CreateThread(function()
                    while IsControlPressed(1, 32) do
                        Wait(1)
                    end
                    TriggerEvent('pv:setCruiseSpeed')
                end)
            end)
        end
    end
 end)