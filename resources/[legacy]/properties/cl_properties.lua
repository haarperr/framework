Blips = nil
Character = nil
DrawContext = exports.oldutils.DrawContext
GridCache = {}
LastActivated = nil
LastActivatedCoords = nil
LastActivatedTime = 0
NearestProperty = nil
NearProperties = {}
Properties = {}
WasLocked = nil

--[[ Threads ]]--
-- Process cache.
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		
		NearProperties = {}

		local grid = Grids:GetGrid(GetEntityCoords(PlayerPedId()), Config.GridSize)
		local nearbyGrids = Grids:GetNearbyGrids(grid, Config.GridSize)
		for _, nearbyGrid in ipairs(nearbyGrids) do
			if GridCache[nearbyGrid] then
				for k, property in ipairs(GridCache[nearbyGrid]) do
					NearProperties[#NearProperties + 1] = property
				end
			end
		end
	end
end)

-- Process markers.
Citizen.CreateThread(function()
	while true do
		Character = exports.character:GetCharacter()

		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		while not Character do
			Citizen.Wait(1000)
		end

		NearestProperty = nil
		
		local marker = Config.Marker
		local playerCoords = GetEntityCoords(PlayerPedId())

		if LastActivatedCoords and #(LastActivatedCoords - playerCoords) > 3.0 then
			exports.mythic_notify:PersistentAlert("END", "property")
			LastActivatedCoords = nil
			LastActivated = nil
		end
		
		for _, id in pairs(NearProperties) do
			local property = Properties[id]
			local coords = vector3(property.x, property.y, property.z)
			local color = marker.FreeColor
			local dist = #(coords - playerCoords)
			local owned = Config.Debug or (Character.id or 0) == property.character_id
			local occupied = not owned and property.character_id ~= nil
			local isNear = dist < Config.EnterDistance

			if not owned and Character.keys then
				for _, key in ipairs(Character.keys) do
					if key.property_id == id then
						owned = true
						break
					end
				end
			end
		
			if isNear then
				NearestProperty = id
			end
		
			if property.open then
				color = marker.UnlockedColor
			elseif occupied and not owned then
				color = marker.OccupiedColor
			elseif owned and isNear then
				color = marker.NearColor
			elseif owned then
				color = marker.OwnedColor
			end
		
			if dist < marker.DrawDistance then
				DrawMarker(
					marker.Type,
					property.x, property.y, property.z,
					0.0, 0.0, 0.0,
					0.0, 0.0, property.w,
					marker.Scale, marker.Scale, marker.Scale,
					color[1], color[2], color[3], 255 - math.floor(color[4] * math.min(dist / marker.DrawDistance, 1.0)),
					marker.BobUpAndDown,
					marker.FaceCamera, 2,
					marker.Rotate,
					marker.TextureDict,
					marker.TextureName,
					marker.DrawOnEnts
				)
			end
		end
	end
end)

-- Process input.
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local time = GetGameTimer()

		if NearestProperty and IsDisabledControlJustReleased(0, 38) and time - LastActivatedTime > 1000 then
			local property = Properties[NearestProperty]
			local settings = Config.Types[property.type]
			local canBuy = settings.Rent or property.lender

			if LastActivated == NearestProperty and canBuy then
				TriggerServerEvent("properties:buy", property.id)
				-- exports.interaction:RemoveMessage(LastInteractionHandle)
				exports.mythic_notify:PersistentAlert("END", "property")
				LastActivated = nil
				LastActivatedCoords = nil
				LastInteractionHandle = nil
			else
				local typeSettings = Config.Types[property.type]
				local priceText = exports.misc:FormatNumber(property.price or typeSettings.Rent or typeSettings.Value or 0)
				local text = ""
				local occupied = property.character_id ~= nil
				
				if HasProperty(NearestProperty) or occupied or property.open then
					TriggerServerEvent("properties:enter", NearestProperty)
					if occupied then
						local waitUntil = GetGameTimer() + 10000
						while WasLocked == nil and GetGameTimer() < waitUntil do
							Citizen.Wait(20)
						end
						if WasLocked then
							text = Config.OccupiedMessage
						end
						WasLocked = nil
					end
				elseif typeSettings.Rent then
					text = Config.UnoccupiedMessage:format(priceText, GetControlInstructionalButton(2, 51, 1):sub(3), priceText)
				else
					text = Config.RealtorMessage:format(priceText)
				end
				
				if LastActivatedCoords then
					exports.mythic_notify:PersistentAlert("END", "property")
					LastActivatedCoords = nil
				end
				if text ~= "" then
					LastActivatedCoords = vector3(property.x, property.y, property.z + 0.5)
					exports.mythic_notify:PersistentAlert("START", "property", "inform", text)
				end

				LastActivated = NearestProperty
			end

			LastActivatedTime = time
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local localState = LocalPlayer.state
		if IsControlJustPressed(0, 182) and IsInputDisabled(0) and not localState.restrained and not localState.immobile then
			TriggerEvent("properties:toggleLock")
		end
	end
