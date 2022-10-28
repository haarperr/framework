--[[ Functions ]]--
function AddNpc(info)
	Citizen.CreateThread(function()
		exports.oldnpcs:Add(info)
	end)
end

function RequestStatus(callback, ...)
	if LastRequest then RemoveEventHandler(LastRequest) end
	
	LastRequest = AddEventHandler("playertasks:receiveStatus", function(data)
		if LastRequest then RemoveEventHandler(LastRequest) end

		callback(data)
	end)

	TriggerServerEvent("playertasks:requestStatus", ...)
end

--[[ Events ]]--
RegisterNetEvent("playertasks:receiveStatus")