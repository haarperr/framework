AddEventHandler("character:selected", function(source, character)
	if character then
		local licenses = {}
		local result = exports.GHMattiMySQL:QueryResult("SELECT name, points FROM licenses WHERE character_id=@character_id", {
			["@character_id"] = character.id,
		})

		for k, v in pairs(result) do
			licenses[v.name] = v
		end
		print("LOAD")
		print(json.encode(licenses))

		exports.character:Set(source, "licenses", licenses)
		TriggerClientEvent("licenses:load", source, licenses)
	end
end)

--[[ Functions ]]--
--[[function Modules.Load.licenses(licenses)
	local result = {}
	for _, license in ipairs(licenses) do
		result[license.name] = license
	end
	return result
end]]

function GetLicense(source, license)
	if not IsInitialized(source) then return end
	return exports.character:Get("licenses").licenses[license]
end
exports("GetLicense", GetLicense)

function GetLicenses(source)
	if not IsInitialized(source) then return end
	return exports.character:Get("licenses").licenses
end
exports("GetLicenses", GetLicenses)

function HasLicense(source, name)
	return _HasLicense(source, name)
end
exports("HasLicense", HasLicense)

function AddLicense(source, license)
	local licenses = GetLicenses(source)
	if not licenses then return false end

	if licenses[license] then
		return false
	end

	local data = {
		name = license,
		points = 0,
	}

	licenses[license] = data

	--AddModule(source, "licenses", data)
	exports.character:Set(source, "licenses", licenses)

	return true
end
exports("AddLicense", AddLicense)

function RemoveLicense(source, license)
	local licenses = GetLicenses(source)
	if not licenses then return false end

	if not licenses[license] then
		return false
	end

	exports.character:RemoveModule(source, "licenses", { name = license })

	licenses[license] = nil

	exports.character:Set(source, "licenses", licenses)
	
	return true
end
exports("RemoveLicense", RemoveLicense)

function AddPointsToLicense(source, name, points)
	local licenses = GetLicenses(source)
	if not licenses then return false end

	local license = licenses[name]
	if not license then return false end

	local currentPoints = license.points
	license.points = math.min(math.max(currentPoints + points, 0), 255)

	exports.character:UpdateModule(source, "licenses", { points = license.points }, { name = name })
	exports.character:Set(source, "licenses", licenses)
	
	return true
end
exports("AddPointsToLicense", AddPointsToLicense)