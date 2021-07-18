MessageHooks = {}
PhoneCache = {
	Numbers = {},
	Players = {},
}

--[[ Functions ]]--
function IsNumberActive(number)
	return PhoneCache.Numbers[number] ~= nil
end
exports("IsNumberActive", IsNumberActive)

function GetSource(number)
	return PhoneCache.Numbers[number]
end
exports("GetSource", GetSource)

function GetId(number)
	local source = PhoneCache.Numbers[number]
	if source then
		local id = exports.character:Get(source, "id")
		if id then
			return id
		end
	end
	return exports.GHMattiMySQL:QueryScalar("SELECT get_id_from_phone_number(@phone_number)", {
		["@phone_number"] = number
	})
end
exports("GetId", GetId)

function GetNumber(id)
	local source = exports.character:GetCharacterById(id)
	if source then
		local number = exports.character:Get(source, "phone_number")
		if number then
			return number
		end
	end
	return exports.GHMattiMySQL:QueryScalar("SELECT get_phone_number_from_id(@character_id)", {
		["@character_id"] = id
	})
end
exports("GetNumber", GetNumber)

function SendPayload(source, app, payload, forceOpen)
	TriggerClientEvent("phone:sendPayload", source, app, payload, forceOpen)
end
exports("SendPayload", SendPayload)

--[[ Events ]]--
AddEventHandler("character:switched", function(source, character)
	if character == nil then return end

	PhoneCache.Numbers[character.phone_number] = nil
	PhoneCache.Players[source] = nil
end)

AddEventHandler("character:loaded", function(source, character)
	PhoneCache.Numbers[character.phone_number] = source
	PhoneCache.Players[source] = character.phone_number
end)

AddEventHandler("phone:stop", function()
	exports.cache:Set("PhoneCache", PhoneCache)
end)

AddEventHandler("phone:start", function()
	PhoneCache = exports.cache:Get("PhoneCache") or PhoneCache
end)