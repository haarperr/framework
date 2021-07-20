Main = {
	hasLoaded = false,
	hasSpawned = false,
}

--[[ Functions ]]--
function Main:Init()
	-- Get ped.
	local ped = PlayerPedId()
	if not ped or not DoesEntityExist(ped) then return end

	-- Update ped.
	SetEntityVisible(ped, false)
	SetEntityCollision(ped, false, false)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
	SetEntityCoords(ped, 0.0, 0.0, 0.0)

	-- Shutdown loading screen.
	ShutdownLoadingScreen()

	-- Set states.
	self.hasLoaded = true
	self.hasSpawned = false

	-- Start preview.
	Preview:Init()

	-- Trigger event.
	TriggerEvent("spawning:loaded")
end

function Main:Spawn(coords, static)
	-- Find nearest haven.
	if not coords then
		coords = vector3(0.0, 0.0, 0.0)
	end

	self:SpawnAtHaven(coords, static)

	-- Get ped.
	local ped = PlayerPedId()
	if not ped or not DoesEntityExist(ped) then return end

	-- Entity stuff.
	SetEntityVisible(ped, true)
	SetEntityCollision(ped, true, true)
	SetBlockingOfNonTemporaryEvents(ped, false)
	FreezeEntityPosition(ped, false)

	-- Set states.
	self.hasSpawned = true

	-- Remove preview.
	Preview:Destroy()

	-- Trigger events.
	TriggerEvent("spawning:spawned")
end

function Main:Update()
	if not self.hasLoaded and self.characters then
		self:Init()
	end
end

function Main:HasLoaded()
	return self.hasLoaded
end

function Main:HasSpawned()
	return self.hasSpawned
end

function Main:FindNearestHaven(coords)
	local nearestDist, nearestHaven = 0.0, nil
	for _, haven in ipairs(Config.Havens) do
		local havenCoords = haven.Static.Coords
		local dist = #(vector3(havenCoords.x, havenCoords.y, havenCoords.z) - vector3(coords.x, coords.y, coords.z))
		if not nearestHaven or dist < nearestDist then
			nearestDist = dist
			nearestHaven = haven
		end
	end

	return nearestHaven
end

function Main:SpawnAtHaven(coords, static)
	local haven = self:FindNearestHaven(coords)
	if not haven then return end

	DoScreenFadeOut(1000)
	Citizen.Wait(1000)

	local ped = PlayerPedId()
	local pose = (static and haven.Static) or haven.Poses[GetRandomIntInRange(1, #haven.Poses + 1)]

	SetEntityCoordsNoOffset(ped, pose.Coords.x, pose.Coords.y, pose.Coords.z)
	SetEntityHeading(ped, pose.Coords.w)

	WaitForGround(pose.Coords)
	
	DoScreenFadeIn(1000)

	if pose.Anim then
		exports.emotes:PerformEmote(pose.Anim)
	end
end

--[[ Exports ]]--
for k, v in pairs(Main) do
	if type(v) == "function" then
		exports(k, function(...)
			return Main[k](Main, ...)
		end)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(0)
	end
end)

--[[ Events ]]--
RegisterNetEvent("spawning:start", function()
	if GetResourceState("character") == "started" then
		Main.characters = exports.character:GetCharacters()
	end
end)

RegisterNetEvent("character:load", function(characters)
	Main.characters = characters
end)