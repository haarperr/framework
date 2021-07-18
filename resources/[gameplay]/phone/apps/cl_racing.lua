local Racing = {}
Racing.Tracks = {}

-- Racing.Tracks = {
-- 	["Test Race"] = {
-- 		1,

-- 		-- The city.
-- 		vector3(-35.37091445922852, -956.8126831054688, 29.00163841247559),
-- 		vector3(99.69419860839844, -997.6578369140624, 28.922067642211918),
-- 		vector3(35.25237655639649, -1133.031494140625, 28.850858688354492),
-- 		vector3(-92.24303436279295, -1140.08935546875, 25.324302673339844),
-- 		vector3(-6.277346134185791, -878.2247314453125, 29.57566261291504),

-- 		-- A hill.
-- 		-- vector3(843.7771606445312, 978.683837890625, 240.45668029785156),
-- 		-- vector3(988.8462524414064, 932.60400390625, 214.18310546875),
-- 		-- vector3(977.7244873046876, 645.806640625, 164.02903747558597),
-- 	},
-- }

-- Racing.Viewing = 1

--[[ App Hooks ]]--
AppHooks["racing"] = function(content)
	local tracks = {}

	for name, track in pairs(Racing.Tracks) do
		table.insert(tracks, {
			name = name,
			checkpoints = Racing:ConvertTrack(track),
			laps = track[1] or 1,
		})
	end

	table.sort(tracks, function(a, b)
		return a.name < b.name
	end)

	return { tracks = tracks }
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		while not Racing.Index do
			Citizen.Wait(1000)
		end

		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local waypoint = Racing.Waypoints[Racing.Index]
		local nextWaypoint = Racing.Waypoints[Racing.Index + 1]
		local dist = #(coords - waypoint)
		local range = 20.0
		local markerId = 5
		local scale = vector3(1.0, 1.0, 1.0)
		local offset = 0.0
		local faceCamera = false
		local color

		if not nextWaypoint and (Racing.Lap or 1) < (Racing.Laps or 1) then
			nextWaypoint = Racing.Waypoints[1]
		end

		if nextWaypoint then
			local hasGround, groundZ = GetGroundZFor_3dCoord(waypoint.x, waypoint.y, waypoint.z)

			if math.abs(groundZ - waypoint.z) < 5.0 then
				color = { r = 255, g = 255, b = 64, a = 128 }
				faceCamera = true
				markerId = 2
				offset = 10.0
				scale = scale * 2.0
			else
				color = { r = 64, g = 64, b = 255, a = 128 }
				faceCamera = true
				markerId = 6
				scale = scale * 10.0
			end
		else
			color = { r = 255, g = 255, b = 255, a = 255 }
			faceCamera = true
			offset = 5.0
			scale = scale * 6.0
		end

		DrawMarker(markerId, waypoint.x, waypoint.y, waypoint.z + offset, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, scale.x, scale.y, scale.z, color.r, color.g, color.b, color.a, false, faceCamera, 1, false)

		if dist < range then
			Racing:NextStage()
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		while not Racing.EditingName do
			Citizen.Wait(1000)
		end

		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped)
		local track = Racing.Tracks[Racing.EditingName]
		local laps = track[1]

		for i = 2, #track do
			local coords = track[i]
			local target = track[i + 1]
			local color = { 245, 211, 101 }

			coords = vector3(coords.x, coords.y, coords.z)

			if not target and laps > 1 then
				target = track[2]
				color = { 126, 181, 222 }
			end

			local dist = #(coords - pedCoords)

			if dist < 100.0 then
				exports.oldutils:Draw3DText(vector3(coords.x, coords.y, coords.z + 2.0), tostring(i - 1), 2, 0.4)
			end

			if dist < 500.0 and target then
				DrawLine(coords.x, coords.y, coords.z + 0.0, target.x, target.y, target.z + 0.0, color[1], color[2], color[3], 255)
			end
		end

		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
function Racing:Save()
	SetResourceKvp(self.key, json.encode(self.Tracks))
end

function Racing:Load()
	self.Tracks = json.decode(GetResourceKvpString(self.key)) or {}
end

