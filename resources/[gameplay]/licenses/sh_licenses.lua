Config = {
	Licenses = {
		["drivers"] = { icon = "drive_eta", name = "Drivers" },
		["weapons"] = { icon = "hardware", name = "Weapons" },
		["medical"] = { icon = "emergency", name = "Medical" },
		["fishing"] = { icon = "set_meal", name = "Fishing" },
		["hunting"] = { icon = "park", name = "Hunting" },
		["boating"] = { icon = "sailing", name = "Boating" },
		["pilots"] = { icon = "flight", name = "Pilots" },
		["realtor"] = { icon = "home", name = "Realtor" },
		["commercial-hunting"] = { icon = "food_bank", name = "Commercial-Hunting" },
		["business"] = { icon = "work", name = "Business" },
	}
}

function _HasLicense(source, name)
	local license = GetLicense(source, name)
	return license ~= nil and license.points < 25
end