AppHooks["bank"] = function(content)
	return {
		balance = exports.character:Get("bank") or 0
	}
end

RegisterNetEvent("character:updateCurrent")
AddEventHandler("character:updateCurrent", function(object, value)
	if object ~= "bank" then return end
	LoadApp("bank", AppHooks["bank"](), false)
end)