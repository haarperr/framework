CurrentGrids = {}
Grids = {}
Info = {}
LastId = 0
NearestDist = 0.0
NearestNpc = nil

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local coords = GetEntityCoords(PlayerPedId())
		
		NearestDist = 0.0
		NearestNpc = nil

		for gridId, _ in pairs(CurrentGrids) do
			local grid = Grids[gridId]
			if grid then
				for id, __ in pairs(grid) do
					local info = Info[id]
					if info then
						local dist = #(info.coords - coords)
						if not NearestNpc or dist < NearestDist then
							NearestDist = dist
							NearestNpc = id
						end
					end
				end
			end
		end

		Citizen.Wait(200)
	end
end)

-- Brain thread.
Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		if NearestNpc then
			local info = Info[NearestNpc]
			if not info then goto continue end

			if info.ped and DoesEntityExist(info.ped) then
				SetIkTarget(info.ped, 1, playerPed, 0, 0.0, 0.0, 0.5, 0, 0, 0)
			end
		else
			Citizen.Wait(500)
		end
		::continue::
		Citizen.Wait(0)
	end
end)

-- Dialogue thread.
Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		if NearestNpc then
			local info = Info[NearestNpc]
			if not info then goto continue end

			if NearestDist < Config.InteractDistance and IsControlJustPressed(0, 46) and info.InvokeDialogue and not exports.health:IsPedDead(PlayerPedId()) then
				info:InvokeDialogue()
			end
		else
			Citizen.Wait(500)
		end
		::continue::
		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
function Create(info)
	if not exports.character:Get("id") then return end
	
	if not info.model then
		error("No model specified")
	elseif not IsModelValid(info.model) then
		error("Invalid model", info.model)
	end

	while not HasModelLoaded(info.model) do
		RequestModel(info.model)
		Citizen.Wait(20)
	end

	local x, y, z = info.coords.x, info.coords.y, info.coords.z
	
	local ped = CreatePed(info.type or 4, info.model, x, y, z, info.heading, info.isNetwork or false, info.netMissionEntity or false)
	SetEntityCoordsNoOffset(ped, x, y, z)
	SetBlockingOfNonTemporaryEvents(ped, true)
	SetPedCanBeTargetted(ped, false)
	SetPedDefaultComponentVariation(ped)
	SetPedCanRagdoll(ped, false)
	SetEntityInvincible(ped, true)
	FreezeEntityPosition(ped, true)
	
	Debug("Created ped", info.id, ped)

	info.ped = ped

	-- Setup custom appearances.
	if info.data then
		exports.customization:SetData(ped, info.data)
	end
	
	-- Setup and call animation.
	if info.idle then
		info.Animate = Animate
		info:Animate()
	end
	
	-- Setup dialogue.
	if info.stages then
		for k, v in pairs(Dialogue) do
			if info[k] == nil then
				info[k] = v
			end
		end
		-- info.dialogue = Dialogue
	end
end

function Add(info)
	Debug("Adding NPC", info.id, info.coords, info.instance)

	if not info.coords then
		error("Missing coords")
	elseif type(info.coords) == "vector4" then
		info.heading = info.coords.w
		info.coords = vector3(info.coords.x, info.coords.y, info.coords.z)
	end

	local id = info.id

	if not id then
		LastId = LastId + 1
		id = LastId
	elseif Info[id] then
		-- Overwrite if it exists.
		local info = Info[id]
		if info.ped and DoesEntityExist(info.ped) then
			DeleteEntity(info.ped)
		end
	end
	
	-- Grid.
	local gridId = info.instance or exports.grids:GetGrid(info.coords, Config.GridSize)
	local grid = Grids[gridId]
	if not grid then
		grid = {}
		Grids[gridId] = grid
	end
	
	-- Info.
	info.id = id
	info.grid = grid
	
	grid[id] = true

	Info[id] = info

	-- Ped creation.
	if info.instance then
		local currentInstance = exports.instances:GetPlayerInstance()
		if currentInstance and currentInstance.id == info.instance then
			CurrentGrids[info.instance] = true
			Create(info)
		end
	else
		local grids = exports.grids:GetNearbyGrids(GetEntityCoords(PlayerPedId()), Config.GridSize)
		for _, nearbyGrid in ipairs(grids) do
			if nearbyGrid == gridId then
				CurrentGrids[gridId] = true
				Create(info)
				break
			end
		end
	end
	
	return id
end
exports("Add", Add)

function Set(id, key, value)
	local info = Info[id]
	if not info then return end

	info[key] = value
end
exports("Set", Set)

