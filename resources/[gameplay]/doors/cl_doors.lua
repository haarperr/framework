Doors = Doors or {}
Doors.doors = {}
Doors.objects = {}
Doors.states = {}

--[[ Doors ]]--
function Doors:Register(object)
	if not DoesEntityExist(object) then return end

	local groupId = self.group
	if not groupId then return end

	local group = self.groups[groupId]
	if not group then return end

	local coords = GetEntityCoords(object)
	if #(coords - group.coords) > group.radius then return end

	local heading = GetEntityHeading(object)
	local model = GetEntityModel(object)
	local hash = GetCoordsHash(coords)
	local door = self.doors[hash]

	local override = (group.overrides or {})[hash] or {}
	if override.ignore then return end
	
	local overrideModel = Config.Doors[self.models[model]] or {}
	if overrideModel.Ignore then return end

	if door ~= nil then
		self:Destroy(hash)
	end

	if overrideModel.Default then
		heading = heading + overrideModel.Default
		SetEntityHeading(object, heading)
	end

	door = Door:Create({
		object = object,
		coords = coords,
		heading = heading,
		model = model,
		hash = hash,
		settings = overrideModel,
	})

	if door.settings.Electronic and GlobalState.powerDisabled then
		door:SetState(false, true)
		return
	end

	local state = self.states[hash]
	if state == nil then
		if override.locked ~= nil then
			state = override.locked
			door.override = 3
		elseif overrideModel.Locked ~= nil then
			state = overrideModel.Locked
			door.override = 2
		elseif group.locked then
			state = true
			door.override = 1
		end
	end

	door:SetState(state, false, true)
	
	self.doors[hash] = door
	self.objects[object] = hash
	self.states[hash] = nil

	Debug("register door", object, coords, door.state)
end

function Doors:Destroy(hash)
	-- Get the door.
	local door = self.doors[hash]
	if not door then return end

	-- Cache the current state.
	self.states[hash] = door.state
	
	-- Uncache the door.
	self.doors[hash] = nil
	self.objects[door.object] = nil
	
	-- Destroy the door.
	door:Destroy()
end

function Doors:UpdateGroup()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local nearestGroup = nil

	for groupId, group in pairs(self.groups) do
		local dist = #(group.coords - coords)
		if dist < group.radius then
			nearestGroup = groupId
			break
		end
	end

	if nearestGroup ~= self.group then
		Debug("group change", self.group, nearestGroup)
		
		local lastGroup = self.group
		self.group = nearestGroup
		self:ClearCache()

		if Config.Debug then
			if lastGroup then
				exports.interact:RemoveText("doorGroup-"..lastGroup)
			end

			if nearestGroup then
				local group = self.groups[nearestGroup]

				exports.interact:AddText({
					id = "doorGroup-"..nearestGroup,
					coords = group.coords,
					text = "Group: "..(group.name or nearestGroup).."<br>Radius: "..(group.radius or 0).."<br>Factions: "..json.encode(group.factions).."<br>Locked: "..tostring(group.locked),
				})
			end
		end
		
		TriggerServerEvent("doors:subscribe", nearestGroup)
	end
end

function Doors:Update()
	self:UpdateGroup()

	-- Check group.
	if not self.group then
		return
	end

	-- Find doors.
	local objects = exports.oldutils:GetObjects()
	for _, object in ipairs(objects) do
		if self:IsDoor(object) and not self:IsRegistered(object) then
			self:Register(object)
		end
	end
end

function Doors:UpdateDoors()
	-- Update doors.
	for hash, door in pairs(self.doors) do
		if not DoesEntityExist(door.object) then
			self:Destroy(hash)
		else
			door:Update()
		end
	end
end

function Doors:ClearCache()
	for hash, door in pairs(self.doors) do
		door:Destroy()
	end

	if self.group then
		exports.interact:RemoveText("doorGroup-"..self.group)
	end

	self.doors = {}
	self.objects = {}
	self.states = {}
end

function Doors:IsDoor(object)
	if not DoesEntityExist(object) then return end
	
	local model = GetEntityModel(object)

	return self.models[model] ~= nil
end

function Doors:IsRegistered(object)
	return self.objects[object] ~= nil
end

function Doors:Sync(doors)
	for hash, info in pairs(doors) do
		local door = self.doors[hash]
		if door then
			door.update = info.update
			door:SetState(info.state)
		else
			self.states[hash] = info.state
		end
	end
end

--[[ Functions ]]--
function GetDoorFromInteractable(interactable)
	local object = interactable.entity
	if not object or not DoesEntityExist(object) then return end

	local hash = Doors.objects[object]
	if not hash then return end

	local door = Doors.doors[hash]

	return door
end

function StartEffect(func, dict, ...)
	while not HasNamedPtfxAssetLoaded(dict) do
		RequestNamedPtfxAsset(dict)
		Citizen.Wait(50)
	end
	UseParticleFxAssetNextCall(dict)
	return func(...)
end

--[[ Exports ]]--
exports("SetDoorState", function(coords, state)
	local hash = GetCoordsHash(coords)
	TriggerServerEvent("doors:toggle", hash, state)
end)

exports("GetDoors", function()
	return Doors.doors
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		
		Doors:Update()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(20)

		Doors:UpdateDoors()
	end
end)

--[[ Events ]]--
AddEventHandler("interact:on_doorLock", function(interactable)
	local door = GetDoorFromInteractable(interactable)
	if not door then return end

	door:ToggleLock()
end)

AddEventHandler("interact:on_doorItem", function(interactable)
	local door = GetDoorFromInteractable(interactable)
	if not door then return end

	local item = interactable.items[1]
	if not item then return end

	door:UseItem(item.name)
end)

AddEventHandler("doors:stop", function()
	Doors:ClearCache()
end)

RegisterNetEvent("doors:inform")
AddEventHandler("doors:inform", function(doors)
	Doors:Sync(doors)
end)

RegisterNetEvent("powerDeactivated")
AddEventHandler("powerDeactivated", function()
	for hash, door in pairs(Doors.doors) do
		if door.settings.Electronic then
			exports.interact:Destroy(door.id)
			door:SetState(false, true)
		end
	end
end)