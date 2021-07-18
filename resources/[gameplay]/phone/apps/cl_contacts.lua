--[[ Functions ]]--
AppHooks["contacts"] = function()
	return exports.character:Get("phone_contacts") or {}
end

function DeleteContact(number)
	TriggerServerEvent("phone:deleteContact", tostring(number))
end

function SaveContact(name, number)
	TriggerServerEvent("phone:saveContact", name, tostring(number))
end

function UpdateContacts(contacts)
	LoadApp("contacts", contacts)
end

--[[ Events ]]--
RegisterNUICallback("saveContact", function(data)
	if not data.name or not data.number then return end
	SaveContact(data.name, data.number)
end)

RegisterNUICallback("deleteContact", function(data)
	DeleteContact(data.number)
end)

RegisterNetEvent("character:updateCurrent")
AddEventHandler("character:updateCurrent", function(object, value)
	if object == "phone_contacts" then
		UpdateContacts(value)
	end
end)