end)

--[[ Functions ]]--
function Cache(property)
	local grid = Grids:GetGrid(vector3(property.x, property.y, property.z), Config.GridSize)
	if GridCache[grid] then
		table.insert(GridCache[grid], property.id)
	else
		GridCache[grid] = { property.id }
	end
	local settings = Config.Types[property.type] or {}
	if settings.Doors then
		RegisterDoors(property, settings.Radius)
	end
end

function Uncache(property)
	local grid = Grids:GetGrid(vector3(property.x, property.y, property.z), Config.GridSize)
	if GridCache[grid] then
		for k, v in ipairs(GridCache[grid]) do
			if v == property.id then
				table.remove(GridCache[grid], k)
			end
		end
	end
	for k, v in ipairs(NearProperties) do
		if v == property.id then
			table.remove(NearProperties, k)
		end
	end
end

function GenerateBlips()
	if Blips then
		for k, blip in pairs(Blips) do
			if DoesBlipExist(blip) then
				RemoveBlip(blip)
			end
		end
	end

	Blips = {}
	
	for k, property in pairs(Properties) do
		if property.type ~= 'motel' then
			AddPropertyBlip(property)
		end
	end
end

function GenerateCache()
	for id, property in pairs(Properties) do
		Cache(property)
	end
end

function AddPropertyBlip(property)
	if not Blips then return end
	local blip = AddBlipForCoord(property.x, property.y, property.z)
	SetBlipHiddenOnLegend(blip, true)
	SetBlipScale(blip, 0.5)
	SetBlipColour(blip, Config.Types[property.type].Color or 0)
	Blips[property.id] = blip
end

function RemovePropertyBlip(id)
	if not Blips then return end
	local blip = Blips[id]
	if blip and DoesBlipExist(blip) then
		RemoveBlip(blip)
	end
end

function HasProperty(id)
	if Config.Debug then
		return true
	end

	local property = Properties[id]
	if not property then return false end

	local character = exports.character:GetCharacter()
	if not character then return false end

	if character.id == property.character_id then
		return true
	end

	if character.keys then
		for k, key in ipairs(character.keys) do
			if key.property_id == id then
				return true
			end
		end
	end

	return false
end
exports("HasProperty", HasProperty)

function GetProperty(id)
	return Properties[id]
end
exports("GetProperty", GetProperty)

function GetNearestProperty(returnTable)
	if returnTable and NearestProperty ~= nil then
		return Properties[NearestProperty]
	else
		return NearestProperty
	end
end
exports("GetNearestProperty", GetNearestProperty)

--[[ Events ]]--
AddEventHandler("properties:toggleLock", function()
	if not NearestProperty then return end
	if not HasProperty(NearestProperty) then return end
	TriggerServerEvent("properties:lock", NearestProperty)
end)

AddEventHandler("properties:clientStart", function()
	TriggerServerEvent("properties:request")
end)

RegisterNetEvent("properties:receive")
AddEventHandler("properties:receive", function(properties)
	Properties = properties
	GenerateCache()

	if Config.Debug then
		GenerateBlips()
	end
end)

RegisterNetEvent("properties:update")
AddEventHandler("properties:update", function(property)
	Properties[property.id] = property
end)

