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