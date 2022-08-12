licenses = {}

function GetLicense(_, license)
	return licenses[license]
end
exports("GetLicense", GetLicense)

function GetLicenses()
	return licenses
end
exports("GetLicenses", GetLicenses)

function HasLicense(name)
	return _HasLicense(nil, name)
end
exports("HasLicense", HasLicense)

RegisterNetEvent("licenses:load", function(licenseData)
	licenses = licenseData or {}
	exports.character:Set("licenses", licenseData)
end)

RegisterNetEvent("licenses:check")
AddEventHandler("licenses:check", function()
	local message = ""
	local licenses = exports.character:GetLicenses()

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
		message = ("Licenses: %s."):format(message)
	end

	TriggerEvent("chat:addMessage", message)
end)