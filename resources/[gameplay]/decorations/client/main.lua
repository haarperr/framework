--[[ Functions ]]--
function Main:Init()
	for item, settings in pairs(Config.Decorations) do
		self:CheckModel(item, settings.Model)
	end
end

function Main:CheckModel(item, model)
	if type(model) == "table" then
		if #model == 0 then
			self:CheckModel(item, model.Name)
		else
			for k, v in ipairs(model) do
				self:CheckModel(item, v)
			end
		end
		return
	end

	if not IsModelValid(model) then
		print(("invalid model '%s' for decoration '%s'"):format(model, item))
	end
end

function Main:Input()

end

function Main:GetModel(settings, variant)
	local model = settings.Model
	return type(model) == "table" and model[variant or 1] or model
end

function Main:ClearAll()
	for id, decoration in pairs(self.decorations) do
		decoration:Destroy()
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Input()
		Citizen.Wait(0)
	end
end)

--[[ Events ]]--
AddEventHandler(Main.event.."clientStart", function()
	Main:Init()
end)

RegisterNetEvent(Main.event.."stop", function()
	Main:ClearAll()
end)

AddEventHandler("inventory:use", function(item, slot, cb)
	if item.usable ~= "Decoration" then return end

	cb()
end)

AddEventHandler("inventory:useFinish", function(item, slot)
	if item.usable ~= "Decoration" then return end

	local settings = Config.Decorations[item.name]
	if not settings then
		error("decoration not configured for item: "..tostring(item.name))
	end

	Editor:Use(item.name, slot)
end)

AddEventHandler("eventName", function(...)
	
end)

--[[ Events: Net ]]--
RegisterNetEvent(Main.event.."sync", function(grids)
	Debug("Syncing decorations")

	if not grids then
		Main:ClearAll()
		return
	end

	for gridId, grid in pairs(Main.grids) do
		if not grids[gridId] then
			for id, decoration in pairs(grid) do
				decoration:Destroy()
			end
		end
	end
	
	for gridId, grid in pairs(grids) do
		for id, decoration in pairs(grid) do
			if not Main.decorations[decoration.id or false] then
				Decoration:Create(decoration)
			end
		end
	end
end)

RegisterNetEvent(Main.event.."add", function(data)
	Decoration:Create(data)
end)

RegisterNetEvent(Main.event.."remove", function(id)
	local decoration = Main.decorations[id]
	if decoration then
		decoration:Destroy()
	end
end)