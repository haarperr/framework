DrawContext = exports.utils.DrawContext
Grids = {}
GridSize = 2
Markers = {}
NearbyMarkers = {}
TextEntries = {}
HideForFrame = 0

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local nearbyGrids = exports.grids:GetNearbyGrids(coords, GridSize)

		NearbyMarkers = {}

		for _, nearbyGrid in ipairs(nearbyGrids) do
			local markers = Grids[nearbyGrid]
			if markers then
				for __, marker in ipairs(markers) do
					if Markers[marker] then
						NearbyMarkers[#NearbyMarkers + 1] = marker
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		while GetGameTimer() - HideForFrame < 40 do
			Citizen.Wait(0)
		end
		local ped = PlayerPedId()
		for k, markerId in ipairs(NearbyMarkers) do
			local marker = Markers[markerId]
			if marker then
				local dist = #(GetEntityCoords(ped) - marker.pos)
				local shouldDisplay = true
				if marker.condition then
					local status, result = pcall(function()
						return marker.condition()
					end)
					shouldDisplay = result
				end
				if shouldDisplay and dist < marker.drawRadius then
					local floatCoords = nil
					local floatId = 1
					local canActivate = dist < marker.radius and (marker.useWhileInVehicle or not IsPedInAnyVehicle(ped, true))

					if marker.float then
						floatCoords = marker.pos
						showContext = true
						if not canActivate then
							floatId = 2
						end
					end
					
					local activated = DrawContext(nil, marker.helpText, floatCoords, floatId)

					-- Usable markers.
					if marker.id ~= nil and activated and canActivate then
						TriggerEvent("markers:use_"..marker.id)
					end

					-- Draw marker if not hidden.
					if not marker.hidden and not marker.float then
						local pos = marker.pos
						if not marker.keepZ then
							local hasGround, groundZ = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z)
							if hasGround then
								pos = vector3(pos.x, pos.y, groundZ)
							end
						end

						DrawMarker(
							marker.type,
							pos.x, pos.y, pos.z,
							marker.dir.x, marker.dir.y, marker.dir.z,
							marker.rot.x, marker.rot.y, marker.rot.z,
							marker.scale.x, marker.scale.y, marker.scale.z,
							marker.col.r, marker.col.g, marker.col.b, marker.col.a,
							marker.bobUpAndDown,
							marker.faceCamera, 2,
							marker.rotate,
							marker.textureDict,
							marker.textureName,
							marker.drawOnEnts
						)
					end
				end
			end
		end
	end
end)

--[[ Functions ]]--
function CreateBlip(data)
	local blip = AddBlipForCoord(data.pos.x, data.pos.y, data.pos.z)
	SetBlipSprite(blip, data.blip.id or 66)
	SetBlipAsShortRange(blip, true)
	SetBlipScale(blip, data.blip.scale or 1.0)
	SetBlipColour(blip, data.blip.color or 0)
	SetBlipHiddenOnLegend(blip, data.blip.hidden or false)

	local label = data.blip.name or "Unknown"
	local key = "Markers_"..label

	if not TextEntries[label] then
		TextEntries[key] = label
		AddTextEntry(key, label)
	end

	BeginTextCommandSetBlipName(key)
	EndTextCommandSetBlipName(blip)

	return blip
end

function Create(resource, data)
	local handle = (exports.cache:Get("LastMarkerHandle") or 0) + 1
	exports.cache:Set("LastMarkerHandle", handle)

	data.handle = handle
	
	-- Resource cache.
	data.resource = resource

	-- Default for help text.
	if not data.helpText and data.callback then
		data.helpText = "use"
	end

	-- Default for the color's alpha channel.
	if data.col and not data.col.a then
		data.col.a = 255
	end
	
	-- Defaults for the marker info.
	if not data.hidden and not data.float then
		data.type = data.type or 0
		data.pos = data.pos or vector3(0, 0, 0)
		data.dir = data.dir or vector3(0, 0, 0)
		data.rot = data.rot or vector3(0, 0, 0)
		data.scale = data.scale or vector3(1, 1, 1)
		data.col = data.col or { r = 255, g = 255, b = 255, a = 255 }
		data.bobUpAndDown = data.bobUpAndDown or false
		data.faceCamera = data.faceCamera or false
		data.rotate = data.rotate or false
		data.textureDict = data.textureDict or nil
		data.textureName = data.textureName or nil
		data.drawOnEnts = data.drawOnEnts or false
	end
	
	-- Default for other settings.
	data.callback = data.callback or nil
	data.radius = data.radius or 1.0
	data.drawRadius = data.drawRadius or 10.0

	-- Create a blip.
	if data.blip then
		data.blip.handle = CreateBlip(data)
	end

	-- Cache the marker.
	Markers[handle] = data

	-- Cache the grid.
	local grid = exports.grids:GetGrid(data.pos, GridSize)

	if not Grids[grid] then
		Grids[grid] = { handle }
	else
		table.insert(Grids[grid], handle)
	end
	
	-- Return the handle.
	return handle
end
exports("Create", Create)

function Set(handle, key, value)
	local marker = Markers[handle]
	if not marker then return end

	marker[key] = value
end
exports("Set", Set)

function Remove(handle)
	local marker = Markers[handle]
	if not marker then return end

	if marker.blip and DoesBlipExist(marker.blip.handle) then
		RemoveBlip(marker.blip.handle)
	end

	Markers[handle] = nil
end
exports("Remove", Remove)

function CreateUsable(resource, pos, id, helpText, drawRadius, radius, blip, data)
	if type(pos) == "vector4" then
		pos = vector3(pos.x, pos.y, pos.z)
	end
	
	data = data or {}
	data.blip = blip
	data.col = data.col or { r = 25, g = 146, b = 245 }
	data.drawRadius = data.drawRadius or drawRadius or 5.0
	data.float = data.float or true
	data.helpText = helpText
	data.id = id
	data.pos = pos
	data.radius = data.radius or radius or 2.5
	data.type = data.type or 25
	
	return exports.markers:Create(resource, data)
end
exports("CreateUsable", CreateUsable)

function HideThisFrame()
	HideForFrame = GetGameTimer()
end
exports("HideThisFrame", HideThisFrame)

--[[ Resource Events ]]--
AddEventHandler("markers:start", function(hasCache)
	if not hasCache then return end

	Grids = exports.cache:Get("Grids") or Grids
	Markers = exports.cache:Get("Markers") or Markers
end)

AddEventHandler("markers:stop", function(hasCache)
	if not hasCache then return end

	exports.cache:Set("Grids", Grids)
	exports.cache:Set("Markers", Markers)
end)

AddEventHandler("onResourceStop", function(resourceName)
	if resourceName == GetCurrentResourceName() then return end

	for k, marker in pairs(Markers) do
		if marker.resource == resourceName then
			Remove(marker.handle)
		end
	end
end)

-- local t = {x = 313.65426635742, y = -278.70379638672, z = 54.17077255249, h = 335.43649291992}
-- TriggerEvent("marker:createUsable", vector3(t.x,t.y,t.z), function() print("WOWWW") end, "view your account", { hidden = true })