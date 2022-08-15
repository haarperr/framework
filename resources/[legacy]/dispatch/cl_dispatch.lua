Blips = {}
Debug = false
DisabledControls = { 1, 2, 3, 4, 5, 6, 24, 25, 23 }
DisplayCodes = false
HasFocus = false
Reports = {}
TextEntries = {}
local firstNamesList = {}
local lastNamesList = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 121) then -- Decide which key
			if exports.jobs:IsInGroup("emergency") then
				local ped = PlayerPedId()
				local playerVehicle = GetVehiclePedIsIn(ped)
				if not DoesEntityExist(playerVehicle) or GetVehicleClass(playerVehicle) ~= 18 then
					TriggerEvent("chat:notify", "You must be in an emergency vehicle!", "error")
				else
					local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = table.unpack(exports.oldutils:Raycast(playerVehicle))
					local coords = GetEntityCoords(ped, false)
					if IsEntityAVehicle(entity) and #(coords - hitCoords) < 30.0 then
						local data = {Plate = GetVehicleNumberPlateText(entity), Model = GetEntityModel(entity)}
						TriggerServerEvent("dispatch:runPlate", data)
					else
						TriggerEvent("chat:notify", "You must be looking at a vehicle!", "error")
					end
				end
			end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		while not exports.jobs:IsInGroup("emergency") do
			Citizen.Wait(1000)
		end

		if HasFocus then
			for k, v in ipairs(DisabledControls) do
				DisableControlAction(0, v)
			end
		end

		for id, blip in pairs(Blips) do
			local lifetime = GetGameTimer() - blip.time
			if lifetime > Config.Blips.FadeAfter then
				local alpha = math.max(math.floor((1.0 - (lifetime - Config.Blips.FadeAfter) / (Config.Blips.FadeFor)) * 255), 0)
				
				if alpha <= 0 then
					RemoveBlip(id)
				else
					SetBlipAlpha(id, alpha)
				end
			else
				SetBlipAlpha(id, 255)
			end
		end
		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
function AudioExists(name)
	if AudioNames[name] then 
		return true, ""
	elseif AudioNames[name.."_01"] then
		return true, "_01"
	elseif AudioNames[name.."_02"] then
		return true, "_02"
	end
	print("Couldn't find "..name)
	return false, index
end

function FormatDispatch(data)
	local report = {}
	local coords = data.coords
	local details = { vehicle = {}, location = {} }
	
	-- Street name.
	local streetText = nil
	local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
	local zone =  GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))

	if streetName ~= 0 then
		streetText = GetStreetNameFromHashKey(streetName)
		details.location.street = string.gsub(streetText, "%s+", "_")
		details.location.street = "STREET_"..details.location.street:upper()
		if crossingRoad ~= 0 then
			crossingRoadString = GetStreetNameFromHashKey(crossingRoad)
			details.location.crossing = string.gsub(crossingRoadString, "%s+", "_")
			details.location.crossing = "STREET_"..details.location.crossing:upper()
			streetText = streetText.." & "..crossingRoadString
		end
	end
	if zone ~= "" then
		details.location.zone = string.gsub(zone, "%s+", "_")
		details.location.zone = "AREA_"..details.location.zone:upper()
		streetText = streetText..", "..zone
	end

	-- Setup vehicle.
	local vehicle = ""
	if data.vehicle ~= nil then
		details.vehicle.color = exports.vehicles:GetColor(data.vehicle.color)
		details.vehicle.model = GetLabelText(GetDisplayNameFromVehicleModel(data.vehicle.model))
		details.vehicle.plate = data.vehicle.plate

		vehicle = ("%s: %s %s"):format(data.vehicle.plate, details.vehicle.color, details.vehicle.model)

		details.vehicle.color = "COLOR_"..details.vehicle.color:upper()
		details.vehicle.model = "MODEL_"..details.vehicle.model:upper()
	end

	-- Get the message.
	local message = nil
	local text = ""
	local alert = ""
	local status

	if data.messageType == 0 then
		local code = Config.Codes[data.message] or {}
		
		if data.subMessage and code.SubCodes then
			code = code.SubCodes[data.subMessage] or code
		end

		local priority = exports.jobs:IsInEmergency("DispatchPriority")
		if priority and not priority[data.message] then
			report.priority = false
		end

		alert = tostring(data.message)
		text = code.Message
		status = code.Status
	else
		alert = Config.Prefixes[data.messageType]
		text = data.message
	end

	-- if data.messageType == 0 then
	-- 	data.rawMessage = data.message
	-- 	if Config.Codes[data.message] ~= nil then
	-- 		message = Config.Message:format("10-"..data.message, Config.Codes[data.message].Message)
	-- 	else
	-- 		message = Config.Message:format("10-"..data.message, ResponseCodes[data.message].Message)
	-- 	end
	-- else
	-- 	message = Config.Message:format(Config.Prefixes[data.messageType]:format(data.source), data.message)
	-- end

	-- if data.messageType > 0 then
	-- 	data.type = "minor"
	-- else
	-- 	data.type = (Config.Codes[data.message] or {}).Type or "minor"
	-- end

	-- Format the message.
	-- data.message = message:gsub("%^s", streetText)..vehicle
	-- data.title = Config.MessageTypes[data.messageType] or "emergency"
	-- data.title = data.title:upper()

	-- report.details = details
	report.age = GetNetworkTime() / 1000.0 - (data.time or 0)
	report.alert = alert
	report.extra = data.extra
	report.identifier = data.identifier
	report.location = streetText
	report.phone = data.phone
	report.source = data.source
	report.status = status
	report.text = text
	report.vehicle = vehicle

	return report
