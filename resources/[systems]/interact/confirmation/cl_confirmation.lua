local waitingFor = nil
Messages = {}

--[[ Functions ]]--
Messages["confirm"] = function(source, message, value)
	if waitingFor then return end

	exports.mythic_notify:PersistentAlert("START", "confirm", "inform", value.message.."! Type <span style='color: rgb(128, 255, 128)'>/accept</span> or <span style='color: rgb(255, 0, 0)'>/deny</span> to complete.")
	waitingFor = value.id
end

--[[ Commands ]]--
RegisterCommand("accept", function()
	if not waitingFor then return end

	exports.mythic_notify:PersistentAlert("END", "confirm")
	TriggerServerEvent("interaction:confirm", waitingFor, true)
	
	waitingFor = nil
end)

RegisterCommand("deny", function()
	if not waitingFor then return end

	exports.mythic_notify:PersistentAlert("END", "confirm")
	TriggerServerEvent("interaction:confirm", waitingFor, false)
	
	waitingFor = nil
end)

--[[ Events ]]--
RegisterNetEvent("interaction:receive")
AddEventHandler("interaction:receive", function(source, message, value)
	if Messages[message] then
		Messages[message](source, message, value)
	end
end)