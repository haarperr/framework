--[[ Threads ]]--

Citizen.CreateThread(function()
	while true do
		while not CurrentWeapon or GetResourceState("peds") ~= "started" do
			Citizen.Wait(20)
		end

		local player = PlayerId()
		local ped = PlayerPedId()
		local isReloading = IsPedReloading(ped)
		local weapon = CurrentWeapon or GetCurrentPedWeapon(ped)
		local weaponGroup = GetGroup(GetWeapontypeGroup(weapon)) or {}

		if
			weaponGroup.Dispatch
			and weaponGroup.Class > 0
			and ((weaponGroup.Class > 1 and not IsPedInAnyVehicle(ped)) or IsPlayerFreeAiming(player))
			and not exports.jobs:IsInEmergency()
		then
			exports.peds:AddEvent(weaponGroup.Dispatch)
		end
		
		Citizen.Wait(0)
	end
end)