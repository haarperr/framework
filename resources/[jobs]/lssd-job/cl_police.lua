RegisterCommand("impound", function()
	local dist = 4.0
	if not exports.interaction:CanDo() then return end
	
	if not exports.jobs:IsInEmergency("CanImpound") then
		return
	end

	local vehicle = exports.oldutils:GetNearestVehicle()
	if not DoesEntityExist(vehicle) then return end

	local ped = PlayerPedId()
	if #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > dist then return end

	exports.mythic_progbar:Progress({
		Anim = {
			Dict = "amb@world_human_stand_mobile_fat@female@standing@call@idle_a",
			Name = "idle_b",
			Flag = 49,
			DisableMovement = true,
		},
		Label = "Impounding...",
		Duration = 15000,
		UseWhileDead = false,
		CanCancel = true,
		Disarm = false,
	}, function(wasCancelled)
		if wasCancelled then return end

		if not DoesEntityExist(vehicle) or #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > dist then return end

		exports.oldutils:Delete(vehicle)
	end)
end)