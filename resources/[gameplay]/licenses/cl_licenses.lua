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

-- Init License Events
for k, v in pairs(Config.Licenses) do
	AddEventHandler("interact:onNavigate_"..k, function()
		local player, playerPed, playerDist = exports.oldutils:GetNearestPlayer()
		if player ~= 0 then
			TriggerServerEvent("licenses:shareLicense", GetPlayerServerId(player), {class="inform", text="[ "..v.name.." License ] "..exports.character:GetName().." | Points: "..licenses[k].points})
		end
		TriggerEvent("chat:notify", {class="inform", text="[ "..v.name.." License ] "..exports.character:GetName().." | Points: "..licenses[k].points})
	end)
end

RegisterNetEvent("licenses:load", function(licenseData)
	licenses = licenseData or {}
	exports.character:Set("licenses", licenseData)
	local navigation = {}
	for k, v in pairs(licenseData) do
		if Config.Licenses[v.name] ~= nil then
			table.insert(navigation, { id = v.name, text = Config.Licenses[v.name].name, icon = Config.Licenses[v.name].icon})
		end
	end
	exports.interact:RemoveOption("licensesRoot")
	exports.interact:AddOption({
		id = "licensesRoot",
		text = "Licenses",
		icon = "assignment",
		sub = navigation,
	})
end)

RegisterNetEvent("licenses:check")
AddEventHandler("licenses:check", function()
	local message = ""
	local licenses = GetLicenses()

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