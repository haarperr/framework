RegisterNetEvent("jobs:getKeys")
AddEventHandler("jobs:getKeys", function(netId)
    if not netId then return end

    local entity 
	
	local attempts = 15
	for i = 1, attempts do
		entity = NetworkGetEntityFromNetworkId(netId)
		if DoesEntityExist(entity) then
			break
		else
			Citizen.Wait(200)
		end
	end

	if not DoesEntityExist(entity) then
		return
	end

	exports.vehicles:GiveKey(source, netId)
end)