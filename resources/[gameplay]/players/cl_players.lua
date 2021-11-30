Main = {
	options = {},
}

--[[ Functions: Main ]]--
function Main:Update()
	if not self.open then return end

	local player, playerPed, playerDist = GetNearestPlayer()
	if player ~= self.player then
		self:BuildNavigation()
	end
end

function Main:ClearNavigation()
	if not self.open then
		return
	end

	exports.interact:RemoveOption("players")

	self.open = nil
	self.player = nil
	self.serverId = nil
end

function Main:BuildNavigation()
	self:ClearNavigation()

	local player, playerPed, playerDist = GetNearestPlayer()
	if not player or playerDist > Config.MaxDist then return end

	exports.interact:AddOption({
		id = "players",
		text = ("Player [%s]"):format(GetPlayerServerId(player) or "?"),
		icon = "group",
		sub = self.options,
	})

	self.open = true
	self.player = player
	self.serverId = GetPlayerServerId(player)
end

function Main:AddOption(data)
	self.options[#self.options + 1] = data
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(200)
	end
end)

--[[ Events ]]--
AddEventHandler("interact:navigate", function(value)
	if value then
		Main:BuildNavigation()
	else
		Main:ClearNavigation()
	end
end)

AddEventHandler("interact:onNavigate_players", function(...)
	print(json.encode({...}))
end)