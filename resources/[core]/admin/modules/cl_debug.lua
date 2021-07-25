Debugger = { texts = {} }

--[[ Functions ]]--
function Debugger:Create()
	
end

function Debugger:Destroy()
	for entity, id in pairs(self.texts) do
		exports.interact:RemoveText(id)
	end
	self.texts = {}
end

function Debugger:Update()
	local coords = GetFinalRenderedCamCoord()

	local peds = exports.oldutils:GetPeds()
	local objects = exports.oldutils:GetVehicles()
	local vehicles = exports.oldutils:GetObjects()

	self.tempCache = {}

	for _, ped in ipairs(peds) do
		if IsPedAPlayer(ped) then
			self:RegisterPlayer(ped)
		elseif #(coords - GetEntityCoords(ped)) < 50.0 then
			self:RegisterEntity(ped)
		end
	end

	for _, object in ipairs(objects) do
		if #(coords - GetEntityCoords(object)) < 50.0 then
			self:RegisterEntity(object)
		end
	end

	for _, vehicle in ipairs(vehicles) do
		if #(coords - GetEntityCoords(vehicle)) < 50.0 then
			self:RegisterEntity(vehicle)
		end
	end

	for entity, id in pairs(self.texts) do
		if self.tempCache[entity] == nil then
			exports.interact:RemoveText(id)
			self.texts[entity] = nil
		end
	end
end

function Debugger:RegisterEntity(entity, text)
	if not NetworkGetEntityIsNetworked(entity) then
		return
	end

	self.tempCache[entity] = true
	if self.texts[entity] then return end
	
	local id = "d"..entity
	local type = GetEntityType(entity)
	local offset
	
	if type == 1 then
		text = text or "Ped"
		offset = vector3(0, 0, 1)
	elseif type == 2 then
		text = text or "Vehicle"
		offset = vector3(0, 0, -1)
	elseif type == 3 then
		text = text or "Object"
		offset = vector3(0, 0, 0)
	else
		text = text or ""
		offset = vector3(0, 0, 0)
	end

	text = text.."<br>ID: "..NetworkGetNetworkIdFromEntity(entity)
	text = text.."<br>Owner: ["..NetworkGetEntityOwner(entity).."]"

	exports.interact:AddText({
		id = id,
		text = text,
		entity = entity,
		offset = offset,
	})

	self.texts[entity] = id
end

function Debugger:RegisterPlayer(ped)
	local serverId = GetPlayerServerId(NetworkGetEntityOwner(ped))
	local player = Admin:GetPlayer(serverId)

	local text = ("%s [%s]"):format(player.name, serverId)

	self:RegisterEntity(ped, text)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Debugger.active then
			Debugger:Update()
		end

		Citizen.Wait(1000)
	end
end)

--[[ Hooks ]]--
Admin:AddHook("toggle", "debugger", function(active)
	print("set debugger active?", active)
	Debugger.active = active
	
	if active then
		Debugger:Create()
	else
		Debugger:Destroy()
	end
end)

--[[ Events ]]--
AddEventHandler(Admin.event.."stop", function()
	Debugger:Destroy()
end)