Directions = { vector2(1, 0), vector2(0, 1), vector2(-1, 0), vector2(0, -1) }
EventData = {}
EventTokens = 0
Ids = {}
Info = {
	Grids = {},
	Players = {},
}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local updated = false
		for gridId, grid in pairs(Info.Grids) do
			for itemId, item in ipairs(grid) do
				local age = os.clock() - item.time
				if age > Config.DecayTime then
					table.remove(grid, itemId)
					updated = true
				end
			end

			-- Debug("Updating", gridId, "with", #grid.items, "items")
			
			CheckGrid(gridId)
		end
		if updated then
			Inform(gridId)
		end
		Citizen.Wait(5000)
	end
end)

--[[ Functions ]]--
function CachePlayer(source, gridId)
	UncachePlayer(source)
	local grid = Info.Grids[gridId]
	if grid then
		grid.players[source] = true
		Debug("Adding", source, "to", gridId)
	else
		grid = { items = {}, players = { [source] = true } }
		Info.Grids[gridId] = grid
		Debug("Creating", source, "in", gridId)
	end
	Info.Players[source] = gridId
end

function UncachePlayer(source)
	local gridId = Info.Players[source]
	if not gridId then return end

	local grid = Info.Grids[gridId]
	if not grid then return end

	grid.players[source] = nil
	Info.Players[source] = nil

	Debug("Removing", source, "from", gridId)
	CheckGrid(gridId)
end

function CheckGrid(gridId)
	local grid = Info.Grids[gridId]
	if not grid then return end

	local isEmpty = #grid.items <= 0
	if isEmpty then
		for player, _ in pairs(grid.players) do
			isEmpty = false
			break
		end
	end
	if isEmpty then
		Info.Grids[gridId] = nil
		Debug("Deleting", gridId, "empty")
	end
end

function Inform(gridId)
	local nearbyGrids = {}
	if type(gridId) == "number" then
		for _, nearbyGrid in ipairs(exports.oldgrids:GetNearbyGrids(gridId, Config.GridSize)) do
			nearbyGrids[nearbyGrid] = true
		end
	else
		nearbyGrids[gridId] = true
	end

	for player, playerGrid in pairs(Info.Players) do
		if nearbyGrids[playerGrid] then
			SendEvidence(player, playerGrid)
		end
	end
end

