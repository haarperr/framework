Main = {}

function Main:RegisterPumps()
    for k, pump in ipairs(Config.Pumps) do
		local id = ("pump-%s"):format(k)
		
		exports.interact:Register({
			id = id,
			embedded = {
				{
					id = "pump:pay-cash",
					text = "Pay by Cash",
				},
				{
					id = "pump:pay-bank",
					text = "Pay by Debit",
				},
				{
					id = "pump:return-nozzle",
					text = "Return Nozzle"
				}
			},
			model = pump.Model
		})
	end
end

function Main:StartPump()
	self.started = false
	exports.emotes:Play(Config.Anim)
	self:Fuel()
	TriggerEvent("chat:notify", { class="inform", text="Press [E] facing vehicle to fuel!" })
end

function Main:Fuel()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if self.canPump then
				local player = PlayerPedId()
				local playerPosition = GetEntityCoords(player, false)
				if #(playerPosition - self.pumpLocation) <= 10.0 then
					if IsControlJustPressed(1, 51) and not self.started then
						local vehiclePosition = GetEntityCoords(self.selectedVehicle, false)
						local playerPosition = GetEntityCoords(player, false)
						if #(playerPosition - vehiclePosition) <= 2.0 then
							if not IsPedInVehicle(player) then
								local maxFuel = GetVehicleHandlingFloat(self.selectedVehicle, "CHandlingData", "fPetrolTankVolume")
								Config.Action.Duration = math.floor(maxFuel - GetVehicleFuelLevel(self.selectedVehicle)) * 1000
								exports.mythic_progbar:Progress(Config.Action, function(wasCancelled)
									self.started = true
									if wasCancelled then return end
									SetVehicleFuelLevel(self.selectedVehicle, maxFuel)
									exports.emotes:Play(Config.Anim)
									self.canPump = false
									return
								end)
							else
								TriggerEvent("chat:notify", { class="error", text="Get out of your car!" })
							end
						else
							TriggerEvent("chat:notify", { class="error", text="Get closer to your vehicle!" })
						end
					end
				else
					TriggerEvent("chat:notify", { class="error", text="You have abandoned fueling!" })
					exports.emotes:Stop()
					break
				end
			else
				break
			end
		end
	end)
end

function Main:ReturnNozzle()
	exports.emotes:Stop()
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	Main:RegisterPumps()
end)

AddEventHandler("interact:on_pump:pay-cash", function()
	local playerPosition = GetEntityCoords(PlayerPedId(), false)
	local vehicle = GetNearestVehicle(playerPosition, Config.Distance)
	if DoesEntityExist(vehicle) then
		if IsEntityAVehicle(vehicle) then
			local currentFuel = GetVehicleFuelLevel(vehicle)
			local maxFuel = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume")
			if currentFuel ~= maxFuel then
				local difference = maxFuel - currentFuel
				TriggerServerEvent("gasstation:canAfford", difference, "cash")
				Main.selectedVehicle = vehicle
			else
				TriggerEvent("chat:notify", { class="error", text="Your tank is already full!" })
			end
		end
	else
		TriggerEvent("chat:notify", { class="error", text="No vehicle nearby!" })
	end
end)

AddEventHandler("interact:on_pump:pay-bank", function()
	local playerPosition = GetEntityCoords(PlayerPedId(), false)
	local vehicle = GetNearestVehicle(playerPosition, Config.Distance)
	if DoesEntityExist(vehicle) then
		if IsEntityAVehicle(vehicle) then
			local currentFuel = GetVehicleFuelLevel(vehicle)
			local maxFuel = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume")
			if currentFuel ~= maxFuel then
				local difference = maxFuel - currentFuel
				TriggerServerEvent("gasstation:canAfford", difference, "bank")
				Main.selectedVehicle = vehicle
			end
		end
	end
end)

AddEventHandler("interact:on_pump:return-nozzle", function()
	Main:ReturnNozzle()
end)

AddEventHandler("inventory:useFinish", function(item, slot, cb)
	if item.name == "Jerry Can" then
		Citizen.Wait(500)
		local player = PlayerPedId()
		local hasCan = GetCurrentPedWeapon(player, 1)
		if hasCan then
			if IsPedInVehicle(player) then return end

			local playerPosition = GetEntityCoords(player, false)
			local vehicle = GetNearestVehicle(playerPosition, Config.Distance)
			if not DoesEntityExist(vehicle) then return end
			
			local currentFuel = GetVehicleFuelLevel(vehicle)
			local maxFuel = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume")
			if currentFuel ~= maxFuel then
				local vehiclePosition = GetEntityCoords(vehicle, false)
				if #(playerPosition - vehiclePosition) <= 2.0 then
					if not IsPedInVehicle(player) then
						local maxFuel = GetVehicleHandlingFloat(vehicle, "CHandlingData", "fPetrolTankVolume")
						exports.mythic_progbar:Progress(Config.JerryAction, function(wasCancelled)
							if wasCancelled then return end
							if ( currentFuel + 20 ) >= maxFuel then
								SetVehicleFuelLevel(vehicle, maxFuel)
							else
								SetVehicleFuelLevel(vehicle, currentFuel + 20)
							end
							TriggerServerEvent("gasstation:takeJerry")
							return
						end)
					else
						TriggerEvent("chat:notify", { class="error", text="Get out of your car!" })
					end
				else
					TriggerEvent("chat:notify", { class="error", text="Get closer to your vehicle!" })
				end
			else
				TriggerEvent("chat:notify", { class="error", text="Your tank is already full!" })
			end
		end
	end
end)


RegisterNetEvent("gasstation:startPump")
AddEventHandler("gasstation:startPump", function()
	Main.pumpLocation = GetEntityCoords(PlayerPedId(), false)
	Main:StartPump()
	Main.canPump = true
end)
