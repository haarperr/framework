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
						local dist = #(vector3(info.coords.x, info.coords.y, info.coords.z) - coords)
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
			local state = LocalPlayer.state or {}

			if NearestDist < Config.InteractDistance and IsControlJustPressed(0, 46) and info.InvokeDialogue and not state.immobile then
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

	local x, y, z = info.coords.x, info.coords.y, info.coords.z
	
	
	local ped = exports.customization:CreatePed({
		model = info.model,
		appearance = info.appearance,
		features = info.features,
	}, info.coords)

	SetEntityCoordsNoOffset(ped, info.coords.x, info.coords.y, info.coords.z)
	SetBlockingOfNonTemporaryEvents(ped, true)
	SetPedCanBeTargetted(ped, false)
	SetPedCanRagdoll(ped, false)
	SetEntityInvincible(ped, true)
	FreezeEntityPosition(ped, true)
	
	Debug("Created ped", info.id, ped)

	info.ped = ped
	
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
		info.coords = vector4(info.coords.x, info.coords.y, info.coords.z, info.coords.w)
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
	local gridId = info.instance or exports.oldgrids:GetGrid(info.coords, Config.GridSize)
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
		local currentInstance = exports.oldinstances:GetPlayerInstance()
		if currentInstance and currentInstance.id == info.instance then
			CurrentGrids[info.instance] = true
			Create(info)
		end
	else
		local grids = exports.oldgrids:GetNearbyGrids(GetEntityCoords(PlayerPedId()), Config.GridSize)
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

RegisterNetEvent("oldinstances:join")
AddEventHandler("oldinstances:join", function(instance)
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

RegisterNetEvent("oldinstances:left")
AddEventHandler("oldinstances:left", function()
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

AddEventHandler("oldnpcs:start", function()
	
end)

AddEventHandler("oldnpcs:stop", function()
	for id, info in pairs(Info) do
		if info.ped and DoesEntityExist(info.ped) then
			DeleteEntity(info.ped)
		end
	end
end)