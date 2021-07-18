function Site:UpdateDoors()
	if Main.camera == nil then return end
	
	-- Create labels.
	if self.labels == nil then
		self.labels = {}
	end

	-- Get doors.
	if self.lastDoorsUpdate == nil or GetGameTimer() - self.lastDoorsUpdate > 500 then
		self.lastDoorsUpdate = GetGameTimer()
		self.doors = exports.doors:GetDoors()
	end

	-- Get cursor stuff.
	local camCoords = GetFinalRenderedCamCoord()
	local mouseX, mouseY = GetNuiCursorPosition()
	local width, height = GetActiveScreenResolution()
	local activeDoor = nil

	-- Check doors.
	for hash, door in pairs(self.doors) do
		if not door.settings.Electronic then goto skip end

		local entity = door.object
		local coords = door.coords
		local retval, screenX, screenY = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
		local label = self.labels[entity]

		if retval and #(coords - camCoords) < Config.DoorDistance then
			screenX = screenX * width
			screenY = screenY * height

			local screenDist = ((screenX - mouseX)^2 + (screenY - mouseY)^2)^0.5
			local isActive = Menu.hasFocus and screenDist < 100.0

			if isActive and (activeDoor == nil or #(activeDoor.coords - camCoords) > #(coords - camCoords)) then
				activeDoor = door
			end

			self:UpdateDoor(door)
		else
			self:RemoveDoor(door.object)
		end

		::skip::
	end

	-- Select door.
	if activeDoor ~= self.activeDoor then
		if self.activeDoor ~= nil then
			ResetEntityAlpha(self.activeDoor.object)
		end

		if activeDoor ~= nil then
			SetEntityAlpha(activeDoor.object, 192)
		end

		self.activeDoor = activeDoor
	end

	-- Toggle door.
	if activeDoor ~= nil and IsDisabledControlJustPressed(0, 24) then
		exports.doors:SetDoorState(activeDoor.coords, not activeDoor.state)
	end
end

function Site:UpdateDoor(door)
	local entity = door.object
	local label = self.labels[entity]
	if label ~= nil and label.state == door.state then return end

	local texture
	if door.state then
		texture = "locked"
	else
		texture = "unlocked"
	end

	if label ~= nil then
		exports.interact:RemoveText(label.id)
	end

	local id = exports.interact:AddText({
		text = "<img src='assets/"..texture..".png' width=16 height=16/>",
		entity = entity,
		transparent = true,
	})

	self.labels[entity] = {
		id = id,
		state = door.state,
	}
end

function Site:RemoveDoor(object)
	label = self.labels[object]
	if label == nil then return end

	exports.interact:RemoveText(label.id)
	self.labels[object] = nil
end

function Site:ClearDoors()
	if self.labels == nil then return end

	for entity, label in pairs(self.labels) do
		exports.interact:RemoveText(label.id)
	end
	self.labels = nil
end