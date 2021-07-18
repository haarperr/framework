local Distance = 1.5
local Searching = 0
local IsDone = false

--[[ Functions ]]--
Messages["search"] = function(source, message, value)
	exports.mythic_notify:SendAlert("error", "You feel somebody reaching into your pockets...", 7000)
end

--[[ Events ]]--
-- AddEventHandler("gameEventTriggered", function(name, args)
-- 	if not Searching then return end
-- 	if name ~= "CEventNetworkEntityDamage" then return end
-- 	if PlayerPedId() ~= args[1] then return end
	
-- 	SendMessage(Searching, "search", 2)
-- end)

--[[ Commands ]]--
RegisterCommand("search", function()
	local ped = PlayerPedId()

	if IsPedInAnyVehicle(ped) then return end

	local player = GetPlayer(Distance)
	if player == 0 then
		NobodyNearby("search")
		return
	end
	
	IsDone = false
	Searching = player
	
	SendMessage(player, "search", false)
	
	exports.mythic_progbar:Progress({
		Anim = {
			Dict = "anim@gangops@facility@servers@bodysearch@",
			Name = "player_search",
			Flag = 48,
		},
		Label = "Searching...",
		Duration = 5000,
		UseWhileDead = false,
		DisableMovement = true,
		CanCancel = true,
		Disarm = true,
	}, function(wasCanceled)
		if wasCanceled then return end
		
		player = GetPlayer(Distance)

		if player ~= Searching then
			Searching = 0
			NobodyNearby("search")
		else
			IsDone = true
			SendMessage(player, "search", true)
			exports.inventory:ToggleMenu(true)
		end
	end)
end)