end

function ToggleMenu()
	HasFocus = not HasFocus
	SetNuiFocus(HasFocus, HasFocus)
	SetNuiFocusKeepInput(HasFocus)
	SetPlayerControl(PlayerPedId(), not HasFocus, 0)
	SendNUIMessage({ display = HasFocus })

	if HasFocus then
		SetCursorLocation(0.5, 0.5)
	end
end

function Report(group, message, messageType, coords, vehicle, blip)
	local instance = exports.oldinstances:GetPlayerInstance()
	if instance and instance.outCoords then
		coords = vector3(instance.outCoords.x, instance.outCoords.y, instance.outCoords.z)
		if blip and blip.coords then
			blip.coords = coords
		end
	end
	if coords and GetNameOfZone(coords.x, coords.y, coords.z) == "ISHEIST" then return end
	if vehicle then
		if not tonumber(vehicle) or not DoesEntityExist(vehicle) then
			vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		end

		if DoesEntityExist(vehicle) then
			vehicle = {
				model = GetEntityModel(vehicle),
				plate = GetVehicleNumberPlateText(vehicle),
				color = GetVehicleColours(vehicle),
			}
		else
			vehicle = nil
		end
	else
		vehicle = nil
	end

	TriggerServerEvent("dispatch:report", group, message, messageType, coords, vehicle, blip)
end
exports("Report", Report)

function AddBlip(report)
	local blipConfig = nil
	local coords = report.coords
	local code = Config.Codes[report.message]

	if code then
		if report.subMessage and code.SubCodes then
			code = code.SubCodes[report.subMessage] or code
		end

		blipConfig = code.Blips
	end
	
	if not blipConfig then
		blipConfig = Config.Blips.Variants[report.messageType] or {}
	end
	
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, blipConfig.Id or Config.Blips.Id)
	SetBlipRotation(blip, (blipConfig.Rotation or 0.0) + (blipConfig.AutoRotate or report.rotation or 0.0))
	SetBlipColour(blip, blipConfig.Color or Config.Blips.Color)
	SetBlipScale(blip, blipConfig.Scale or Config.Blips.Scale)
	SetBlipDisplay(blip, 2)
	SetBlipHighDetail(blip, true)

	local label = "Dispatch"

	if report.messageType == 0 then
		label = report.message
	else
		label = Config.Blips.Labels[report.messageType] or label;
	end

	if not TextEntries[label] then
		TextEntries[label] = label
		AddTextEntry(label, label)
	end

	BeginTextCommandSetBlipName(label)
	EndTextCommandSetBlipName(blip)

	Blips[blip] = { time = GetGameTimer() }
end

