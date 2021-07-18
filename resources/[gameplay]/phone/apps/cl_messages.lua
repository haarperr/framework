--[[ Functions ]]--
AppHooks["messages"] = function(content)
	content = content or {}

	RequestMessages("messages", -1, content.type or "text", content.offset or 0)
	
	return false
end

AppHooks["messages-dm"] = function(content)
	content = content or {}
	
	RequestMessages("messages-dm", content.number, content.type or "text", content.offset or 0)

	return false
end

function RequestMessages(app, target, _type, offset)
	TriggerServerEvent("phone:requestMessages", app, target, _type, offset)
end

function SendMessage(target, type, message)
	TriggerServerEvent("phone:sendMessage", target, type, message)
end

--[[ Threads ]]--
RegisterNetEvent("phone:receiveMessages")
AddEventHandler("phone:receiveMessages", function(app, target, _type, messages)
	local payload =  {
		target = target,
		messages = messages,
		characterId = exports.character:Get("id"),
	}

	local contacts = exports.character:Get("phone_contacts")
	if target == -1 then
		for k, v in ipairs(messages) do
			v[5] = contacts[v[1]]
		end
	else
		payload.name = contacts[target]
	end

	LoadApp(app, payload)
end)

--[[ Callbacks ]]--
RegisterNUICallback("sendMessage", function(data)
	SendMessage(data.target, data.type, data.message)
end)