function Racing:PrepTrack(name)
	if self.preparing == name then return end

	local track = self.Tracks[name]
	if not track then return end

	local startCoords = track[2]
	if not startCoords then return end

	self.preparing = name

	startCoords = vector3(startCoords.x, startCoords.y, startCoords.z)

	exports.mythic_notify:SendAlert("inform", "Go to the starting line!", 7000)

	SetNewWaypoint(startCoords.x, startCoords.y)
	
	Citizen.CreateThread(function()
		while self.preparing == name do
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local dist = #(startCoords - coords)

			if dist < 30.0 then
				TriggerServerEvent("phone:startRace", track)
				
				self.Target = GetPlayerServerId(PlayerId())
				self.preparing = nil

				break
			end

			local blip = GetFirstBlipInfoId(8) or 0
			local blipCoords = GetBlipCoords(blip)

			if not DoesBlipExist(blip) or #(vector2(blipCoords.x, blipCoords.y) - vector2(startCoords.x, startCoords.y)) > 10.0 then
				self.noBlip = (self.noBlip or 0.0) + GetFrameTime()
			end
			
			if self.noBlip and self.noBlip > 1.0 then
				self.preparing = nil
				
				break
			end

			Citizen.Wait(0)
		end
	end)
end

function Racing:ClearTrack()
	if self.Blips then
		for _, blip in ipairs(self.Blips) do
			RemoveBlip(blip)
		end
		self.Blips = nil
	end
	self.Blips = {}
	self.Waypoints = {}
	self.Index = nil
	self.Track = nil
	self.Target = nil
end

function Racing:StartTrack(track)
	local target = self.Target
	local laps = track[1]

	self:ClearTrack()
	self.Target = target
	self.Index = 1
	self.Lap = 1
	self.Laps = laps
	
	for i = 2, #track do
		local coords = vector3(track[i].x, track[i].y, track[i].z)
		local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
		
		if i == #track and self.Laps == 1 then
			SetBlipSprite(blip, 38)
			SetBlipColour(blip, 0)
		else
			SetBlipSprite(blip, 270)
			SetBlipColour(blip, 5)
		end

		SetBlipHiddenOnLegend(blip, true)
		SetBlipScale(blip, 0.5)
		SetBlipAlpha(blip, 128)
		SetBlipDisplay(blip, 8)

		self.Blips[i - 1] = blip
		self.Waypoints[i - 1] = coords
	end

	self:NextStage()
end

function Racing:NextStage()
	self.Index = self.Index + 1
	local lastLap = (self.Lap or 1) >= (self.Laps or 1)
	
	if self.Index > #self.Waypoints then
		if lastLap then
			PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 0)
			
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped) or 0
			
			TriggerServerEvent("phone:leaveRace", Racing.Target, DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == ped)
			
			self.Index = nil
			self:ClearTrack()
	
			return
		else
			exports.mythic_notify:SendAlert("inform", ("Lap %s/%s!"):format(self.Lap or 1, self.Laps or 1), 8000)

			self.Lap = (self.Lap or 1) + 1
			self.Index = 1

			if lastLap then
				local finishBlip = self.Blips[#self.Blips]
				SetBlipSprite(finishBlip, 38)
				SetBlipColour(finishBlip, 0)
			end
		end
	end

	local blip = self.Blips[self.Index]
	local lastBlip = self.Blips[self.Index - 1]
	local nextBlip = self.Blips[self.Index + 1]

	if lastBlip then
		SetBlipAlpha(lastBlip, 128)
		SetBlipRoute(lastBlip, false)
		SetBlipScale(lastBlip, 0.5)
	end

	if nextBlip then
		SetBlipAlpha(nextBlip, 255)
		SetBlipScale(nextBlip, 0.75)
	end
	
	SetBlipAlpha(blip, 255)
	SetBlipRoute(blip, true)
	SetBlipScale(blip, 1.0)

	if not nextBlip and lastLap then
		SetBlipRouteColour(blip, 0)
	end

	PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0)
end

function Racing:ConvertTrack(track)
	local checkpoints = {}

	for i = 2, #track do
		local coords = track[i]
		local streetText = ""
		local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
		local zone = GetNameOfZone(coords.x, coords.y, coords.z)

		if streetName ~= 0 then
			streetText = GetStreetNameFromHashKey(streetName)
			if crossingRoad ~= 0 then
				streetText = streetText.." & "..GetStreetNameFromHashKey(crossingRoad)
			end
		end

		checkpoints[i - 1] = streetText..", "..GetLabelText(zone)
	end

	return checkpoints
