Citizen.CreateThread(function()
	while true do
		TriggerClientEvent("discord-rp:updatePlayers", -1, GetNumPlayerIndices(), GetConvarInt("sv_maxClients", 0))
		Citizen.Wait(15000)
	end
end)