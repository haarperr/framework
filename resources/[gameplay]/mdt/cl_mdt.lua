CurrentFaction = ""
CriminalCode = nil
IsOpen = false
NotesKey = "8vaW2L1_Notes"

--[[ Functions ]]--
function ToggleMenu(toggle, faction)
	IsOpen = toggle
	SetNuiFocus(toggle, toggle)
	SetNuiFocusKeepInput(false)
	SendNUIMessage({
		display = toggle,
		notes = GetResourceKvpString(NotesKey..CurrentFaction) or "",
		faction = faction,
		isJudge = exports.character:HasFaction("judge"),
	})
	if toggle and faction == "police" and not CriminalCode then
		TriggerServerEvent("mdt:requestCriminalCode")
	end
	if toggle then
		exports.emotes:PerformEmote("tablet")
	else
		exports.emotes:CancelEmote()
	end
end

function GetFaction()
	if EnableDebug then
		return "police"
	end

	return exports.jobs:IsInEmergency("AccessMdt") or false
end

RegisterNUICallback("toggleMenu", function(data) ToggleMenu(false) end)

RegisterNUICallback("search", function(info)
	TriggerServerEvent("mdt:search", CurrentFaction, info.loader:lower(), info.data, info.offset)
end)

RegisterNUICallback("saveNotes", function(info)
	SetResourceKvp(NotesKey..CurrentFaction, info.notes)
end)

RegisterNUICallback("save", function(info)
	TriggerServerEvent("mdt:save", CurrentFaction, info.id, info.type, info.diff)
end)

RegisterNUICallback("report", function(info)
	TriggerServerEvent("mdt:report", CurrentFaction, info)
end)

RegisterNUICallback("load", function(info)
	TriggerServerEvent("mdt:load", CurrentFaction, info.loader,info.data)
end)

--[[ Events ]]
RegisterNetEvent("mdt:receiveCriminalCode")
AddEventHandler("mdt:receiveCriminalCode", function(data)
	CriminalCode = data
	SendNUIMessage({
		charges = data
	})
end)

RegisterNetEvent("mdt:receive")
AddEventHandler("mdt:receive", function(loader, data, offset)
	SendNUIMessage({
		result = {
			loader = loader,
			data = data,
			offset = offset,
		}
	})
end)

RegisterNetEvent("mdt:sendMessage")
AddEventHandler("mdt:sendMessage", function(message)
	SendNUIMessage(message)
end)

--[[ Commands ]]--
RegisterCommand("mdt", function(source, args, command)
	if not exports.jobs:IsInEmergency() then
		TriggerEvent("chat:addMessage", "You do not have access.")
		return
	end

	CurrentFaction = "police"
	ToggleMenu(true, CurrentFaction)
end)