end

function AddBlipForTrack(coords, isStart, isFinish)
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	UpdateBlip(blip, isStart, isFinish)

	return blip
end

function UpdateBlip(blip, isStart, isFinish)
	if isStart or isFinish then
		SetBlipSprite(blip, 38)
		SetBlipColour(blip, 0)
	else
		SetBlipSprite(blip, 270)
		SetBlipColour(blip, 5)
	end
end

-- Racing:StartTrack(Racing.Tracks["Test Race"])

--[[ NUI Callbacks ]]--
RegisterNUICallback("addTrack", function()
	local name = "New Track"
	local suffix = 1

	while Racing.Tracks[name] do
		suffix = suffix + 1
		name = "New Track "..tostring(suffix)
	end

	Racing.Tracks[name] = { 1 }
	Racing:Save()

	LoadApp("racing", {
		addTrack = {
			name = name,
			checkpoints = {},
			laps = 1,
		}
	})
end)

RegisterNUICallback("deleteTrack", function(data)
	local name = data.name
	if not name then return end

	Racing.Tracks[name] = nil
	Racing:Save()
end)

RegisterNUICallback("removeCheckpoint", function(data)
	local name = data.name or ""
	local track = Racing.Tracks[name]
	if not track then return end

	local index = (data.index or 1)
	
	if index == 1 then
		UpdateBlip(Racing.Editing[index + 1], true, false)
	end
	
	if index == #Racing.Editing then
		UpdateBlip(Racing.Editing[index - 1], false, true)
	end
	
	RemoveBlip(Racing.Editing[index])
	table.remove(Racing.Editing, index)

	table.remove(track, index + 1)

	Racing.Tracks[name] = track
end)

