TickRate = 200

Main.update = {}
Main.processes = {}
Main.vehicles = {}

function Main:Update()
	-- Update globals.
	Ped = PlayerPedId()
	CurrentVehicle = GetVehiclePedIsIn(Ped)
	EnteringVehicle = GetVehiclePedIsEntering(Ped)
	IsDriver = GetPedInVehicleSeat(CurrentVehicle, -1) == Ped

	-- Disables hotwiring.
	DisableControlAction(0, 77)
	DisableControlAction(0, 78)

	-- Update vehicle being entered.
	if EnteringVehicle ~= (self.entering or 0) then
		if DoesEntityExist(EnteringVehicle) then
			print("begin enter", EnteringVehicle)
			self:InvokeListener("BeginEnter", EnteringVehicle)
			TriggerEvent("vehicles:beginEnter", EnteringVehicle)
		elseif DoesEntityExist(self.entering) then
			print("finish enter", self.entering)
			self:InvokeListener("FinishEnter", self.entering)
			TriggerEvent("vehicles:finishEnter", self.entering)
		end

		self.entering = EnteringVehicle
	end

	-- Update current vehicle.
	local isInVehicle = DoesEntityExist(CurrentVehicle)
	if CurrentVehicle ~= (self.vehicle or 0) then
		-- The last vehicle has been exited.
		if self.vehicle and DoesEntityExist(self.vehicle) then
			-- Events.
			print("exited", self.vehicle)
			self:InvokeListener("Exit", self.vehicle)
			TriggerEvent("vehicles:exit", self.vehicle)

			local netId = GetNetworkId(self.vehicle)
			if netId then
				TriggerServerEvent("vehicles:exit", netId)
			end
		end
		
		-- A new vehicle has been entered.
		if isInVehicle then
			-- Events.
			print("entered", CurrentVehicle)
			self:InvokeListener("Enter", CurrentVehicle)
			TriggerEvent("vehicles:enter", CurrentVehicle)
			
			local netId = GetNetworkId(CurrentVehicle)
			if netId then
				TriggerServerEvent("vehicles:enter", netId)
			end

			-- Global settings.
			Class = GetVehicleClass(CurrentVehicle)
			ClassSettings = Classes[Class] or {}
		end
		
		self.vehicle = CurrentVehicle
	end

	-- Value stuff.
	if isInVehicle then
		EngineOn = GetIsVehicleEngineRunning(CurrentVehicle)
		InAir = IsEntityInAir(CurrentVehicle)
		OnWheels = IsVehicleOnAllWheels(CurrentVehicle)
		Rpm = EngineOn and GetVehicleCurrentRpm(CurrentVehicle) or 0.0

		-- Anti-roll.
		if (InAir or not OnWheels) and not ClassSettings.AirControl then
			DisableControlAction(0, 59)
			DisableControlAction(0, 60)
		end
	end

	-- Invoke update listener.
	self:InvokeListener("Update", isInVehicle)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	local lastUpdate = GetGameTimer()
	
	while true do
		-- Update delta.
		DeltaTime = GetGameTimer() - lastUpdate
		MinutesToTicks = 1.0 / 60000.0 * DeltaTime

		-- Update functions.
		if Main.vehicle then
			for name, func in pairs(Main.update) do
				func(Main)
			end
		end

		-- Update time.
		lastUpdate = GetGameTimer()

		Citizen.Wait(TickRate)
	end
end)