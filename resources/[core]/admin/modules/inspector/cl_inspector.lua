Inspector = {
	colors = {
		[0] = { 255, 0, 0 },
		[1] = { 0, 255, 0 },
		[2] = { 255, 255, 0 },
		[3] = { 0, 255, 255 },
	},
	lines = {},
}

function Inspector:Update()
	self:UpdateHit()
	self:DrawLines()

	if IsDisabledControlJustPressed(0, 214) and DoesEntityExist(self.entity or 0) and NetworkGetEntityIsNetworked(self.entity) then
		TriggerServerEvent("admin:delete", NetworkGetNetworkIdFromEntity(self.entity))
	end
end

function Inspector:UpdateHit()
	local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = Raycast()
	
	if not didHit then
		self.entity = nil
		return
	end

	self.entity = entity
	
	-- Get entity info.
	local entityType = GetEntityType(entity) or 0
	local target = hitCoords + surfaceNormal * 2.0

	-- Create line.
	local r, g, b = table.unpack(self.colors[entityType])
	local lastLine = self.lines[#self.lines]

	-- Draw line.
	if lastLine and #(hitCoords - vector3(lastLine[1], lastLine[2], lastLine[3])) < 0.1 then
		DrawLine(
			hitCoords.x, hitCoords.y, hitCoords.z,
			target.x, target.y, target.z,
			r, g, b, 255
		)

		return
	end

	-- Cache line.
	table.insert(self.lines, {
		hitCoords.x, hitCoords.y, hitCoords.z,
		target.x, target.y, target.z,
		r, g, b, 255
	})

	if #self.lines > 20 then
		table.remove(self.lines, 1)
	end
end

function Inspector:DrawLines()
	for k, line in ipairs(self.lines) do
		line[10] = math.ceil(k / #self.lines * 255)
		DrawLine(table.unpack(line))
	end
end

function Inspector:Activate()
	if self.active then return end
	self.active = true
	
end

function Inspector:Deactivate()
	if not self.active then return end
	self.active = false
	
end

function Inspector:Delete()

end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Inspector.active then
			Inspector:Update()
		end

		Citizen.Wait(0)
	end
end)

--[[ Commands ]]--
RegisterKeyMapping("+nsrp_inspector", "Admin - Inspector", "KEYBOARD", "PRIOR")
RegisterCommand("+nsrp_inspector", function(source, args, command)
	if not exports.user:IsMod() then return end

	if Inspector.active then
		Inspector:Deactivate()
	else
		Inspector:Activate()
	end
end, true)