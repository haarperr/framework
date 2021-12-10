Main = {
	options = {},
}

--[[ Functions: Main ]]--
function Main:GetPlayer()
	local ped = PlayerPedId()
	local player, playerPed, playerDist

	if not IsPedInAnyVehicle(ped) then
		player, playerPed, playerDist = GetNearestPlayer()
	end

	return player, playerPed, playerDist
end

function Main:Update()
	if not self.open then return end

	local player, playerPed, playerDist = self:GetPlayer()
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
	self.ped = nil
	self.serverId = nil
end

function Main:BuildNavigation()
	self:ClearNavigation()

	local player, playerPed, playerDist = self:GetPlayer()
	if not player or playerDist > Config.MaxDist then return end

	exports.interact:AddOption({
		id = "players",
		text = ("Player [%s]"):format(GetPlayerServerId(player) or "?"),
		icon = "group",
		sub = self.options,
	})

	self.open = true
	self.player = player
	self.ped = playerPed
	self.serverId = GetPlayerServerId(player)
end

function Main:AddOption(data)
	data.players = true
	
	table.insert(self.options, data)

	if self.open then
		self:BuildNavigation()
	end
end

function Main:RemoveOption(id)
	for k, v in ipairs(self.options) do
		if v.id == id then
			-- Remove option.
			table.remove(self.options, k)
			
			-- Update menu.
			self:BuildNavigation()
	
			return true
		end
	end

	return false
end

--[[ Exports ]]--
exports("AddOption", function(data)
	data.resource = GetInvokingResource()

	Main:AddOption(data)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(200)
	end
end)

--[[ Events ]]--
AddEventHandler("onClientResourceStop", function(resourceName)
	local shouldUpdate = false
	for i = #Main.options, 1, -1 do
		local option  = Main.options[i]
		if option and option.resource == resourceName then
			table.remove(Main.options, i)
			shouldUpdate = true
		end
	end

	if shouldUpdate and Main.open then
		Main:BuildNavigation()
	end
end)

AddEventHandler("interact:navigate", function(value)
	if value then
		Main:BuildNavigation()
	else
		Main:ClearNavigation()
	end
end)

AddEventHandler("interact:onNavigate", function(id, option)
	if option.players then
		TriggerEvent("players:on_"..id, Main.player, Main.ped)
	end
end)