function StartDispatchAudio(code, message, details)
	local radioVolume = exports.radio:GetVolume()
	local crime = Config.Codes[code].Audio
	local data = {
		[1] = "DISPATCH_INTRO_01",
		[2] = "CITIZENS_REPORT_01",
		[3] = crime,
	}
	if details.vehicle.model ~= nil then
		table.insert(data, "TARGET_VEHICLE_LICENSE_PLATE")
		for c in details.vehicle.plate:gmatch"." do
			table.insert(data, c:upper())
		end
		-- table.insert(data, "IS_A")
		-- table.insert(data, "DELAY_1S")
		-- table.insert(data, details.vehicle.color)
		-- table.insert(data, details.vehicle.model)
		table.insert(data, "DELAY_1S")
		table.insert(data, "LAST_SEEN")
	end
	if details.location.street then
		table.insert(data, "AT_LESS_HESITATION_02")
		local doesExist, index = AudioExists(details.location.street)
		if doesExist then
			table.insert(data, details.location.street..index)
		end
	end
	if details.location.crossing then
		local doesExist, index = AudioExists(details.location.crossing)
		if doesExist then
			table.insert(data, "NEAR")
			table.insert(data, details.location.crossing..index)
		end
	end
	if details.location.zone then
		local doesExist, index = AudioExists(details.location.zone)
		if doesExist then
			table.insert(data, "AT_LESS_HESITATION_01")
			table.insert(data, details.location.zone..index)
		end
	end
	if Config.Codes[code].Respond ~= nil then
		table.insert(data, Config.Codes[code].Respond)
	end
	table.insert(data, "DELAY_1S")
	SendNUIMessage({type = "addSegment", volume = radioVolume, info = data})
end

function CommunicateDispatch(code, details)
	local radioVolume = exports.radio:GetVolume()
	local config = Config.Codes[code]
	if not config then return end

	local media = config.Audio
	if not media then return end

	local data = {
		[1] = "DISPATCH_INTRO_01",
		[2] = "CITIZENS_REPORT_01",
	}
	for k, v in ipairs(media) do
		table.insert(data, v)
	end
	if details.vehicle.model ~= nil then
		table.insert(data, "TARGET_VEHICLE_LICENSE_PLATE")
		for c in details.vehicle.plate:gmatch"." do
			table.insert(data, c:upper())
		end
		table.insert(data, "DELAY_1S")
		table.insert(data, "LAST_SEEN")
	end
	table.insert(data, "AT_LESS_HESITATION_01")
	if details.location.street then
		local doesExist, index = AudioExists(details.location.street)
		if doesExist then
			table.insert(data, details.location.street..index)
		end
	end
	table.insert(data, "DELAY_1S")
	SendNUIMessage({type = "addSegment", volume = radioVolume, info = data})
end

--[[ Events ]]--
RegisterNetEvent("dispatch:runPlate")
AddEventHandler("dispatch:runPlate", function(data)
	if data then
		local model = ""
		if data.Model == nil then
			model = "vehicle"
		else
			model = GetLabelText(GetDisplayNameFromVehicleModel(data.Model))
		end
		TriggerEvent("chat:addMessage", string.format("Database: Plate %s, comes back to a %s, owned by %s", data.Plate, model, data.Owner))
	end
end)

RegisterNetEvent("dispatch:receiveHistory")
AddEventHandler("dispatch:receiveHistory", function(reports)
	local formattedReports = {}
	Reports = reports

	for k, v in pairs(Reports) do
		Reports[k] = v
		table.insert(formattedReports, FormatDispatch(v))
	end

	table.sort(formattedReports, function(a, b)
		return a.age > b.age
	end)

	SendNUIMessage({ reports = formattedReports })
end)

RegisterNetEvent("dispatch:receive")
AddEventHandler("dispatch:receive", function(report)
	local coords = report.coords
	local job = exports.jobs:GetCurrentJob()
	if not job then return end

	if job.DispatchDelay then
		Citizen.Wait(job.DispatchDelay * 1000)
		
		if exports.jobs:GetCurrentJob().Name ~= job.Name then return end
	end

	-- Blips.
	if report.isBlip or report.hasBlip then
		AddBlip(report)

		if report.messageType == 0 and not report.hasBlip then
			return
		end
	end
	
	message = report.message

	-- Add the message.
	SendNUIMessage({type = "addNotification", report = FormatDispatch(report)})

	-- if exports.radio:GetState() and ToggleAudio and report.messageType == 0 and (Config.Codes[report.rawMessage] or {}).Type == "major" then
	-- 	if report.dispatchType == "auto" then
	-- 		StartDispatchAudio(message, report.message, report.details)
	-- 	else
	-- 		CommunicateDispatch(message, report.details)
	-- 	end
	-- end

	-- Cache the report.
	Reports[report.identifier] = report
end)

