CurrentRobbable = nil
IsRobbing = false
ItemEvents = {}
LastSiteId = nil
ObjectCache = {}
Robbables = {}
SiteData = nil
SiteId = nil
WaitingFor = nil

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		SiteId = FindNearestSite()
		local init = false
		
		if SiteId ~= LastSiteId then
			LastSiteId = SiteId

			ObjectCache = {}
			Robbables = {}
			SiteData = nil

			init = true
			
			TriggerServerEvent("robberies:subscribe", SiteId)
		end
		
		UpdateRobbables(SiteId, init)

		Citizen.Wait(500)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local nearestRobbable = nil
		local nearestDist = 0.5
		for _, robbable in ipairs(Robbables) do
			local r, g, b, a = 48, 64, 192, 128
			local coords = robbable.coords
			local hasGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)
			local dist = #(coords - pedCoords)
			if not CheckRobbable(coords) then
				r, g, b, a = 255, 0, 0, 255
			elseif dist < 1.0 then
				r, g, b, a = 64, 128, 255, 128
				if not nearestRobbable or dist < nearestDist then
					nearestRobbable = robbable
					nearestDist = dist
				end
			end
			DrawMarker(
				32, -- type.
				coords.x, -- posX.
				coords.y, -- posY.
				coords.z,-- groundZ + 0.1, -- posZ.
				0.0, -- dirX.
				0.0, -- dirY.
				0.0, -- dirZ.
				0.0, -- rotX.
				0.0, -- rotY.
				0.0, -- rotZ.
				0.1, -- scaleX.
				0.0, -- scaleY.
				0.1, -- scaleZ.
				r, -- red.
				g, -- green.
				b, -- blue.
				a, -- alpha.
				false, -- bobUpAndDown.
				true, -- faceCamera.
				2, -- p19.
				false, -- rotate.
				nil, -- textureDict.
				nil, -- textureName.
				false -- drawOnEnts.
			)
		end
		CurrentRobbable = nearestRobbable
	end
end)

--[[ Functions ]]--
function FindNearestSite()
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	local nearestDist = 0.0
	local nearest = nil
	for siteId, site in ipairs(Config.Robberies.Sites) do
		local dist = #(site.Center - pedCoords)
		if dist < (site.Radius or 15.0) and (not nearest or dist < nearestDist) then
			nearest = siteId
			nearestDist = dist
		end
	end
	return nearest
end

function GetSite(id)
	return Config.Robberies.Sites[id or SiteId]
end

function AddRobbable(id, _type, x, y, z, heading)
	Robbables[#Robbables + 1] = {
		id = id,
		type = _type,
		coords = vector3(x, y, z),
		heading = heading,
	}
end

function UpdateRobbables(siteId, init)
	if not siteId then return end
	local site = Config.Robberies.Sites[siteId]
	if not site then return end

	local objects = exports.oldutils:GetObjects()
	for k, robbable in ipairs(site.Robbables) do
		local robbableSettings = Config.Robbables[robbable.Id]
		if robbableSettings == nil then
			error("Unregistered robbable "..tostring(robbable.Id))
		else
			if init and robbable.Coords then
				for __, coords in ipairs(robbable.Coords) do
					AddRobbable(k, robbable.Id, coords.x, coords.y, coords.z, coords.w)
				end
			end
			if robbableSettings.Models then
				for __, object in ipairs(objects) do
					if ObjectCache[object] == nil then
						local model = GetEntityModel(object)
						local modelSettings = robbableSettings.Models[model]
						if modelSettings then
							local coords = GetEntityCoords(object)
							local offset = modelSettings.Offset
							if offset then
								coords = GetOffsetFromEntityInWorldCoords(object, offset.x, offset.y, offset.z)
							end
							AddRobbable(k, robbable.Id, coords.x, coords.y, coords.z, GetEntityHeading(object))
							ObjectCache[object] = true
						else
							ObjectCache[object] = false
						end
					end
				end
			end
		end
	end
end

function BeginRobbing(robbable)
	if not robbable then return end
	local robbableSettings = Config.Robbables[robbable.type]
	local isProgressing = false
	local wasCancelled = false
	local ped = PlayerPedId()

	local site = GetSite()
	if not site then return end

	local siteRobbable = site.Robbables[robbable.id]
	if not siteRobbable then return end
	
	for _, stage in ipairs(robbableSettings.Stages) do
		-- Check coords.
		if #(GetEntityCoords(ped) - robbable.coords) > 1.0 then
			return
		end
		-- Correct rotation each time.
		if robbable.heading then
			-- ClearPedTasksImmediately(ped)
			local targetCoords = robbable.coords + exports.misc:FromRotation(vector3(0.0, 0.0, robbable.heading + 90.0))
			TaskTurnPedToFaceCoord(ped, targetCoords.x, targetCoords.y, targetCoords.z, 1000)
		end
		-- Progress bars.
		isProgressing = true
		if stage.Duration then
			if Config.EnableDebug == 2 then
				stage.Duration = 4000
			end
			exports.mythic_progbar:Progress(stage, function(_wasCancelled)
				wasCancelled = _wasCancelled
				isProgressing = false
			end)
		else
			if stage.Hack then
				exports.inventory:ToggleMenu(false)
				TriggerEvent("mhacking:seqstart", stage.Hack.Length, stage.Hack.Duration, function(success, timeLeft, isFinished)
					wasCancelled = not success
					if not success then
						isProgressing = false
					elseif isFinished then
						isProgressing = false
					end
				end)
			elseif stage.Drill then
				TriggerEvent("Drilling:Start", function(success)
					wasCancelled = not success
					isProgressing = false
				end)
			elseif stage.Electrical then
				TriggerEvent("circlegame:create", stage.Electrical.Difficulty, function(success)
					if success then
						print("suceess")
					else
						print("faliure")
					end
				end)
			elseif stage.QTE then
				TriggerEvent("quickTime:begin", "linear", stage.QTE, function(success, _stage)
					if _stage >= #stage.QTE or not success then
						wasCancelled = not success
						isProgressing = false
					end
				end)
			end
			if stage.Anim then
				exports.emotes:PerformEmote(stage.Anim)
			end
		end
		while isProgressing do
			Citizen.Wait(0)
		end
		if not stage.Duration then
			exports.emotes:CancelEmote()
		end
		if wasCancelled then
			return
		end
		Citizen.Wait(1000)
	end

	TriggerServerEvent("robberies:finish", robbable.type, robbable.id, robbable.coords)
