Main = {
	licenses = {}
}

AddEventHandler("character:selected", function(source, character)
	if character then
		local licenses = {}
		local result = exports.GHMattiMySQL:QueryResult("SELECT name, points FROM licenses WHERE character_id=@character_id", {
			["@character_id"] = character.id,
		})

		for k, v in pairs(result) do
			licenses[v.name] = v
		end

		Main.licenses[character.id] = licenses

		exports.character:Set(source, "licenses", Main.licenses[character.id])
		TriggerClientEvent("licenses:load", source, Main.licenses[character.id])
	end
end)

RegisterNetEvent("licenses:shareLicense")
AddEventHandler("licenses:shareLicense", function(target, data)
	TriggerClientEvent("chat:notify", target, data)
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
	return Main.licenses[exports.character:Get(source, "id")][license]
end
exports("GetLicense", GetLicense)

function GetLicenses(source)
	return Main.licenses[exports.character:Get(source, "id")]
end
exports("GetLicenses", GetLicenses)

function HasLicense(source, name)
	return _HasLicense(source, name)
end
exports("HasLicense", HasLicense)

function CheckFaction(source)
	local job = exports.jobs:GetCurrentJob(source)
	if job == nil then return false end
	
	if job.Faction == "pd" or job.Faction == "ems" or job.Faction == "federal" then
		return true
	end

	return false
end

function AddLicense(source, license)
	local character = exports.character:GetCharacter(source)
	if not character then return false end

	local licenses = GetLicenses(source)
	if not licenses then return false end

	if licenses[license] then
		return false
	end

	local data = {
		name = license,
		points = 0,
	}

	local query = [[
		INSERT INTO `licenses`
		SET
			`character_id`=@characterId,
			`name`=@name,
			`points`=@points
	]]
	local values = {
		["@characterId"] = character.id,
		["@name"] = license,
		["@points"] = 0,
	}

	if exports.GHMattiMySQL:Query(query, values) then
		licenses[license] = data
		Main.licenses[character.id] = licenses

		exports.character:Set(source, "licenses", Main.licenses[character.id])
		TriggerClientEvent("licenses:load", source, Main.licenses[character.id])
		return true
	else
		return false
	end
end
exports("AddLicense", AddLicense)

function CanLicense(source, license)
	if source == 0 then return true end
	local character = exports.character:GetCharacter(source)
	if not character then return false end

	local job = exports.jobs:GetCurrentJob(source)
	if not job then return false end

	if not job.Licenses then return false end

	for k, v in ipairs(job.Licenses) do
		if v.Name:lower() == license then
			return true
		end
	end

	return false
end

function CheckLicense(source, license)
	if not CanLicense(source, license) then
		TriggerClientEvent("chat:notify", source, "You cannot control that license!", "error")
		return false
	end
	return true
end

function RemoveLicense(source, license)
	local character = exports.character:GetCharacter(source)
	if not character then return false end

	local licenses = GetLicenses(source)
	if not licenses then return false end

	if not licenses[license] then
		return false
	end

	local query = [[
		DELETE FROM `licenses`
		WHERE
			`character_id`=@characterId
			AND `name`=@name
	]]
	local values = {
		["@characterId"] = character.id,
		["@name"] = license,
	}
	if exports.GHMattiMySQL:Query(query, values) then
		licenses[license] = nil
		Main.licenses[character.id] = licenses
		exports.character:Set(source, "licenses", Main.licenses[character.id])
		TriggerClientEvent("licenses:load", source, Main.licenses[character.id])
		return true
	else
		return false
	end
end
exports("RemoveLicense", RemoveLicense)

function AddPointsToLicense(source, name, points)
	local character = exports.character:GetCharacter(source)
	if not character then return false end

	local licenses = GetLicenses(source)
	if not licenses then return false end

	local license = licenses[name]
	if not license then return false end

	local currentPoints = license.points
	license.points = math.min(math.max(currentPoints + points, 0), 255)

	local query = [[
		UPDATE `licenses`
		SET
			`points`=@points
		WHERE
			`character_id`=@characterId
			AND `name`=@name
	]]
	local values = {
		["@characterId"] = character.id,
		["@name"] = name,
		["@points"] = license.points,
	}

	if exports.GHMattiMySQL:Query(query, values) then
		Main.licenses[character.id][name] = license
		exports.character:Set(source, "licenses", Main.licenses[character.id])
		TriggerClientEvent("licenses:load", source, Main.licenses[character.id])
		return true
	else
		return false
	end
end
exports("AddPointsToLicense", AddPointsToLicense)

exports.chat:RegisterCommand("licenses", function(source, args, command)
	if source == 0 then return end
	TriggerClientEvent("licenses:check", source)
end, {
	description = "Check your licenses.",
	parameters = {}
}, -1)

exports.chat:RegisterCommand("licenseadd", function(source, args, command)
	local character = exports.character:GetCharacter(source)
	if not character then return false end

	local target = tonumber(args[1])
	if not exports.character:Get(target, "id") then return end

	local license = tostring(args[2]):lower()
	if not CheckLicense(source, license) then return end
	
	if AddLicense(target, license) then
		if source ~= 0 then
			TriggerClientEvent("chat:addMessage", source, ("You gave a %s license to [%s]"):format(license, target))
		end
		exports.log:Add({
			source = source,
			target = target,
			verb = "gave",
			noun = "license",
			extra = license,
		})
	elseif source ~= 0 then
		TriggerClientEvent("chat:addMessage", source, "They already have that license!")
	end
end, {
	description = "Assign somebody a license.",
	parameters = {
		{ name = "Target", description = "Who to give the license to." },
		{ name = "License", description = "The license to give." },
	}
}, 2, 0)

exports.chat:RegisterCommand("licenserevoke", function(source, args, command)
	local character = exports.character:GetCharacter(source)
	if not character then return false end

	local target = tonumber(args[1])
	if not exports.character:Get(target, "id") then return end

	local license = tostring(args[2]):lower()
	if not CheckLicense(source, license) then return end
	
	if RemoveLicense(target, license) then
		if source ~= 0 then
			TriggerClientEvent("chat:addMessage", source, ("You revoked a %s license for [%s]"):format(license, target))
		end
		exports.log:Add({
			source = source,
			target = target,
			verb = "revoked",
			noun = "license",
			extra = license,
		})
	elseif source ~= 0 then
		TriggerClientEvent("chat:addMessage", source, "They don't have that license!")
	end
end, {
	description = "Revoke somebody's license.",
	parameters = {
		{ name = "Target", description = "Who to give the license to." },
		{ name = "License", description = "The license to give." },
	}
}, 2, 0)

exports.chat:RegisterCommand("licensepoints", function(source, args, command)
	local character = exports.character:GetCharacter(source)
	if not character then return false end

	local target = tonumber(args[1])
	if not exports.character:Get(target, "id") then return end

	local license = tostring(args[2]):lower()
	if not CheckLicense(source, license) then return end

	local points = tonumber(args[3])
	if not points then return end
	
	if AddPointsToLicense(target, license, points) then
		local verb = "gave"
		local preposition = "to"
		if points < 0 then
			verb = "took"
			preposition = "from"
		end
		local message = ("%s %s points %s the %s license for [%s]"):format(verb, math.abs(points), preposition, license, target)
		if source ~= 0 then
			TriggerClientEvent("chat:addMessage", source, "You "..message..".")
		end
		exports.log:Add({
			source = source,
			target = target,
			verb = "gave",
			noun = "license points",
			extra = ("%s - points: %s"):format(license, points),
		})
	else
		TriggerClientEvent("chat:addMessage", source, "They don't have that license!")
	end
end, {
	description = "Give or take points on somebody's license.",
	parameters = {
		{ name = "Target", description = "Who's license to change." },
		{ name = "License", description = "The license to change." },
		{ name = "Points", description = "The points to give (positive) or take (negative)." },
	}
}, 3, 0)

exports.chat:RegisterCommand("licensecheck", function(source, args, rawCommand)
	local character = exports.character:GetCharacter(source)
	if not character then return false end

	if not CheckFaction(source) then return end
	
	local message = ""

	local target = tonumber(args[1])
	if not target then return end

	local character = exports.character:GetCharacter(target)
	if not character then return end

	local licenses = GetLicenses(target)

	if licenses then
		for license, info in pairs(licenses) do
			if message ~= "" then
				message = message..", "
			end
			message = ("%s%s (%s)"):format(message, license, info.points)
		end
	end
	if message == "" then
		message = "You have no licenses."
	else
		message = ("Current points on licenses for %s %s: %s."):format(character.first_name, character.last_name, message)
	end

	TriggerClientEvent("chat:addMessage", source, message, "emergency")
end, {
	description = "",
	parameters = {
		{ name = "Target", description = "ID of the target." },
	}
}, 1)