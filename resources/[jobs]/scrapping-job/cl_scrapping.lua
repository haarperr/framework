Carrying = nil
DrawContext = exports.oldutils.DrawContext
Grids = {}
ModelCache = {}
NearestDist = nil
NearestEntity = nil
ObjectCache = {}
CurrentEmote = nil

--[[ Initialization ]]--
for k, v in ipairs(Config.Scrapping.Props) do
	v.index = k
	ModelCache[GetHashKey(v.Model)] = v
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(400)
		local pedPos = GetEntityCoords(PlayerPedId())
		NearestEntity = nil
		
		for entity, info in pairs(ObjectCache) do
			if DoesEntityExist(entity) then
				local pos = GetEntityCoords(entity)

				-- Sync the object.
				local grid = exports.oldgrids:GetGrid(pos, Config.GridSize)
				local gridData = Grids[grid]
				local shouldExist = true
				
				if gridData then
					for _, gridObject in ipairs(gridData) do
						-- if gridObject.index == info.index and #(gridObject.pos - info.pos) < 0.1 then
						if #(gridObject.pos - info.pos) < 0.1 then
							shouldExist = false
							break
						end
					end
				end

				if shouldExist then
					-- Find nearest.
					local dist = #(pedPos - pos)

					if not NearestEntity or dist < NearestDist then
						NearestDist = dist
						NearestEntity = entity
					end
				else
					SetEntityAsMissionEntity(entity, true, true)
					DeleteEntity(entity)
				end
			else
				ObjectCache[entity] = nil
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if NearestEntity and not Carrying then
			if DoesEntityExist(NearestEntity) then
				local entity = NearestEntity
				local pos = GetEntityCoords(entity)
				-- if CheckEntity(entity) and exports.utils:DrawContext("Pick up", pos) then
				if CheckEntity(entity) and DrawContext(nil, "Pick up", pos) then
					exports.mythic_progbar:Progress(Config.Scrapping.Action, function(wasCancelled)
						if wasCancelled then return end
						if not CheckEntity(entity, true) then return end
						PickUp(entity)
					end)
				end
			else
				NearestEntity = nil
			end
		end
	end
end)

--[[ Functions ]]--
function CheckEntity(entity, notify)
	local message = nil
	if not DoesEntityExist(entity) then
		message = "There's nothing here!"
	elseif #(GetEntityCoords(entity) - GetEntityCoords(PlayerPedId())) > Config.Scrapping.MaxDistance then
		message = "You're too far from that!"
	end

	if notify and message then
		TriggerEvent("chat:addMessage", {message = message, class = "error"})
	end

	return message == nil
end

function UpdateEntities()
	local ped = PlayerPedId()
	local objects = exports.oldutils:GetObjects()
	-- local nearestObject = nil
	-- local nearestDist = nil
	local pos = GetEntityCoords(ped)
	for k, object in pairs(objects) do
		if not ObjectCache[object] then
			local prop = ModelCache[GetEntityModel(object)]
			if prop and not IsEntityAttached(object) then
				ObjectCache[object] = { pos = GetEntityCoords(object), rot = GetEntityRotation(object) }
			end
		end
	end
end

function PickUp(entity)
	local model = GetEntityModel(entity)
	local prop = ModelCache[model]
	local cache = ObjectCache[entity]
	local emote = Config.Scrapping.CarryEmote

	if prop.UseBox then
		emote = "carrybox"
	else
		emote.Props[1].Model = prop.Model
		emote.Props[1].Offset = prop.Offset or emote.Props[1].Offset
		emote.DisableCombat = true
		emote.DisableCarMovement = true
		emote.DisableJumping = true
	end

	Carrying = prop

	CurrentEmote = exports.emotes:Play(emote, function()
		Carrying = nil
	end)
	
	TriggerServerEvent("scrapping:pickUp", cache.pos, prop.index)
	SetEntityAsMissionEntity(entity, true, true)
	DeleteEntity(entity)
end

--[[ Grids ]]--
AddEventHandler("grids:enter"..Config.GridSize, function(grid, nearbyGrids)
	TriggerServerEvent("scrapping:subscribe", grid)
	UpdateEntities()
end)

AddEventHandler("grids:exit"..Config.GridSize, function(grid, nearbyGrids)
	-- Clear cache for non-near grids.
	local tempGrids = {}
	for _, grid in ipairs(nearbyGrids) do
		tempGrids[grid] = true
	end
	for grid, data in pairs(Grids) do
		if not tempGrids[grid] then
			Grids[grid] = nil
		end
	end
end)

--[[ Events ]]--
RegisterNetEvent("emotes:cancel")
AddEventHandler("emotes:cancel", function(id)
	CurrentEmote = nil
	Carrying = nil
end)

RegisterNetEvent("scrapping:receiveGrids")
AddEventHandler("scrapping:receiveGrids", function(grid, data)
	Grids[grid] = data
end)

RegisterNetEvent("scrapping:testScrap")
AddEventHandler("scrapping:testScrap", function()
	local pos = GetEntityCoords(PlayerPedId())
	for k, v in ipairs(Config.Scrapping.Props) do
		local entity = CreateObject(
			GetHashKey(v.Model),
			pos.x,
			pos.y,
			pos.z,
			true,
			true,
			true
		)
	end
end)

UpdateEntities()