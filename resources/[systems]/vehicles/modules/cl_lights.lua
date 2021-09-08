Lights = {
	blinkers = {},
	sirens = {},
	sounds = {},
}

--[[ Functions ]]--

function Lights:UpdateSiren(vehicle, state)
	self.sirens[vehicle] = state

	print(vehicle, state)

	SetVehicleSiren(vehicle, state and state > 0)
	-- PlaySoundFromEntity(vehicle, "VEHICLES_HORNS_SIREN_2", veh, 0, 0, 0)

	-- Clear sound.
	local soundId = self.sounds[vehicle]
	if soundId then
		StopSound(soundId)
		ReleaseSoundId(soundId)
		self.sounds[vehicle] = nil
	end

	-- Play sound.
	if state and state > 0 then
		soundId = GetSoundId()
		self.sounds[vehicle] = soundId

		local siren = Config.Sirens[state]
		if siren then
			PlaySoundFromEntity(soundId, siren, vehicle, 0, 0, 0)
		end
	end
end

function Lights:UpdateBlinkers(vehicle, state)
	self.blinkers[vehicle] = state

	SetVehicleIndicatorLights(vehicle, 0, state == 2 or state == 3)
	SetVehicleIndicatorLights(vehicle, 1, state == 1 or state == 3)
end

function Lights:Update()
	local cached = {}
	for vehicle, _ in EnumerateVehicles() do
		cached[vehicle] = true
		if NetworkGetEntityIsNetworked(vehicle) then
			local entity = Entity(vehicle)
			
			if entity.state.siren and self.sirens[vehicle] ~= entity.state.siren then
				self:UpdateSiren(vehicle, entity.state.siren)
			end

			if entity.state.blinker and self.blinkers[vehicle] ~= entity.state.blinker then
				self:UpdateBlinkers(vehicle, entity.state.blinker)
			end
		end
	end

	for vehicle, state in pairs(self.sirens) do
		if not cached[vehicle] then
			self.sirens[vehicle] = nil
		end
	end

	for vehicle, state in pairs(self.blinkers) do
		if not cached[vehicle] then
			self.blinkers[vehicle] = nil
		end
	end
end

--[[ Listeners ]]--
Main:AddListener("Update", function()
	if
		not IsInVehicle or
		-- not IsDriver or
		not IsControlEnabled(0, 51) or
		not IsControlEnabled(0, 52)
	then
		return
	end

	-- Sirens.
	if ClassSettings.UseSirens then
		for i = 80, 86 do
			DisableControlAction(0, i)
		end

		local setValue = nil

		-- Toggle light.
		if IsDisabledControlJustPressed(0, 85) then
			local enabled = not IsSirenOn
			setValue = enabled and 1 or 0
		end
		
		-- Siren stages.
		if IsDisabledControlJustPressed(0, 80) and IsSirenOn then
			local entity = Entity(CurrentVehicle)
			setValue = (entity and entity.state.siren or 1) + 1
			if not Config.Sirens[setValue] then
				setValue = 2
			end
		end

		-- Toggle sound.
		if IsDisabledControlJustPressed(0, 224) then
			local entity = Entity(CurrentVehicle)
			setValue = (entity and entity.state.siren or 1) > 1 and 1 or 2
		end

		-- Update value.
		if setValue then
			TriggerServerEvent("vehicles:setState", "siren", setValue)
		end
	end

	-- Blinkers.
	if IsDisabledControlPressed(0, 62) then
		DisableControlAction(0, 59)
		DisableControlAction(0, 63)
		DisableControlAction(0, 64)
		DisableControlAction(0, 72)

		local turnSignal = nil

		if IsDisabledControlJustPressed(0, 63) then
			turnSignal = 1
		elseif IsDisabledControlJustPressed(0, 64) then
			turnSignal = 2
		elseif IsDisabledControlJustPressed(0, 72) then
			turnSignal = 3
		end

		if turnSignal then
			local value = GetVehicleIndicatorLights(CurrentVehicle)

			if turnSignal == value then
				turnSignal = 0
			end

			TriggerServerEvent("vehicles:setState", "blinker", turnSignal)

			-- SetVehicleIndicatorLights(CurrentVehicle, 0, turnSignal == 2 or turnSignal == 3)
			-- SetVehicleIndicatorLights(CurrentVehicle, 1, turnSignal == 1 or turnSignal == 3)
		end
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Lights:Update()
		Citizen.Wait(400)
	end
end)