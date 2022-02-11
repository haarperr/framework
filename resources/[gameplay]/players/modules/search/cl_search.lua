Search = {
	anims = {
		normal = { Dict = "missexile3", Name = "ex03_dingy_search_case_a_michael", Flag = 48, Disarm = true, Duration = 7000 },
		frisk = { Dict = "anim@gangops@facility@servers@bodysearch@", Name = "player_search", Flag = 48, Disarm = true, Duration = 2000 },
	},
}

--[[ Options ]]--
Main:AddOption({
	id = "playerSearch",
	text = "Search",
	icon = "search",
}, function(player, playerPed, dist, serverId)
	return Search:CanSearch(player)
end, function(player, playerPed, serverId)
	Search:Begin(player)
end)

Main:AddOption({
	id = "playerFrisk",
	text = "Frisk",
	icon = "waving_hand",
}, function(player, playerPed, dist, serverId)
	return Search:CanSearch(player)
end, function(player, playerPed, serverId)
	Search:Begin(player, true)
end)

--[[ Functions ]]--
function Search:CanSearch(player)
	local localState = LocalPlayer.state
	if not localState or localState.restrained or localState.immobile then return false end

	local serverId = GetPlayerServerId(player)
	local playerState = Player(serverId).state
	if not playerState then return false end

	return playerState.handsup or playerState.immobile or playerState.restrained
end

function Search:Begin(player, frisk)
	local anim = frisk and Search.anims.frisk or Search.anims.normal
	local emote = exports.emotes:Play(anim)

	local startTime = GetGameTimer()
	while GetGameTimer() - startTime < anim.Duration do
		if not NetworkIsPlayerActive(player) or not Search:CanSearch(player) then return end

		local playerPed = GetPlayerPed(player)
		local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(PlayerPedId()))
		if dist > Config.MaxDist then
			exports.emotes:Stop(emote)
			return
		end

		Citizen.Wait(50)
	end

	TriggerServerEvent("players:search", GetPlayerServerId(player), frisk)
end

--[[ Events ]]--
AddEventHandler("players:navigate", function(value)
	-- Remove option.
	if not value then
		if Search.value then
			Main:RemoveOption("playerSearch")
			Main:RemoveOption("playerFrisk")

			Search.value = nil
		end

		return
	end

	local state = (LocalPlayer or {}).state
	if not state then return end

	Search.value = true
	
	Main:AddOption({
		id = "playerSearch",
		text = "Search",
		icon = "search",
	})

	Main:AddOption({
		id = "playerFrisk",
		text = "handshake",
		icon = "",
	})
end)