RegisterNUICallback("editTrack", function(data)
	if Racing.Editing then
		for k, blip in ipairs(Racing.Editing) do
			RemoveBlip(blip)
		end
	end

	local name = data.name
	Racing.EditingName = name

	if not name then return end

	local track = Racing.Tracks[name]
	if not track then return end

	Racing.Editing = {}
	
	for i = 2, #track do
		local checkpoint = track[i]
		Racing.Editing[i - 1] = AddBlipForTrack(track[i], i == 2, i == #track)
	end
end)

RegisterNUICallback("saveTracks", function(data)
	if data then
		local newName = data.newName
		local oldName = data.oldName
		local laps = tonumber(data.laps)
		
		if oldName and laps then
			Racing.Tracks[oldName][1] = laps
		end

		if newName and newName ~= oldName then
			Racing.Tracks[newName] = Racing.Tracks[oldName]
			Racing.Tracks[oldName] = nil
		end
	end
	Racing:Save()
end)

RegisterNUICallback("addCheckpoint", function(data)
	local name = data.name
	local index = data.index

	local track = Racing.Tracks[name]
	if not track then return end

	local coords = GetEntityCoords(PlayerPedId())

	table.insert(track, index + 2, { x = coords.x, y = coords.y, z = coords.z })
	table.insert(Racing.Editing, index + 1, AddBlipForTrack(coords, index == 0, index == #track - 2))

	if index == 0 then
		UpdateBlip(Racing.Editing[2], false, false)
	end
	
	UpdateBlip(Racing.Editing[index], index <= 1, false)

	LoadApp("racing", {
		updateTrack = {
			name = name,
			checkpoints = Racing:ConvertTrack(track),
			laps = track[1] or 1,
		},
	})

	Racing.Tracks[name] = track
end)

RegisterNUICallback("moveCheckpoint", function(data)
	local name = data.name
	local track = Racing.Tracks[name]
	if not track then return end

	local index = data.index
	
	local targetIndex = data.targetIndex
	local oldCheckpoint = track[index + 1]
	track[index + 1] = track[targetIndex + 1]
	track[targetIndex + 1] = oldCheckpoint

	local oldEditing = Racing.Editing[index]
	Racing.Editing[index] = Racing.Editing[targetIndex]
	Racing.Editing[targetIndex] = oldEditing

	UpdateBlip(Racing.Editing[index], false, targetIndex == #track)
	UpdateBlip(Racing.Editing[targetIndex], false, index == #track)
end)

RegisterNUICallback("startTrack", function(data)
	local name = data.name

	Racing:PrepTrack(name)
end)

--[[ Events ]]--
AddEventHandler("character:selected", function(character)
	Racing.key = ("NonstopTracks-ehSF_%s"):format(character.id)
	Racing:Load()
end)

AddEventHandler("phone:clientStart", function()
	Racing.key = ("NonstopTracks-ehSF_%s"):format(exports.character:Get("id"))
	Racing:Load()
end)

RegisterNetEvent("phone:informRace")
AddEventHandler("phone:informRace", function(source, coords)
	if type(coords) ~= "vector3" then return end
	
	local hasJoined = false
	local callbackId = "RaceJoin"..source
	local marker = exports.markers:CreateUsable(
		GetCurrentResourceName(),
		coords + vector3(0.0, 0.0, 2.0),
		callbackId,
		{ {47, "Join race"} },
		30.0,
		30.0,
		nil,
		{
			useWhileInVehicle = true,
		}
	)

	AddEventHandler("markers:use_"..callbackId, function()
		if hasJoined then return end

		hasJoined = true
		Racing.Target = source
		
		TriggerServerEvent("phone:joinRace", source)
	end)

	Citizen.CreateThread(function()
		local startTime = GetGameTimer()
		while GetGameTimer() - startTime < Races.JoinTime * 1000.0 do
			if #(GetEntityCoords(PlayerPedId()) - coords) < 30.0 then
				local timeLeft = math.floor(Races.JoinTime - (GetGameTimer() - startTime) / 1000.0)
				local text

				if timeLeft < 1 then
					text = "Starting race..."
				elseif hasJoined then
					text = ("Starting race in %s seconds..."):format(timeLeft)
				else
					text = ("Join race (%s seconds left...)"):format(timeLeft)
				end

				exports.markers:Set(marker, "helpText", { {47, text} })
			end

			Citizen.Wait(1000)
		end

		exports.markers:Remove(marker)
	end)
end)

RegisterNetEvent("phone:joinedRace")
AddEventHandler("phone:joinedRace", function(source)
	exports.mythic_notify:SendAlert("inform", ("[%s] has joined the race!"):format(source), 8000)
end)

RegisterNetEvent("phone:startRace")
AddEventHandler("phone:startRace", function(track)
	TriggerEvent("chat:addMessage", "Starting race!", "advert")

	local vehicle = GetVehiclePedIsIn(PlayerPedId())

	-- Input thread.
	Citizen.CreateThread(function()
		local startTime = GetGameTimer()
		while GetGameTimer() - startTime < Races.StartTime * 1000 do
			SetControlNormal(0, 76, 1.0)
			DisableControlAction(0, 25)
			DisableControlAction(0, 68)
			DisableAimCamThisUpdate()

			Citizen.Wait(0)
		end
	end)

	-- Countdown thread.
	Citizen.CreateThread(function()
		for i = 1, math.floor(Races.StartTime) do
			Citizen.Wait(1000)

			local sound
			local text
			if i == 4 then
				sound = "Count_Stop"
				text = "GO!"
			else
				sound = "Armed"
				text = tostring(4 - i).."..."
			end

			PlaySoundFrontend(-1, sound, "GTAO_Speed_Race_Sounds", 0)

			exports.mythic_notify:SendAlert("inform", text, 1000)
		end

		Racing:StartTrack(track)
	end)
end)

RegisterNetEvent("phone:finishedRace")
AddEventHandler("phone:finishedRace", function(source, isEnding, place)
	if isEnding then
		TriggerEvent("chat:addMessage", "The race has ended!", "advert")
		Racing:ClearTrack()
		return
	end

	local text = ""
	place = Races.Places[place or 0]

	if place then
		text = ("[%s] has completed in %s Place!"):format(source, place)
	else
		text = ("[%s] has completed the race!"):format(source)
	end
	
	TriggerEvent("chat:addMessage", text, "advert")
end)

--[[ Commands ]]--
RegisterCommand("race:leave", function(source, args, command)
	local target = Racing.Target
	if not target then return end

	TriggerServerEvent("phone:leaveRace", target, false)
	Racing:ClearTrack()
end)