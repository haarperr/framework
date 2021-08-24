Door = {}
Door.__index = Door

function Door:Create(data)
	-- Set metatable.
	self = setmetatable(data or {}, Door)

	-- Set data.
	self.id = ("door%s"):format(self.hash)

	-- Group.
	local groupId = Doors.group
	if not groupId then return end

	local group = Doors.groups[groupId]
	if not group then return end

	-- Register interacts.
	local embedded = {
		{
			id = self.id.."_1",
			text = "",
			event = "doorLock",
			entity = self.object,
			distance = self.settings.Distance,
			factions = self.settings.Factions or group.factions,
			property = group.property,
		},
	}

	if self.settings.Item then
		table.insert(embedded, {
			id = self.id.."_2",
			text = "Tamper",
			event = "doorItem",
			entity = self.object,
			items = {
				{ name = self.settings.Item, amount = 1, hidden = true },
			},
		})
	end
	
	if not self.settings.Electronic or not GlobalState.powerDisabled then
		exports.interact:Register({
			id = self.id,
			text = "",
			embedded = embedded,
		})
	end

	-- Double doors.
	if not self.settings.NoDouble then
		self:FindDouble()
	end

	return self
end

function Door:Destroy()
	-- Remove from door system.
	if IsDoorRegisteredWithSystem(self.hash) then
		RemoveDoorFromSystem(self.hash)
	end

	-- Destroy the interact.
	exports.interact:Destroy(self.id)

	-- Debug.
	if Config.Debug then
		exports.interact:RemoveText(self.id)
		exports.interact:RemoveText(self.id.."_2")
	end
end

function Door:Update()
	-- Citizen.CreateThread(function()
	-- 	local time = GetGameTimer()
	-- 	while GetGameTimer() - time < 1000 do
			
	-- 		DrawLine(self.coords.x, self.coords.y, self.coords.z, self.coords.x + right.x * 3.0, self.coords.y + right.y * 3.0, self.coords.z + right.z * 3.0, 255, 0, 0, 255)
	-- 		Citizen.Wait(0)
	-- 	end
	-- end)

	if self.settings.Vault then
		-- Freeze the door.
		FreezeEntityPosition(self.object, true)

		-- Get heading.
		local heading = GetEntityHeading(self.object)
		local targetHeading = heading

		-- Set target heading.
		if self.state then
			targetHeading = self.heading
		else
			targetHeading = self.heading + self.settings.Vault
		end

		-- Set current heading.
		if targetHeading > heading then
			heading = math.min(heading + 0.2, targetHeading)
		else
			heading = math.max(heading - 0.2, targetHeading)
		end

		SetEntityHeading(self.object, heading)

		-- Sounds.
		if math.abs(targetHeading - heading) > 1.0 and GetGameTimer() - (self.lastSound or 0) > 900 then
			PlaySoundFromCoord(-1, "OPENING", self.coords.x, self.coords.y, self.coords.z, "MP_PROPERTIES_ELEVATOR_DOORS", 1, 5.0)
			self.lastSound = GetGameTimer()
		end
	end

	if self.settings.HoldOpen and not self.state then
		DoorSystemSetOpenRatio(self.hash, 1.0, true, true)
	end
end

function Door:FindDouble()
	if self.double ~= nil then return end
	
	-- Calculate directions.
	local forward = GetEntityForwardVector(self.object)
	local right = exports.misc:Cross(forward, vector3(0, 0, 1))

	-- Calculate sizes.
	local min, max = GetModelDimensions(self.model)
	local size = max - min

	-- Find the target.
	for i = 1, 2 do
		local offset = math.max(size.x, size.y) * 2.0
		if i == 1 then
			offset = right * offset
		else
			offset = -right * offset
		end

		local coords = self.coords + offset
		local hash = GetCoordsHash(coords)
		local door = Doors.doors[hash]

		-- Citizen.CreateThread(function()
		-- 	while true do
		-- 		DrawLine(self.coords.x, self.coords.y, self.coords.z, coords.x, coords.y, coords.z, 255, 0, 0, 255)
		-- 		DrawLine(coords.x, coords.y, coords.z, coords.x, coords.y, coords.z + 1.0, 0, 255, 0, 255)
		-- 		Citizen.Wait(0)
		-- 	end
		-- end)

		if door ~= nil then
			door.double = self.hash
			self.double = hash
			break
		end
	end
end

