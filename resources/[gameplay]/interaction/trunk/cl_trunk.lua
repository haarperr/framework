Text = "force"
Distance = 2.0

--[[ Functions ]]--
Messages["trunk"] = function(source, message, value)
	if IsBeingEscorted() then
		StopBeingEscorted()
	end
	exports.vehicles:GetInTrunk()
end

--[[ Commands ]]--
RegisterCommand("forcetrunk", function()
	if not CanDo() or IsPedInAnyVehicle(PlayerPedId(), true) then return end

	local player = GetPlayer(Distance)
	if player == 0 then
		NobodyNearby(Text)
		return
	end
	
	SendMessage(player, "trunk", true)
end)