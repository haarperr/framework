IsRagdolled = false

Citizen.CreateThread(function()
	while true do
		if IsRagdolled then
			SetPedToRagdoll(PlayerPedId(), 2000, 1000, 0)
		else
			Citizen.Wait(200)
		end
		
		Citizen.Wait(0)
	end
end)

RegisterCommand("+nsrp_ragdoll", function()
	IsRagdolled = true
end, true)

RegisterCommand("-nsrp_ragdoll", function()
	IsRagdolled = false
end, true)

RegisterKeyMapping("+nsrp_ragdoll", "Ragdoll", "keyboard", "o")