function Remove(id)
	local info = Info[id]
	if not info then return end

	-- Clear grid.
	if info.grid then
		local grid = Grids[info.grid]
		if grid then
			Grids[info.grid] = nil
		end
	end

	-- Delete ped.
	if info.ped and DoesEntityExist(info.ped) then
		DeleteEntity(info.ped)
	end
	
	-- Clear cache.
	Info[id] = nil
end
exports("Remove", Remove)

function Animate(self)
	while not HasAnimDictLoaded(self.idle.dict) do
		RequestAnimDict(self.idle.dict)
		Citizen.Wait(20)
	end
	
	local ped = self.ped
	TaskPlayAnim(ped, self.idle.dict, self.idle.name, 10.0, 10.0, -1, self.idle.flag or 1, 0.0)

	if self.idle.props then
		for k, prop in ipairs(self.idle.props) do
			exports.oldutils:PedCreateObject(ped, prop)
		end
	end
end

function AddNpc(info)
    Citizen.CreateThread(function()
        Add(info)
    end)
end

--[[ Events ]]--
AddEventHandler("grids:enter"..Config.GridSize, function(grid, nearbyGrids)
	local lastGrids = CurrentGrids
	CurrentGrids = {}

	for _, gridId in ipairs(nearbyGrids) do
		CurrentGrids[gridId] = true

		local grid = Grids[gridId]
		if grid then
			for id, _ in pairs(grid) do
				local info = Info[id]
				if info and (not info.ped or not DoesEntityExist(info.ped)) then
					Create(info)
				end
			end
		end
	end

	for gridId, _ in pairs(lastGrids) do
		if type(gridId) == "string" then
			CurrentGrids[gridId] = _
		else
			if not CurrentGrids[gridId] then
				local grid = Grids[gridId]
				if grid then
					for id, __ in pairs(grid) do
						local info = Info[id]
						if info and info.ped and DoesEntityExist(info.ped) then
							DeleteEntity(info.ped)
						end
					end
				end
			end
		end
	end
end)

RegisterNetEvent("instances:enter")
AddEventHandler("instances:enter", function(instance)
	local grid = Grids[instance.id]
	if not grid then return end

	for gridId, _ in pairs(CurrentGrids) do
		local grid = Grids[gridId]
		if grid then
			for id, __ in pairs(grid) do
				local info = Info[id]
				if info and info.ped and DoesEntityExist(info.ped) then
					DeleteEntity(info.ped)
				end
			end
		end
	end
	for id, _ in pairs(grid) do
		local info = Info[id]
		if info and (not info.ped or not DoesEntityExist(info.ped)) then
			Create(info)
		end
	end
	CurrentGrids[instance.id] = true
end)

RegisterNetEvent("instances:exit")
AddEventHandler("instances:exit", function()
	for gridId, _ in pairs(CurrentGrids) do
		if type(gridId) == "string" then
			local grid = Grids[gridId]
			if grid then
				for id, __ in pairs(grid) do
					local info = Info[id]
					if info and info.ped and DoesEntityExist(info.ped) then
						DeleteEntity(info.ped)
					end
				end
			end
			CurrentGrids[gridId] = nil
		end
	end
end)

AddEventHandler("npcs:start", function()
	
end)

AddEventHandler("npcs:stop", function()
	for id, info in pairs(Info) do
		if info.ped and DoesEntityExist(info.ped) then
			DeleteEntity(info.ped)
		end
	end
end)

--[[ Test ]]--
-- Citizen.CreateThread(function()
-- 	local t = vector3(1041.4793701171875, 3071.005615234375, 41.99726104736328)
-- 	for i = 1, 1000 do
-- 		Add({
-- 			model = "mp_m_freemode_01",
-- 			coords = t + vector3(i * 10.0, i * 2.5, 10.0),
-- 			heading = 0.0,
-- 			isNetwork = false,
-- 			netMissionEntity = false,
-- 			data = json.decode('[1,20,45,7,11,[3,6,4,5,5,6,7,6,7,6,7,6,3,5,7,5,7,6,7,4],[[0,0.0,1],[0,0.74,4],[16,0.96,4],[13,0.43,1],[0,0.0,1],[0,0.0,1],[0,0.13,1],[0,0.11,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1]],[[0,0,1,1],[0,0,1,1],[0,0,1,1],[11,0,1,1],[25,0,1,1],[0,0,1,1],[1,2,1,1],[0,0,1,1],[15,0,1,1],[0,0,1,1],[0,0,1,1],[89,0,1,1]],0,[[0,0],[0,0],[0,0],[],[],[],[0,0],[0,0]],[{"1":1},[],[]]]'),
-- 		})
-- 		-- Create(4, "csb_stripper_01", t + vector3(i * 10.0, i * 2.5, 10.0), 0.0, false, false, {
			
-- 		-- })
-- 	end
-- end)