RegisterNetEvent("jobs:clocked")
AddEventHandler("jobs:clocked", function(name, message)
	if message == false then
		if HasFocus then
			ToggleMenu()
		end
		SendNUIMessage({ reports = {} })
		for id, blip in pairs(Blips) do
			if DoesBlipExist(id) then
				RemoveBlip(id)
			end
		end
		Blips = {}
	end
end)

--[[ Commands ]]--
RegisterCommand("runplate", function(source, args, command)
    local ped = PlayerPedId()
	local state = (LocalPlayer or {}).state

    if state.immobile or state.restrained then
		TriggerEvent("chat:notify", "Can't seem to do that...", "error")
		return
	end

    if not exports.jobs:IsInGroup("emergency") then
		TriggerEvent("chat:notify", "You must be on duty!", "error")
		return
	end

    if not args[1] then return end

    local plate = args[1]

    TriggerServerEvent("dispatch:runPlate", {Plate = plate, Model = nil})
end)

RegisterCommand("311", function(source, args, command)
	local state = (LocalPlayer or {}).state
	local message = command:sub(5)
	local lPed = PlayerPedId()
	if state.restrained then
		TriggerEvent("chat:notify", "Can't seem to do that...", "error")
	else
		TaskPlayAnim(lPed, "cellphone@", "cellphone_call_listen_base", 2.0, 2.0, 3000, 49, 0, 0, 0, 0)
		TriggerEvent("chat:addMessage", "(311) "..message, "nonemergency")
		Report("emergency", message, 1, GetEntityCoords(PlayerPedId()))
	end
end)

RegisterCommand("911", function(source, args, command)
	local state = (LocalPlayer or {}).state
	local message = command:sub(5)
	local lPed = PlayerPedId()
	if state.restrained then
		TriggerEvent("chat:notify", "Can't seem to do that...", "error")
	else
		TaskPlayAnim(lPed, "cellphone@", "cellphone_call_listen_base", 2.0, 2.0, 3000, 49, 0, 0, 0, 0)
		TriggerEvent("chat:addMessage", "(911) "..message, "emergency")
		Report("emergency", message, 2, GetEntityCoords(PlayerPedId()))
	end
end)

RegisterCommand("call", function(source, args, command)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local state = (LocalPlayer or {}).state

	if state.immobile or state.restrained then
		TriggerEvent("chat:notify", "Can't seem to do that...", "error")
		return
	end

	if not exports.jobs:IsInGroup("emergency") then
		TriggerEvent("chat:notify", "You must be on duty!", "error")
		return
	end

	local code = args[1]
	if not code then return end

	local config = Config.Codes[code]
	if not config or (not Debug and not config.CanCall) then return end

	local vehicle = false

	if code == "10-38" then
		local playerVehicle = GetVehiclePedIsIn(ped)

		if not DoesEntityExist(playerVehicle) or GetVehicleClass(playerVehicle) ~= 18 then
			TriggerEvent("chat:notify", "You must be in an emergency vehicle!", "error")
			return
		end

		local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = table.unpack(exports.oldutils:Raycast(playerVehicle))
		if IsEntityAVehicle(entity) and #(coords - hitCoords) < 30.0 then
			vehicle = entity
		else
			TriggerEvent("chat:notify", "You must be looking at a vehicle!", "error")
			return
		end
	end

	Report("emergency", code, 0, coords, vehicle, { coords = coords, rotation = rotation })
end)

RegisterCommand("codes", function()
	DisplayCodes = not DisplayCodes
	if DisplayCodes then
		SendNUIMessage({ codes = Config.Codes })
	else
		SendNUIMessage({ codes = false })
	end
end)

RegisterCommand("+nsrp_dispatch", function()
	if HasFocus or exports.jobs:IsInGroup("emergency") then
		ToggleMenu()
	end
end, true)

RegisterKeyMapping("+nsrp_dispatch", "Toggle Dispatch", "keyboard", "n")

--[[ NUI Callbacks ]]--
RegisterNUICallback("addUnit", function(data)
	local id = data.id
	if not id then return end

	local report = Reports[id]
	if not report then return end
	
	local coords = report.coords
	if not coords then return end

	SetNewWaypoint(coords.x, coords.y)
	TriggerServerEvent("dispatch:addUnit", id)
end)

RegisterNUICallback("toggleMenu", function(data)
	if HasFocus then
		ToggleMenu()
	end
end)
