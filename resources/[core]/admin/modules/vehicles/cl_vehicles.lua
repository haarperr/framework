Admin:AddHook("select", "listVehicles", function(option)
	local options = {}
	local classes = exports.vehicles:GetClasses()

	for classId, vehicles in pairs(classes) do
		local class = exports.vehicles:GetClass(classId)
		local _vehicles = {}

		for model, settings in pairs(vehicles) do
			_vehicles[#_vehicles + 1] = {
				label = settings.Name,
				caption = model,
				model = model,
			}
		end

		table.sort(_vehicles, function(a, b)
			return a.label < b.label
		end)

		options[#options + 1] = {
			label = class.Name,
			options = _vehicles
		}
	end

	table.sort(options, function(a, b)
		return a.label < b.label
	end)

	function Navigation:OnSelect(option)
		if option and option.model then
			ExecuteCommand("a:vehspawn "..option.model)
		end
	end

	Navigation:SetOptions(options)
end)