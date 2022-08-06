local Players = {}

RegisterNetEvent("grids:setPlayerGrids")
AddEventHandler("grids:setPlayerGrids", function(players)
	Players = players
end)

function GetNearbyPlayers()
	return Players
end
exports("GetNearbyPlayers", GetNearbyPlayers)