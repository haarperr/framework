IsDead = false
local RandomAnim = nil
local Vehicle = nil
local VehicleSeat = nil
IsDying = false
DeadTime = 0

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)

		if IsPedDeadOrDying(ped) then
			SetFlash(0, 0, 300, 20, 600)
			UpdateInfo()
			
			DeadTime = GetGameTimer()
			IsDying = true

			-- Get current vehicle.
			Vehicle = GetVehiclePedIsIn(ped, false)
			if Vehicle ~= 0 then
				VehicleSeat = exports.oldutils:GetSeatPedIsIn(Vehicle, ped)
			else
				Vehicle = nil
			end

			-- Wait before instantly reviving.
			Citizen.Wait(Config.Down.Delay)
			if not IsDying then goto skip end

			RandomAnim = nil
			-- anim = GetDownedAnim()
			-- while not HasAnimDictLoaded(anim.dict) do RequestAnimDict(anim.dict) Citizen.Wait(0) end

			-- Wait until we're stationairy.
			while GetEntitySpeed(ped) > Config.Down.MaxSpeed and not IsPedSwimming(ped) do
				Citizen.Wait(Config.Down.Delay)
				if not IsDying then goto skip end
			end

			-- Fade out/in.
			-- DoScreenFadeOut(Config.Down.FadeTime)
			-- Citizen.Wait(Config.Down.FadeTime)
			-- if not IsDying then goto skip end
			
			-- Cache position.
			pos = GetEntityCoords(ped)
			
			-- Revive the player.
			NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, 0, true, false)
			ClearPedTasksImmediately(ped)
			SetEntityProofs(ped, true, true, true, true, true, true, true, true)

			-- Clear timecycles.
			ResetExtraTimecycleModifierStrength()
			SetExtraTimecycleModifierStrength(0.0)
			SetTimecycleModifierStrength(0.0)

			if Vehicle then
				SetPedIntoVehicle(ped, Vehicle, VehicleSeat)
			end
			
			-- DoScreenFadeIn(Config.Down.FadeTime)
			IsDying = false
			IsDead = true

			-- Trigger event.
			TriggerEvent("health:die")
		elseif IsDead then
			local anim = GetDownedAnim()
			
			while not HasAnimDictLoaded(anim.dict) do RequestAnimDict(anim.dict) Citizen.Wait(0) end

			-- SetEntityHealth(ped, GetEntityMaxHealth(ped))
			SetPedCanRagdoll(ped, false)

			if (not IsEntityPlayingAnim(ped, anim.dict, anim.name, 3) or IsPedInMeleeCombat(ped)) then
				if not IsPedInAnyVehicle(ped) then
					ClearPedTasksImmediately(ped)
				end
				TaskPlayAnim(ped, anim.dict, anim.name, Config.Down.BlendSpeed, Config.Down.BlendSpeed, -1, 1, 1.0, false, false, false)
				Citizen.Wait(500)
			end

			if IsPedSwimmingUnderWater(ped) then
				local velocity = GetEntityVelocity(ped)
				SetEntityVelocity(ped, velocity.x, velocity.y, Config.Down.Water.Buoyancy)
			end
		end
		::skip::
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		if IsPedDead(ped) then
			DisableControls()
		else
			Citizen.Wait(Config.Down.Delay)
		end
	end
end)

--[[ Functions ]]--
function IsPedDead(ped)
	return IsDead or IsDying or IsPedDeadOrDying(ped)
end
exports("IsPedDead", IsPedDead)

function ResurrectPed()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped)
	local seat = -1
	if vehicle ~= 0 then
		seat = exports.oldutils:GetSeatPedIsIn(vehicle, ped)
	end
	if IsPedDeadOrDying(ped) then
		-- Cache position.
		pos = GetEntityCoords(ped)
			
		-- Revive the player.
		NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, 0, true, false)
		ClearPedTasksImmediately(ped)
		SetEntityProofs(ped, true, true, true, true, true, true, true, true)
	end
	IsDead = false
	IsDying = false
	SetPedCanRagdoll(ped, true)
	ClearPedTasksImmediately(ped)
	SetEntityProofs(ped, false, false, false, false, false, false, false, false)
	HealPed(ped)
	if DoesEntityExist(vehicle) then
		SetPedIntoVehicle(ped, vehicle, seat)
	end
	TriggerEvent("health:resurrect")
end
exports("ResurrectPed", ResurrectPed)

function Slay()
	SetEntityHealth(PlayerPedId(), 0)
end

function DisableControls()
	for _, v in ipairs(Config.Down.Controls) do
		DisableControlAction(0, v, true)
	end
end

function GetDownedAnim()
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	local anim

	if DoesEntityExist(vehicle) then
		anim = Config.Down.Vehicles.Anim
	elseif IsPedSwimming(ped) then
		anim = Config.Down.Water.Anim
	else
		anim = Config.Down.Anim
	end
	
	if anim.random and not RandomAnim then
		RandomAnim = anim.name:format(anim.random[GetRandomIntInRange(1, #anim.random + 1)])
	end
	if anim.random and RandomAnim then
		anim.name = RandomAnim
	end

	return anim
end

--[[ Events ]]--
RegisterNetEvent("health:revive")
AddEventHandler("health:revive", function()
	ResurrectPed()
end)

RegisterNetEvent("health:slay")
AddEventHandler("health:slay", function()
	Slay()
end)

--[[ Commands ]]--
RegisterCommand("respawn", function(source, args, command)
	if (GetGameTimer() - DeadTime) / 1000 >= Config.RespawnTime then
		if exports.jail:IsJailed() then
			exports.jail:Spawn()
		else
			exports.teleporters:TeleportTo(Config.Spawn)
		end
		ResurrectPed()
		TriggerServerEvent("health:respawned")
	end
end)