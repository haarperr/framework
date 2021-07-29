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