end
TriggerEvent("mhacking:hide")

function UseItem(item, slotId)
	if WaitingFor then return end
	if not CurrentRobbable then return end
	local robbableSettings = Config.Robbables[CurrentRobbable.type]
	if not robbableSettings then return end

	-- Get site.
	local site = GetSite()
	if not site then return end

	local robbable = site.Robbables[CurrentRobbable.id]
	if not robbable then return end

	-- Check if the item is used here.
	local usable = false
	if robbableSettings.Items or robbable.Items then
		for _, robbableItem in ipairs(robbableSettings.Items or robbable.Items) do
			if robbableItem == item.name then
				usable = true
			end
		end
	end

	if not usable then return end

	-- Check if it's been robbed.
	local coords = CurrentRobbable.coords
	if not CheckRobbable(coords) then return end

	WaitingFor = CurrentRobbable
	WaitingFor.cookie = GetGameTimer()
	
	-- Walk to the start.
	local ped = PlayerPedId()
	local canceled = false
	TaskGoToCoordAnyMeans(ped, coords.x, coords.y, coords.z, 1.0, 0, 0, 786603, 0xbf800000)
	Citizen.Wait(100)
	while GetIsTaskActive(ped, 224) do
		Citizen.Wait(0)
		for k, v in ipairs({ 22, 24, 25, 30, 31, 32, 33, 34, 35, 36 }) do
			if IsControlPressed(0, v) then
				canceled = true
				ClearPedTasks(ped)
				ClearPedSecondaryTask(ped)
				break
			end
		end
	end

	if not canceled then
		-- Disable control and let the script take over.
		Citizen.CreateThread(function()
			while IsRobbing or WaitingFor do
				for k, v in ipairs({ 22, 24, 25, 30, 31, 32, 33, 34, 35, 36, 38, 44 }) do
					DisableControlAction(0, v, true)
				end
				Citizen.Wait(0)
			end
		end)

		-- Turn to the start.
		if CurrentRobbable and CurrentRobbable.heading then
			local targetCoords = coords + exports.misc:FromRotation(vector3(0.0, 0.0, CurrentRobbable.heading + 90.0))
			TaskTurnPedToFaceCoord(ped, targetCoords.x, targetCoords.y, targetCoords.z, 1000)
			canceled = true
			Citizen.Wait(100)
			while GetIsTaskActive(ped, 225) do
				canceled = false
				Citizen.Wait(0)
			end
		end
		
		-- Begin the robbery.
		TriggerServerEvent("robberies:begin", WaitingFor.cookie, WaitingFor.type, WaitingFor.id, slotId)
	else
		WaitingFor = nil
	end
end

function CheckRobbable(coords)
	if not SiteData or not SiteData.robbables then return false end
	for _, robbable in ipairs(SiteData.robbables) do
		if #(robbable - coords) < 0.1 then
			return false
		end
	end
	return true
end

--[[ Events ]]--
RegisterNetEvent("robberies:sync")
AddEventHandler("robberies:sync", function(id, data)
	if id == SiteId then
		SiteData = data
	end
end)

RegisterNetEvent("robberies:begin")
AddEventHandler("robberies:begin", function(cookie)
	if not WaitingFor or cookie ~= WaitingFor.cookie then return end
	local robbable = WaitingFor
	local ped = PlayerPedId()
	IsRobbing = true
	Citizen.CreateThread(function()
		BeginRobbing(robbable)
		IsRobbing = false
	end)
	WaitingFor = nil
end)

RegisterNetEvent("robberies:failed")
AddEventHandler("robberies:failed", function(message)
	WaitingFor = nil
	if message then
		exports.mythic_notify:SendAlert("error", message, 8000)
	end
end)

AddEventHandler("robberies:clientStart", function()
	local function registerItem(item)
		if not ItemEvents[item] then
			local eventName = "inventory:use_"..item:gsub("%s+", "")
			RegisterNetEvent(eventName)
			ItemEvents[item] = AddEventHandler(eventName, UseItem)
			print("Registered item", item)
		end
	end
	for robbableId, robbable in pairs(Config.Robbables) do
		if robbable.Items then
			for _, item in ipairs(robbable.Items) do
				registerItem(item)
			end
		end
	end
	for siteId, site in pairs(Config.Robberies.Sites) do
		local robbables = site.Robbables
		if robbables then
			for _, robbable in ipairs(robbables) do
				if robbable.Items then
					for __, item in ipairs(robbable.Items) do
						registerItem(item)
					end
				end
			end
		end
	end
end)

AddEventHandler("robberies:stop", function()
	for item, eventData in pairs(ItemEvents) do
		RemoveEventHandler(eventData)
		print("Unregistered item", item)
	end
end)