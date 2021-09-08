Lights = {
	blinkers = {},
	horns = {},
	sirens = {},
	sounds = {},
}

--[[ Functions ]]--
function Lights:PlaySound(vehicle, sound)
	local soundId = self.sounds[vehicle]
	if soundId then
		StopSound(soundId)
		ReleaseSoundId(soundId)
		self.sounds[vehicle] = nil
	end

	if sound then
		soundId = GetSoundId()
		self.sounds[vehicle] = soundId

		PlaySoundFromEntity(soundId, sound, vehicle, 0, 0, 0)
	end
end

function Lights:UpdateSiren(vehicle, state)
	self.sirens[vehicle] = state

	SetVehicleHasMutedSirens(vehicle, true)
	SetVehicleSiren(vehicle, state and state > 0)

	local siren = state and state > 0 and Config.Sirens[state]

	self:PlaySound(vehicle, siren)
end

function Lights:UpdateHorn(vehicle, state)
	self.horns[vehicle] = state

	self:PlaySound(vehicle, state == 1 and "SIRENS_AIRHORN")
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

			if entity.state.horn and self.horns[vehicle] ~= entity.state.horn then
				self:UpdateHorn(vehicle, entity.state.horn)
			end
		end
	end

	for vehicle, soundId in pairs(self.sounds) do
		if not cached[vehicle] then
			StopSound(soundId)
			ReleaseSoundId(soundId)

			self.sounds[vehicle] = nil
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
		
		local entity = Entity(CurrentVehicle)
		if not entity then return end
		
		local currentSiren = IsSirenOn and entity.state.siren
		local sirenValue = nil
		local hornValue = nil

		-- Toggle light.
		if IsDisabledControlJustPressed(0, 85) then
			local enabled = not IsSirenOn
			sirenValue = enabled and 1 or 0
		end

		-- Toggle sound.
		if IsDisabledControlJustPressed(0, 80) then
			sirenValue = (entity.state.siren or 1) > 1 and 1 or 2
		end
		
		-- Siren stages.
		if IsDisabledControlJustPressed(0, 224) and currentSiren and currentSiren > 1 then
			sirenValue = (entity.state.siren or 1) + 1
			if sirenValue > 3 then
				sirenValue = 2
			end
		end

		-- Horny.
		if IsDriver then
			if IsDisabledControlJustPressed(0, 86) then
				if currentSiren and currentSiren > 1 then
					Lights.lastSiren = currentSiren == 4 and Lights.lastSiren or currentSiren
					sirenValue = 4
				else
					hornValue = 1
				end
			elseif IsDisabledControlJustReleased(0, 86) then
				if currentSiren == 4 then
					sirenValue = Lights.lastSiren or 2
				else
					hornValue = 0
				end
			end
		end
		
		-- Update sirens.
		if sirenValue then
			TriggerServerEvent("vehicles:setState", "siren", sirenValue)
		end

		-- Update horns.
		if hornValue then
			TriggerServerEvent("vehicles:setState", "horn", hornValue)
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
		Citizen.Wait(200)
	end
end)