function Door:SetState(state, ignoreDouble, ignoreOverride)
	Debug("set state", self.hash, self.object, state)

	-- Special states.
	if state == 2 then
		local special = self.settings.SpecialState
		if special then
			local lifetime = GetNetworkTime() / 1000 - (self.update or 0)
			local maxLifetime = special.Lifetime or 1.0
			local effect

			if Config.Debug then
				maxLifetime = 3.0
			end
			
			while lifetime < maxLifetime do
				if not effect then
					local offsets = special.Offsets
					effect = StartEffect(
						StartParticleFxLoopedOnEntity, special.PtfxDict, special.PtfxName, self.object,
						offsets[1] or 0.0, offsets[2] or 0.0, offsets[3] or 0.0,
						offsets[4] or 0.0, offsets[5] or 0.0, offsets[6] or 0.0,
						offsets[7] or 1.0
					)
				end

				lifetime = GetNetworkTime() / 1000 - (self.update or 0)
				Citizen.Wait(0)
			end

			if effect then
				StopParticleFxLooped(effect)
			end
			
			if special.SwapModel then
				self.state = false
				self:SwapModel(special.SwapModel)

				return
			end
		end
		state = false
	end

	-- Set the state.
	self.state = state
	local _state = state
	
	-- Get the values.
	local text
	if state then
		_state = 1
		text = "Unlock"
	else
		_state = 0
		text = "Lock"
	end
	
	-- Update interact.
	exports.interact:Set(self.id.."_1", "text", text)
	exports.interact:ClearOptions(self.object)
	
	-- Wait for the door to close.
	while not self.settings.Sliding and DoesEntityExist(self.object) and DoorSystemGetOpenRatio(self.hash) > 0.1 do
		Citizen.Wait(0)
	end

	-- Double doors.
	if not ignoreDouble and self.double ~= nil then
		local double = Doors.doors[self.double]
		if double then
			if (not ignoreOverride or (self.override or 0) > (double.override or 0)) then
				double:SetState(state, true, ignoreOverride)
			else
				self:SetState(double.state, true)
				return
			end
		end
	end

	-- Confirm door system.
	if not IsDoorRegisteredWithSystem(self.hash) then
		AddDoorToSystem(self.hash, self.model, self.coords.x, self.coords.y, self.coords.z, false, false, true)
	end

	-- Set the system state.
	DoorSystemSetDoorState(self.hash, _state, true)

	-- Debug.
	if Config.Debug then
		exports.interact:RemoveText(self.id)
		exports.interact:RemoveText(self.id.."_2")

		exports.interact:AddText({
			id = self.id,
			entity = self.object,
			text = "Object: "..self.object.."<br>Door: "..self.hash.."<br>Locked: "..tostring(state).."<br>Item: "..(self.settings.Item or "None"),
		})

		if self.settings.HandleOffset then
			exports.interact:AddText({
				id = self.id.."_2",
				entity = self.object,
				text = "Handle",
				offset = self.settings.HandleOffset,
			})
		end
	end
end

function Door:SwapModel(newModel)
	if type(newModel) == "string" then
		newModel = GetHashKey(newModel)
	end

	while not HasModelLoaded(newModel) do
		RequestModel(newModel)
		Citizen.Wait(30)
	end
	
	local coords = GetEntityCoords(self.object)

	CreateModelSwap(coords.x, coords.y, coords.z, 3.0, self.model, newModel, 1)

	Doors:Destroy(self.hash)
end

function Door:ToggleLock()
	-- Emote and movement.
	exports.emotes:Play(Config.Locking.Anim)

	-- Disable movement - emotes can be interrupted so force it.
	local startTime = GetGameTimer()
	while GetGameTimer() - startTime < Config.Locking.Anim.Duration do
		DisableControlAction(0, 30)
		DisableControlAction(0, 31)

		Citizen.Wait(0)
	end

	-- Finally, toggle lock.
	TriggerServerEvent("doors:toggle", self.hash, not self.state)
end

function Door:UseItem(item)
	local action = Config.Actions[item]
	if not action then return end

	local canceled = false

	if action.Anim then
		exports.emotes:Play(action.Anim, function(state)
			canceled = not state
		end)
	end
	
	if Config.Debug then
		Citizen.Wait(500)
	else
		Citizen.Wait(action.Duration)
	end

	if canceled then return end
	
	exports.emotes:Stop()
	
	TriggerServerEvent("doors:toggle", self.hash, 2, item)
end