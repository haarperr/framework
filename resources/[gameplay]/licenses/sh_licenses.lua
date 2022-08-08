function _HasLicense(source, name)
	local license = GetLicense(source, name)
	return license ~= nil and license.points < 25
end