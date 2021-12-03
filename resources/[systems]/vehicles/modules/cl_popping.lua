function Main.update:Popping()
	if not Materials or Speed < 70.0 * 0.621371 then return end

	-- 34 = gravel track
	-- 181 = rails

	for wheelIndex, material in pairs(Materials) do
		if material == 34 and not IsVehicleTyreBurst(CurrentVehicle, wheelIndex, true) then
			SetVehicleTyreBurst(CurrentVehicle, wheelIndex, true, 1000.0)
		end
	end
end