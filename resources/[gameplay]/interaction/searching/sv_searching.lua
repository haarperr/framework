local Distance = 1.5
local Searching = {}

local function StopSearching(source)
	local container = Searching[source]
	if not container then return end

	exports.inventory:Subscribe(source, container, false, false)

	Searching[source] = nil

	TriggerClientEvent("inventory:toggleMenu", source, false)
end

local function StartSearching(source, container)
	Searching[source] = container
	
	exports.inventory:Subscribe(source, container, true, false)
end

Functions["search"] = function(source, target, value)
	-- Stop searching old.
	StopSearching()

	if not value then
		-- Searching began, alert the player.
		return true
	elseif value ~= true then
		-- No longer searching.
		return false
	end

	-- Start searching.
	exports.log:Add({
		source = source,
		target = target,
		verb = "searched",
	})
	
	local targetContainer = exports.inventory:GetPlayerContainer(target)

	StartSearching(source, targetContainer)

	Citizen.CreateThread(function()
		while Searching[source] do
			local ped = GetPlayerPed(source)
			local targetPed = GetPlayerPed(target)

			local coords = GetEntityCoords(ped)
			local targetCoords = GetEntityCoords(targetPed)

			if #(coords - targetCoords) > Distance then
				StopSearching(source)

				break
			end

			Citizen.Wait(500)
		end
	end)

	return false
end