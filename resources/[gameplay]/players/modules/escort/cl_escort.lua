Escort = {}

--[[ Options ]]--
Main:AddOption({
	id = "playerEscort",
	text = "Escort",
	icon = "follow_the_signs",
})

--[[ Functions: Escort ]]--
function Escort:Start(serverId)
	local player = GetPlayerFromServerId(serverId)
	if not player then return end

	local ped = PlayerPedId()
	local playerPed = GetPlayerPed(player)
	
	self.target = playerPed
end

function Escort:Stop()
	if not self.target then return end
	local ped = PlayerPedId()

	self.target = nil

	ClearPedTasks(ped)
	ClearPedSecondaryTask(ped)
end

function Escort:Update()
	if not self.target then return end

	if not DoesEntityExist(self.target) then
		self:Stop()
		return
	end

	local ped = PlayerPedId()
	local dist = Distance(GetEntityCoords(ped), GetEntityCoords(self.target))

	if dist > 10.0 then
		TriggerServerEvent("players:escort")
	end

	if dist > 1.0 then
		TaskFollowToOffsetOfEntity(ped, self.target, 0.0, 0.0, 0.0, 1.0, -1, 0.5, true)
	end
end

--[[ Events: Net ]]--
RegisterNetEvent("players:escort", function(serverId)
	if serverId then
		Escort:Start(serverId)
	else
		Escort:Stop()
	end
end)

--[[ Events ]]--
AddEventHandler("interact:onNavigate_playerEscort", function()
	if Main.serverId then
		TriggerServerEvent("players:escort", Main.serverId)
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Escort:Update()
		Citizen.Wait(200)
	end
end)