function SendEvidence(source, gridId)
	local payload = {}
	
	if type(gridId) == "number" then
		local nearbyGrids = exports.oldgrids:GetNearbyGrids(gridId, Config.GridSize)
		for _, gridId in ipairs(nearbyGrids) do
			local grid = Info.Grids[gridId]
			if grid then
				payload[#payload + 1] = grid.items
			end
		end
	else
		payload[1] = Info.Grids[instance]
	end

	Debug("Sending", gridId, "to", source)
	TriggerClientEvent("evidence:receiveEvidence", source, payload)
end

function Register(source, itype, coords, extra)
	local sceneIndex = -1

	-- Instances.
	local instance = exports.oldinstances:GetPlayerInstance(source)
	if instance ~= nil then
		instance = tostring(instance)
	end
	
	-- Scene.
	local gridId = instance or exports.oldgrids:GetGrid(coords, Config.GridSize)
	local grid = Info.Grids[gridId]
	
	if not grid then
		grid = { items = {}, players = {} }
		Info.Grids[gridId] = grid
	end
	
	local item = { time = os.clock(), coords = coords, itype = itype, extra = extra }
	
	table.insert(grid.items, item)

	Debug("Registering", itype, coords, gridId)
	
	Inform(gridId)
end

function GetId()
	local id = os.time()
	while Ids[id] do
		id = id + 1
	end
	Ids[id] = true
	return id
end

--[[ Events ]]--
AddEventHandler("evidence:start", function()
	Info = exports.cache:Get("EvidenceInfo") or Info
	Info.Players = {}
end)

AddEventHandler("evidence:stop", function()
	exports.cache:Set("EvidenceInfo", Info)
end)

RegisterNetEvent("evidence:register")
AddEventHandler("evidence:register", function(itype, coords, extra)
	local source = source

	if not itype then return end

	local settings = Config.Types[itype]
	if not settings then return end

	if settings.Register then
		local retval
		retval, extra = settings.Register(source, extra)
		if not retval then return end
	end
	
	-- Final registering.
	Register(source, itype, coords, extra)
end)

RegisterNetEvent("evidence:requestEvidence")
AddEventHandler("evidence:requestEvidence", function(toggle, coords)
	local source = source
	if toggle and type(coords) == "vector3" then
		local gridId = exports.oldgrids:GetGrid(coords, Config.GridSize)
		if gridId ~= Info.Players[source] then
			CachePlayer(source, gridId)
			SendEvidence(source, gridId)
		end
	else
		UncachePlayer(source)
	end
end)

RegisterNetEvent("evidence:pickup")
AddEventHandler("evidence:pickup", function(coords, itype)
	local source = source
	if type(coords) ~= "vector3" and type(itype) ~= "number" then return end

	-- local slot = exports.inventory:GetSlot(source, slotId, true)
	-- if not slot then return end

	if not exports.inventory:HasItem(source, "Evidence Bag") then return end
	if not exports.inventory:TakeItem(source, "Evidence Bag") then return end

	local extra = {}
	local gridId = exports.oldgrids:GetGrid(coords, Config.GridSize)--GetGridAtCoords(table.unpack(coords))

	local grid = Info.Grids[gridId]
	if not grid then return end

	exports.log:Add({
		source = source,
		verb = "collected",
		noun = "evidence",
	})

	for itemId, item in pairs(grid.items) do
		if item.itype == itype and not item.destroyed and #(item.coords - coords) < 0.001 then
			local settings = Config.Types[item.itype]
			if settings and settings.Pickup then
				local pickup = settings:Pickup(item)

				extra[1] = pickup
				extra[2] = { item.itype, item.extra }

				table.remove(grid.items, itemId)
				Inform(gridId)
				break
			end
		end
	end

	exports.inventory:GiveItem(source, "Sealed Evidence Bag", 1, extra)

	TriggerClientEvent("chat:notify", source, "Sealed a bag of evidence!", "inform")
	-- exports.inventory:SetSlot(source, slotId, slot, true)
end)

RegisterNetEvent("evidence:clearArea")
AddEventHandler("evidence:clearArea", function(slotId, coords)
	local source = source
	if type(coords) ~= "vector3" then return end

	local containerId = exports.inventory:GetPlayerContainer(source, true)
	if not containerId then return false end

	local slot = exports.inventory:ContainerGetSlot(containerId, tonumber(slotId))
	if not slot then return end

	local item = exports.inventory:GetItem(slot[1])
	if item.name ~= "Bleach" then return end

	exports.log:Add({
		source = source,
		verb = "cleared",
		noun = "area",
	})
	
	exports.inventory:TakeItem(source, item, 1, slotId)
	
	local gridIds = {}
	local instance = exports.oldinstances:GetPlayerInstance(source)
	if instance then
		gridIds = { tostring(instance) }
	else
		gridIds = exports.oldgrids:GetNearbyGrids(coords, Config.GridSize)
	end

	for _, gridId in ipairs(gridIds) do
		local grid = Info.Grids[gridId]
		if grid then
			-- local newItems = {}
			for itemId, item in ipairs(grid.items) do
				if #(item.coords - coords) < Config.BleachRange then
					-- table.remove(grid.items, itemId)
					-- newItems[#newItems + 1] = item
					item.destroyed = true
				end
			end
			-- grid.items = newItems
			CheckGrid(gridId)
			Inform(gridId)
		end
	end
end)

AddEventHandler("inventory:clearItem", function(sourceContainer, targetContainer, sourceId, targetId, sourceItem, targetItem)
	if sourceItem.name ~= "Tweezers" then return end

	local source = nil
	if sourceContainer.owner_type == "player" then
		source = sourceContainer.owner
	elseif targetContainer.owner_type == "player" then
		source = targetContainer.owner
	end

	if not source then return end

	local slot = exports.inventory:ContainerGetSlot(containerId, tonumber(slotId))
	if not slot then return end

	local extra = slot[4]
	if not extra then return end

	local info = extra[2]
	if not info then return end

	EventTokens = EventTokens + 1
	local token = EventTokens
	
	Citizen.CreateThread(function()
		local eventData = AddEventHandler("evidence:receiveDrop", function(coords, _token)
			local source = source
			
			if
				not EventData[source] or
				token ~= _token or
				type(coords) ~= "vector3"
			then
				return
			end
			
			exports.log:Add({
				source = source,
				verb = "dropped",
				noun = "evidence",
			})
			
			Register(source, info[1], coords, info[2])
			
			RemoveEventHandler(EventData[source])
			EventData[source] = nil
		end)
		
		EventData[source] = eventData

		TriggerClientEvent("evidence:requestDrop", source, token)
		RegisterNetEvent("evidence:receiveDrop")

		local startTime = os.clock()
		while EventData[source] and os.clock() - startTime < 5.0 do
			Citizen.Wait(20)
		end

		eventData = EventData[source]

		if eventData then
			RemoveEventHandler(eventData)
			EventData[source] = nil
		end
	end)

	-- TriggerClientEvent("inventory:register", source, info[1], false, info[2])
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	UncachePlayer(source)
end)

--[[ Commands ]]--
RegisterCommand("evidence:clearCache", function(source, args, command)
	if source ~= 0 then return end
	
	--print("Clearing evidence")

	for k, v in pairs(Info) do
		if type(v) == "table" then
			Info[k] = {}
		end
	end

	exports.cache:Set("EvidenceInfo", Info)
end, true)