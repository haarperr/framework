local godmode = false
local invisible = false

--[[ Functions ]]--
local function SetGodmode(value)
	local player = PlayerId()

	SetPlayerInvincible(player, value)
end

local function SetInvisible(value)
	local ped = PlayerPedId()

	SetEntityVisible(ped, not value)
	
	if value then
		SetEntityAlpha(ped, 128)
	else
		ResetEntityAlpha(ped)
	end
end

--[[ Hooks ]]--
Admin:AddHook("toggle", "godmode", function(value)
	godmode = value
	
	SetGodmode(value)
end)

Admin:AddHook("toggle", "invisibility", function(value)
	local ped = PlayerPedId()

	invisible = value

	SetInvisible(value)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local player = PlayerId()

		if godmode and not GetPlayerInvincible(player) then
			SetGodmode(true)
		end

		if invisible then
			if not IsEntityVisible(ped) ~= invisible then
				SetInvisible(true)
			end

			SetPlayerVisibleLocally(player, true)
		end

		Citizen.Wait(0)
	end
end)