RegisterNetEvent("properties:add")
AddEventHandler("properties:add", function(property)
	Properties[property.id] = property
	Cache(property)

	if Config.Debug then
		AddPropertyBlip(property)
	end
end)

RegisterNetEvent("properties:remove")
AddEventHandler("properties:remove", function(id)
	local property = Properties[id]
	Uncache(property)
	Properties[id] = nil

	if Config.Debug then
		RemovePropertyBlip(id)
	end
end)

RegisterNetEvent("properties:failed")
AddEventHandler("properties:failed", function()
	WasLocked = true
end)

RegisterNetEvent("properties:locked")
AddEventHandler("properties:locked", function(opened)
	exports.emotes:Play(Config.Locking.Anim)

	local message = ""
	if opened then
		message = "You unlocked the door!"
	else
		message = "You locked the door!"
	end
	TriggerEvent("chat:notify", message, "inform")
end)

RegisterNetEvent("property:lookup")
AddEventHandler("property:lookup", function(id, owner)
	local property = Properties[id]
	if not property then return end

	local settings = Config.Types[property.type or ""]

	local text = ("Address: %s %s"):format(property.id, exports.oldutils:GetStreetText(vector3(property.x, property.y, property.z)))

	if settings and not settings.Secret then
		text = text..("<br>Type: %s"):format(settings.Name)
	end

	text = text.."<br>Owner: "

	if owner then
		text = text..owner
	elseif not settings.Public or settings.Secret then
		text = text.."<i>Unknown</i>"
	else
		text = text.."<i>None</i>"
	end
	
	TriggerEvent("chat:addMessage", text, "advert", true)
end)

--[[ Commands ]]--
RegisterCommand("property:breach", function()
	if NearestProperty then
		local property = Properties[NearestProperty]
		local settings = Config.Types[property.type or ""]

		if not exports.jobs:IsInEmergency("CanBreach") or (settings and settings.Secret) then
			TriggerEvent("chat:addMessage", "You can't breach that property!", "advert")
			return
		end

		if not property.open then
			TriggerServerEvent("properties:breach", NearestProperty)
		else
			TriggerEvent("chat:addMessage", "You lock the door!", "advert", true)
			TriggerServerEvent("properties:lock", NearestProperty, true)
		end
	else
		TriggerEvent("chat:addMessage", "You're not near any property!", "advert")
	end
end, false)

RegisterCommand("property:get", function()
	if NearestProperty then
		local property = Properties[NearestProperty]
		local settings = Config.Types[property.type or ""]

		local text = ("Address: %s %s"):format(property.id, exports.oldutils:GetStreetText(vector3(property.x, property.y, property.z)))

		if settings and not settings.Secret then
			text = text..("<br>Type: %s"):format(settings.Name)
		end
		
		TriggerEvent("chat:addMessage", text, "advert", true)
		TriggerServerEvent("properties:get", property.id)
	else
		TriggerEvent("chat:addMessage", "You're not near any property!", "advert")
	end
end, false)

RegisterCommand("property:available", function()
	if not exports.factions:Has("realtor", none) then
		TriggerEvent("chat:addMessage", "You must be a realtor!")
		return
	end

	TriggerEvent("chat:notify", "Check your map for blips! They will disappear in 60 seconds.", "inform")

	local blips = {}

	for id, property in pairs(Properties) do
		if Config.Types[property.type] and property.character_id == nil and not property.Secret and not Config.Types[property.type].Custom then
			local blip = AddBlipForCoord(property.x, property.y, property.z)
			
			SetBlipSprite(blip, Config.Types[property.type].Sprite or 40)
			SetBlipColour(blip, Config.Types[property.type].Color or 2)
			SetBlipScale(blip, 0.65)
			AddTextEntry('PROPERTIES'..property.type, 'Property: '..Config.Types[property.type].Name)
			BeginTextCommandSetBlipName('PROPERTIES'..property.type)
			EndTextCommandSetBlipName(blip)

			table.insert(blips, blip)
		end
	end

	Citizen.Wait(60000)

	for k, blip in ipairs(blips) do
		if DoesBlipExist(blip) then
			RemoveBlip(blip)
		end
	end
end, false)