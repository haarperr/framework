function WaitForAnimWhileFacingVehicle(anim, vehicle)
	-- Cache time.
	local startTime = GetGameTimer()

	-- Start emote.
	exports.emotes:PerformEmote(anim)

	-- Check vehicle.
	while GetGameTimer() - startTime < anim.Duration do
		exports.interact:Suppress()
		if vehicle ~= exports.oldutils:GetFacingVehicle() then
			exports.emotes:CancelEmote()
			return false
		end
		Citizen.Wait(200)
	end

	-- Return result.
	return true
end