Npcs = Npcs or {}
Npcs.client = true
Npcs.grids = {}
Npcs.cached = {}

--[[ Templates ]]--
Npcs.NEVERMIND = {
	text = "Nevermind.",
	dialogue = "Alright.",
	back = true,
	callback = function(self)
		self:SetState("idle")
	end,
}

--[[ Functions ]]--
function Npcs:_Register(npc)
	npc:CacheGrid()
end

function Npcs:Update()
	for gridId, _ in pairs(self.cached) do
		local grid = self.grids[gridId]
		if grid then
			for npcId, _ in pairs(grid) do
				local npc = self.npcs[npcId]
				if npc then
					npc:_Update()
				end
			end
		end
	end
end

function Npcs:UpdateGrid(grids)
	local cached = {}
	for _, gridId in ipairs(grids) do
		if not self.cached[gridId] then
			self.cached[gridId] = true
			self:LoadGrid(gridId)
		end
		cached[gridId] = true
	end

	for gridId, _ in pairs(self.cached) do
		if not cached[gridId] then
			self.cached[gridId] = nil
			self:UnloadGrid(gridId)
		end
	end
end

function Npcs:LoadGrid(gridId)
	local grid = self.grids[gridId]
	if not grid then return end
	
	for npcId, _ in pairs(grid) do
		local npc = self.npcs[npcId]
		if npc then
			npc:Load()
		end
	end
end

function Npcs:UnloadGrid(gridId)
	local grid = self.grids[gridId]
	if not grid then return end

	for npcId, _ in pairs(grid) do
		local npc = self.npcs[npcId]
		if npc then
			npc:Unload()
		end
	end
end

--[[ Events ]]--
AddEventHandler(Npcs.event.."start", function()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	Npcs:UpdateGrid(Grids:GetNearbyGrids(coords, Npcs.Config.GridSize))
end)

AddEventHandler("grids:enter"..Npcs.Config.GridSize, function(grid, nearby)
	Npcs:UpdateGrid(nearby)
end)

AddEventHandler("interact:on_npc", function(interactable)
	local npc = Npcs.npcs[interactable.npc or false]
	if not npc then return end

	npc:Interact()
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Npcs:Update()

		Citizen.Wait(200)
	end
end)