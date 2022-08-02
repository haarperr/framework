function GetStorageValue(model)
	local settings = exports.vehicles:GetSettings(model) or {}
	return math.floor((settings.Value or 0)^0.75 * 0.03)
end