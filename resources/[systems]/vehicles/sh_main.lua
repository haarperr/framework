Main = {
	listeners = {},
	classes = {},
	hashes = {},
	settings = {},
}

--[[ Functions: Main ]]--
function Main:LoadSettings()
	for model, settings in pairs(Vehicles) do
		if GetLabelText then
			-- Get name.
			settings.Name = GetLabelText(model)
			if settings.Name == "NULL" then
				settings.Name = model:gsub("^%l", string.upper)
			end

			-- Get class.
			settings.Class = GetVehicleClassFromName(model)
			settings.Category = GetLabelText("VEH_CLASS_"..settings.Class)

			-- Cache settings.
			self.settings[model] = settings
			self.hashes[GetHashKey(model)] = model

			-- Cache class.
			local classList = Main.classes[settings.Class]
			if not classList then
				classList = {}
				self.classes[settings.Class] = classList
			end
			classList[model] = settings
		else
			self.hashes[GetHashKey(model)] = model
		end
	end
end

function Main:GetSettings(model)
	if not model then return {} end
	if type(model) == "number" then
		model = self.hashes[model]
		if not model then return {} end
	end
	return Vehicles[model] or {}
end

function Main:AddListener(_type, cb)
	local listeners = self.listeners[_type]
	if not listeners then
		listeners = {}
		self.listeners[_type] = listeners
	end

	listeners[cb] = true
end

function Main:InvokeListener(_type, ...)
	local listeners = self.listeners[_type]
	if not listeners then return false end

	for func, _ in pairs(listeners) do
		func(...)
	end

	return true
end

function Main:GetEntityFromNetworkId(netId)
	if type(netId) ~= "number" then return end

	local entity = NetworkGetEntityFromNetworkId(netId)
	if not entity or not DoesEntityExist(entity) then return end

	return entity
end

function GetColor(id)
	return Colors[id].Name or "Unknown"
end
exports("GetColor", GetColor)

function GetName(key)
	return (Main:GetSettings(key) or {}).Name or "Unknown"
end
exports("GetName", GetName)

--[[ Exports ]]--
exports("GetSettings", function(...)
	return Main:GetSettings(...)
end)

--[[ Events ]]--
Citizen.CreateThread(function()
	Main:LoadSettings()
end)