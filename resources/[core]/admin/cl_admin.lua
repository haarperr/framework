--[[ Functions ]]--
function Admin:Init()
	local function formatOptions(options)
		for k, option in ipairs(options) do
			if option.checkbox ~= nil then
				option.OnValueChange = function(self, value)
					Admin:InvokeHook("toggle", option.hook, value)
				end
			elseif option.options then
				formatOptions(option.options)
			else
				option.func = function(self)
					Admin:InvokeHook("select", option.hook)
				end
			end
		end
	end

	formatOptions(Config.Options)
end

function Admin:GetPlayer(serverId)
	local player = self.players[serverId]
	if player then
		return player
	end

	TriggerServerEvent(self.event.."requestPlayer", serverId)

	local startTime = GetGameTimer()
	while self.players[serverId] == nil or GetGameTimer() - startTime > 500 do
		Citizen.Wait(20)
	end

	return self.players[serverId]
end

--[[ Events ]]--
AddEventHandler(Admin.event.."clientStart", function()
	Admin:Init()
end)

RegisterNetEvent(Admin.event.."receivePlayer", function(serverId, data)
	Admin.players[serverId] = data
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
	end
end)

--[[ Callbacks ]]--
RegisterNUICallback("request", function(data)
	Admin:InvokeHook("request", data.name, data.active)
end)

RegisterNUICallback("toggle", function(data)
	Admin:InvokeHook("toggle", data.name, data.active)
end)