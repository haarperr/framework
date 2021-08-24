local DisabledControls = { 22, 24, 25, 45, 44, 55, 59, 69, 70, 76, 86, 140, 141, 142, 257, 263, 264, 278, 279 }
local Distance = 1.2
local Text = "ziptie"
IsZiptied = false
ZiptieTime = nil

DecorRegister("IsZiptied", 2)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		while not IsZiptied do
			Citizen.Wait(200)
		end

		local ped = PlayerPedId()

		for k, v in ipairs(DisabledControls) do
			DisableControlAction(0, v)
		end

		if IsZiptied then
			DisableControlAction(0,24)
			DisableControlAction(0,25)
		end
	
		if not exports.vehicles:IsInTrunk() and not exports.health:IsPedDead(PlayerPedId()) and not IsEntityPlayingAnim(ped, "mp_arresting", "idle", 3) then
			UpdateTies()

			Citizen.Wait(200)
		end

		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
exports("IsZiptied", function()
	return IsZiptied == true
end)

Messages["ziptie"] = function(source, message, value)
	if not value then
		SetZiptied(false)
		exports.emotes:Stop()

		return
	elseif IsZiptied and value then
		return
	end
	
	Citizen.CreateThread(function()
		ZiptieTime = GetGameTimer()

		exports.emotes:Play({
			Dict = "mp_arrest_paired",
			Name = "crook_p2_back_right"
		})
		
		TriggerEvent("disarmed")

		local result = nil
		local stunned = IsPedBeingStunned(PlayerPedId())

		if not stunned and not (GetResourceState("health") == "started" and exports.health:IsPedDead(PlayerPedId())) then
			TriggerEvent("quickTime:begin", "linear", GetRandomFloatInRange(10.0, 15.0), function(status)
				result = status
			end)
		else
			result = false
		end
		
		while result == nil do
			Citizen.Wait(20)
		end
		
		if result then
			SetZiptied(false)
			SendMessage(source, "ziptie-breakout", true)

			exports.emotes:Stop()
		else
			SetZiptied(true)
			UpdateTies()
		end
	end)
end

Items["Ziptie"] = function()
	return CanUse(Distance, Text)
end

function UpdateTies()
	exports.emotes:Play({
		Dict = "mp_arresting",
		Name = "idle",
		Props = {
			{ Model = "hei_prop_zip_tie_positioned", Bone = 28422, Offset = { -0.02, 0.07, -0.03, 0.0, 0.0, 90.0 }},
		},
		Flag = 49,
		BlendSpeed = 100.0,
		Ziptie = true,
	})
end

function CanZiptie(player)
	if not player then return false end
	local ped = PlayerPedId()
	local playerPed = GetPlayerPed(GetPlayerFromServerId(player))
	if not DoesEntityExist(playerPed) then return false end

	if IsPedRagdoll(playerPed) then
		return true
	end

	local pedForward = GetEntityForwardVector(ped)
	local playerForward = GetEntityForwardVector(playerPed)
	return exports.misc:Dot(pedForward, playerForward) > 0.5 and exports.misc:Dot(exports.misc:Normalize(GetEntityCoords(playerPed) - GetEntityCoords(ped)), playerForward) > 0.5
end

function SetZiptied(value)
	IsZiptied = value
	exports.emotes:SetCustomWalkStyle(nil)
	DecorSetBool(PlayerPedId(), "IsZiptied", value)
end
exports("SetZiptied", SetZiptied)

--[[ Items ]]--
RegisterNetEvent("inventory:use_Ziptie")
AddEventHandler("inventory:use_Ziptie", function()
	local player = GetPlayer()
	if player == 0 then return end
	if not CanZiptie(player) then return end
	
	if DecorGetBool(playerPed, "IsZiptied") then
		return
	end
	
	SendMessage(player, "ziptie", true)

	exports.emotes:Play({
		Dict = "mp_arrest_paired",
		Name = "cop_p2_back_right",
		Duration = 3000,
	})
end)

RegisterNetEvent("inventory:use_Scissors")
AddEventHandler("inventory:use_Scissors", function()
	local player = GetPlayer(2.0)
	if player == 0 then return end
	if not CanZiptie(player) then return end

	local playerPed = GetPlayerPed(GetPlayerFromServerId(player))
	if not DoesEntityExist(playerPed) then return false end

	if not DecorGetBool(playerPed, "IsZiptied") then
		return
	end

	exports.mythic_progbar:Progress({
		Anim = {
            Dict = "mp_arresting",
            Name = "a_uncuff",
			Flag = 49,
			DisableMovement = true,
		},
		Label = "Cutting Ziptie...",
		Duration = 3000,
		UseWhileDead = false,
		DisableMovement = true,
		DisableCarMovement = true,
		CanCancel = true,
		Disarm = true,
	}, function(wasCancelled)
		if wasCancelled then return end

		if player == GetPlayer(2.0) then
			SendMessage(player, "ziptie", false)
		end
	end)
end)