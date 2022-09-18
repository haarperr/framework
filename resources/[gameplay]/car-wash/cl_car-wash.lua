local vehicleWashStation = {
	vector3(-699.8628540039062, -933.6217041015624, 18.11902053833008), -- Little Seoul Car Wash.
	vector3(24.11212730407715, -1391.7774658203125, 28.43477066040039), -- Strawberry Car Wash.
	vector3(174.8283843994141, -1736.89013671875, 28.3515544128418), -- Davis Car Wash.
	vector3(-75.14895629882812, 6424.18603515625, 30.515850067138672), -- Paleto Car Wash.
	vector3(1207.61572265625, 2642.44140625, 36.85282516479492), -- Harmony Car Wash.
	vector3(894.4950561523438, -1019.5545043945312, 34.96679306030273), -- Outside Misfits.
}

--[[ Threads ]]--
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		if IsPedSittingInAnyVehicle(PlayerPedId()) then 
			for i = 1, #vehicleWashStation do
				coords = vehicleWashStation[i]
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords.x, coords.y, coords.z, true) < 5 then
					DisableControlAction(0, 86)
					if exports.oldutils:DrawContext("Wash Vehicle", coords + vector3(0.0, 0.0, 1.0)) then
						TriggerServerEvent("car-wash:wash")
					end
				end
			end
		end
	end
end)

--[[ Events ]]--
RegisterNetEvent("car-wash:wash")
AddEventHandler("car-wash:wash", function()
	SetVehicleDirtLevel(GetVehiclePedIsUsing(PlayerPedId()))
	TriggerEvent("chat:notify", { text = "You've washed your car!", class = "inform" })
end)