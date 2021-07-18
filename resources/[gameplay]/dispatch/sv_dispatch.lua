Cooldowns = {}
Reports = {}
TempReports = {}
LastReport = 0

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		for k, report in pairs(TempReports) do
			if os.clock() - report.time > Config.AntiSpam.Duration then
				TempReports[k] = nil
			elseif not report.sent then
				Send(report)
				report.sent = true
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)

		for k, report in pairs(Reports) do
			if os.clock() - report.time > Config.History.Duration then
				Reports[k] = nil
			end
		end
	end
end)

--[[ Functions ]]--
function Send(report)
	local users = exports.jobs:GetActiveGroup(report.group)
	if not users then return end

	for player, _ in pairs(users) do
		TriggerClientEvent("dispatch:receive", player, report)
	end
end

function Add(report)
	if report.messageType == 0 and not report.isBlip then
		for k, _report in pairs(TempReports) do
			if _k ~= k and _report.messageType == report.messageType and #(_report.coords - report.coords) < Config.AntiSpam.Range and _report.message == report.message then
				return false
			end
		end
	elseif (report.messageType == 1 or report.messageType == 2) and report.source then
		report.phone = exports.character:Get(report.source, "phone_number")
	end
	
	LastReport = LastReport + 1
	local identifier = tostring(LastReport)

	report.identifier = identifier
	report.time = report.time or os.clock()

	Reports[identifier] = report
	TempReports[identifier] = report
	
	return true
end
exports("Add", Add)

--[[ Events ]]--
RegisterNetEvent("dispatch:report")
AddEventHandler("dispatch:report", function(group, message, messageType, coords, vehicle, blip)
	local source = source

	if os.clock() - (Cooldowns[source] or 0.0) < 3.0 then
		return
	end

	local subMessage = nil
	if type(message) == "table" then
		subMessage = message[2]
		message = message[1]
	end

	if type(group) ~= "string" then return end
	if type(coords) ~= "vector3" then return end
	if type(message) ~= "string" or message:len() > 512 then return end
	if type(messageType) ~= "number" then return end
	if subMessage and (messageType ~= 0 or ((Config.Codes[message] or {}).SubCodes or {})[subMessage] == nil) then return end

	-- Cooldown.
	Cooldowns[source] = os.clock()

	-- Vehicles.
	if vehicle ~= nil then
		if type(vehicle) ~= "table" then
			return
		else
			if type(vehicle.model) ~= "number" then return end
			if type(vehicle.color) ~= "number" then return end
			if type(vehicle.plate) ~= "string" then return end
		end

		vehicle = {
			model = vehicle.model,
			plate = vehicle.plate,
			color = vehicle.color,
		}
	end

	-- Report template.
	local report = {
		coords = coords,
		group = group,
		isBlip = blip == nil,
		message = message,
		subMessage = subMessage,
		messageType = messageType,
		source = source,
		vehicle = vehicle,
	}

	-- Attempt to add the report.
	if Add(report) then
		exports.log:Add({
			source = source,
			verb = "dispatched to",
			noun = group,
			extra = message,
		})
	end
	
	-- Attempt to add the blip.
	if type(blip) == "table" then
		Add({
			coords = blip.coords or coords,
			group = group,
			isBlip = true,
			message = message,
			subMessage = subMessage,
			messageType = messageType,
			rotation = blip.rotation,
			source = source,
		})
	end
end)

RegisterServerEvent("dispatch:addUnit")
AddEventHandler("dispatch:addUnit", function(id)
	-- TODO: Occupy.
end)

AddEventHandler("jobs:clock", function(source, name, message)
	if not message or exports.jobs:GetGroup(source) ~= "Emergency" then return end

	local history = {}
	for k, report in pairs(Reports) do
		if not report.isBlip or report.messageType ~= 0 then
			history[#history + 1] = report
		end
	end

	TriggerClientEvent("dispatch:receiveHistory", source, history)
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("dispatch", function(source, args, rawCommand)
	local job = exports.jobs:GetCurrentJob(source, true)
	if exports.jobs:GetGroup(source) ~= "Emergency" or job.DispatchDelay ~= nil then
		TriggerClientEvent("chat:addMessage", source, "You are not on-duty emergency!")
		return
	end

	local target = tonumber(args[1])
	
	if not target or not GetPlayerPed(target) then
		TriggerClientEvent("chat:addMessage", source, "Target does not exist!")
		return
	end

	local text = rawCommand:sub(("dispatch "..args[1]):len() + 2)
	if text == "" or text == " " then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "dispatched",
		extra = text,
	})

	local targets = { source, target }
	for i = 1, 2 do
		TriggerClientEvent("chat:addMessage", targets[i], ("Dispatch [%s]: %s"):format(source, text), "emergency")
	end
end, {
	help = "",
	params = {
		{ name = "Target", help = "ID of the target for the message." },
		{ name = "Message", help = "The message sent through dispatch." },
	}
}, paramCount or -1, group)

exports.chat:RegisterCommand("a:dispatch", function(source, args, rawCommand)
	local message = rawCommand:sub(("a:dispatch "):len() + 1)
	local coords = GetEntityCoords(GetPlayerPed(source))
	local report = {
		group = "Emergency",
		coords = coords,
		isBlip = true,
		message = message,
		messageType = 4,
		source = source,
	}

	if Add(report) then
		exports.log:Add({
			source = source,
			verb = "admin dispatched",
			extra = message,
		})
	end
end, {
	help = "",
	params = {
		{ name = "Message", help = "Send a message directly to dispatch at your position." },
	}
}, -1, 75)