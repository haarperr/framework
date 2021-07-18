local count_bcast_timer = 0
local delay_bcast_timer = 200
local count_sndclean_timer = 0
local delay_sndclean_timer = 400
local actv_ind_timer = false
local count_ind_timer = 0
local delay_ind_timer = 180
local actv_lxsrnmute_temp = false
local srntone_temp = 0
local dsrn_mute = true
local state_indic = {}
local state_lxsiren = {}
local state_pwrcall = {}
local state_airmanu = {}
local ind_state_o = 0
local ind_state_l = 1
local ind_state_r = 2
local ind_state_h = 3
local snd_lxsiren = {}
local snd_pwrcall = {}
local snd_airmanu = {}
RegisterKeyMapping( "-lightbar", "Vehicle - Toggle Lightbar", "keyboard", "Q" )
RegisterKeyMapping( "-siren", "Vehicle - Toggle Siren", "keyboard", "LMENU" )
RegisterKeyMapping( "-csiren", "Vehicle - Cycle Primary Siren", "keyboard", "R" )
RegisterKeyMapping( "-2siren", "Vehicle - Toggle Secondary Siren", "keyboard", "UP" )
RegisterKeyMapping( "-c2siren", "Vehicle - Cycle Secondary Siren", "keyboard", "RIGHT" )
RegisterKeyMapping("+manualtone", "Vehicle - Manual Siren Tone", "keyboard", "R")
RegisterKeyMapping("-takedown", "Vehicle - Takedown Light", "keyboard", "Y")
RegisterKeyMapping("-leftturn", "Vehicle - Left Turn Signal", "keyboard", "LEFT")
RegisterKeyMapping("-rightturn", "Vehicle - Right Turn Signal", "keyboard", "DOWN")
RegisterKeyMapping("-hazard", "Vehicle - Hazard Lights", "keyboard", "BACK")
lightMultiplier = 24.0 -- This is not capped, highly recommended to go above 12.0.
takedownspeed = 50
-- These models will use their real wail siren, as determined by their assigned audio hash in vehicles.meta.
local eModelsWithFireSrn =
{
	"FIRETRUK",
}
-- Models listed below will use AMBULANCE_WARNING as auxiliary siren.
-- Unlisted models will instead use the default wail as the auxiliary siren.
local eModelsWithPcall =
{	
	"AMBULANCE",
	"FIRETRUK",
	"LGUARD",
}
local eModelsWithEMSSrn = 
{
	"AMBULANCE",
	"emsambo",
	"emstahoe",
	"emsexplorer",
}
local eModelsWithBikeSrn = 
{

}
local eModelsWithFIBSrn = 
{

}

function ShowDebug(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function useFiretruckSiren(veh)
	local model = GetEntityModel(veh)
	for i = 1, #eModelsWithFireSrn, 1 do
		if model == GetHashKey(eModelsWithFireSrn[i]) then
			return true
		end
	end
	return false
end

function useEMSSiren(veh)
	local model = GetEntityModel(veh)
	for i = 1, #eModelsWithEMSSrn, 1 do
		if model == GetHashKey(eModelsWithEMSSrn[i]) then
			return true
		end
	end
	return false
end

function useBikeSiren(veh)
	local model = GetEntityModel(veh)
	for i = 1, #eModelsWithBikeSrn, 1 do
		if model == GetHashKey(eModelsWithBikeSrn[i]) then
			return true
		end
	end
	return false
end

function useFIBSiren(veh)
	local model = GetEntityModel(veh)
	for i = 1, #eModelsWithBikeSrn, 1 do
		if model == GetHashKey(eModelsWithFIBSrn[i]) then
			return true
		end
	end
	return false
end

function usePrkRngrSiren(veh)
	local model = GetEntityModel(veh)
	for i = 1, #eModelsWithBikeSrn, 1 do
		if model == GetHashKey(eModelsWithPrkRngrSrn[i]) then
			return true
		end
	end
	return false
end

function usePowercallAuxSrn(veh)
	local model = GetEntityModel(veh)
	for i = 1, #eModelsWithPcall, 1 do
		if model == GetHashKey(eModelsWithPcall[i]) then
			return true
		end
	end
	return false
end

function CleanupSounds()
	if count_sndclean_timer > delay_sndclean_timer then
		count_sndclean_timer = 0
		for k, v in pairs(state_lxsiren) do
			if v > 0 then
				if not DoesEntityExist(k) or IsEntityDead(k) then
					if snd_lxsiren[k] ~= nil then
						StopSound(snd_lxsiren[k])
						ReleaseSoundId(snd_lxsiren[k])
						snd_lxsiren[k] = nil
						state_lxsiren[k] = nil
					end
				end
			end
		end
		for k, v in pairs(state_pwrcall) do
			if v == true then
				if not DoesEntityExist(k) or IsEntityDead(k) then
					if snd_pwrcall[k] ~= nil then
						StopSound(snd_pwrcall[k])
						ReleaseSoundId(snd_pwrcall[k])
						snd_pwrcall[k] = nil
						state_pwrcall[k] = nil
					end
				end
			end
		end
		for k, v in pairs(state_airmanu) do
			if v == true then
				if not DoesEntityExist(k) or IsEntityDead(k) or IsVehicleSeatFree(k, -1) then
					if snd_airmanu[k] ~= nil then
						StopSound(snd_airmanu[k])
						ReleaseSoundId(snd_airmanu[k])
						snd_airmanu[k] = nil
						state_airmanu[k] = nil
					end
				end
			end
		end
	else
		count_sndclean_timer = count_sndclean_timer + 1
	end
end

function TogIndicStateForVeh(veh, newstate)
	if DoesEntityExist(veh) and not IsEntityDead(veh) then
		if newstate == ind_state_o then
			SetVehicleIndicatorLights(veh, 0, false) -- R.
			SetVehicleIndicatorLights(veh, 1, false) -- L.
		elseif newstate == ind_state_l then
			SetVehicleIndicatorLights(veh, 0, false) -- R.
			SetVehicleIndicatorLights(veh, 1, true) -- L.
		elseif newstate == ind_state_r then
			SetVehicleIndicatorLights(veh, 0, true) -- R.
			SetVehicleIndicatorLights(veh, 1, false) -- L.
		elseif newstate == ind_state_h then
			SetVehicleIndicatorLights(veh, 0, true) -- R.
			SetVehicleIndicatorLights(veh, 1, true) -- L.
		end
		state_indic[veh] = newstate
	end
end

function TogMuteDfltSrnForVeh(veh, toggle)
	if DoesEntityExist(veh) and not IsEntityDead(veh) then
		DisableVehicleImpactExplosionActivation(veh, toggle)
	end
end

function SetLxSirenStateForVeh(veh, newstate)
	if DoesEntityExist(veh) and not IsEntityDead(veh) then
		if newstate ~= state_lxsiren[veh] then
			if snd_lxsiren[veh] ~= nil then
				StopSound(snd_lxsiren[veh])
				ReleaseSoundId(snd_lxsiren[veh])
				snd_lxsiren[veh] = nil
			end
			if newstate == 1 then
				if useFiretruckSiren(veh) then
					TogMuteDfltSrnForVeh(veh, false)
				else
					if useEMSSiren(veh)then
						snd_lxsiren[veh] = GetSoundId()
						PlaySoundFromEntity(snd_lxsiren[veh], "RESIDENT_VEHICLES_SIREN_WAIL_01", veh, 0, 0, 0)
						TogMuteDfltSrnForVeh(veh, true)
					elseif useBikeSiren(veh) then 
						snd_lxsiren[veh] = GetSoundId()
						PlaySoundFromEntity(snd_lxsiren[veh], "RESIDENT_VEHICLES_SIREN_WAIL_03", veh, 0, 0, 0)
						TogMuteDfltSrnForVeh(veh, true)
					elseif useFIBSiren(veh) then 
						snd_lxsiren[veh] = GetSoundId()
						PlaySoundFromEntity(snd_lxsiren[veh], "RESIDENT_VEHICLES_SIREN_WAIL_02", veh, 0, 0, 0)
						TogMuteDfltSrnForVeh(veh, true)
					elseif usePrkRngrSiren(veh) then 
						snd_lxsiren[veh] = GetSoundId()
						PlaySoundFromEntity(snd_lxsiren[veh], "RESIDENT_VEHICLES_SIREN_WAIL_04", veh, 0, 0, 0)
						TogMuteDfltSrnForVeh(veh, true)
					else
						snd_lxsiren[veh] = GetSoundId()	
						PlaySoundFromEntity(snd_lxsiren[veh], "VEHICLES_HORNS_SIREN_1", veh, 0, 0, 0)
						TogMuteDfltSrnForVeh(veh, true)
					end
				end
			elseif newstate == 2 then
				if useFiretruckSiren(veh) then
					--TogMuteDfltSrnForVeh(veh, false) -- RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01 ?.
					snd_lxsiren[veh] = GetSoundId()
					PlaySoundFromEntity(snd_lxsiren[veh], "RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01", veh, 0, 0, 0)
					TogMuteDfltSrnForVeh(veh, true)
				elseif useEMSSiren(veh) then
					snd_lxsiren[veh] = GetSoundId()
					PlaySoundFromEntity(snd_lxsiren[veh], "RESIDENT_VEHICLES_SIREN_QUICK_01", veh, 0, 0, 0)
					TogMuteDfltSrnForVeh(veh, true)
				elseif useBikeSiren(veh) then
					snd_lxsiren[veh] = GetSoundId()
					PlaySoundFromEntity(snd_lxsiren[veh], "RESIDENT_VEHICLES_SIREN_QUICK_03", veh, 0, 0, 0)
					TogMuteDfltSrnForVeh(veh, true)
				elseif useFIBSiren(veh) then
					snd_lxsiren[veh] = GetSoundId()
					PlaySoundFromEntity(snd_lxsiren[veh], "RESIDENT_VEHICLES_SIREN_QUICK_02", veh, 0, 0, 0)
					TogMuteDfltSrnForVeh(veh, true)
				elseif usePrkRngrSiren(veh) then
					snd_lxsiren[veh] = GetSoundId()
					PlaySoundFromEntity(snd_lxsiren[veh], "RESIDENT_VEHICLES_SIREN_QUICK_04", veh, 0, 0, 0)
					TogMuteDfltSrnForVeh(veh, true)
				else
					snd_lxsiren[veh] = GetSoundId()
					PlaySoundFromEntity(snd_lxsiren[veh], "VEHICLES_HORNS_SIREN_2", veh, 0, 0, 0)
					TogMuteDfltSrnForVeh(veh, true)
				end
			elseif newstate == 3 then
				snd_lxsiren[veh] = GetSoundId()
				if useFiretruckSiren(veh) then
					PlaySoundFromEntity(snd_lxsiren[veh], "VEHICLES_HORNS_AMBULANCE_WARNING", veh, 0, 0, 0)
				elseif useEMSSiren(veh) then
					PlaySoundFromEntity(snd_lxsiren[veh], "VEHICLES_HORNS_AMBULANCE_WARNING", veh, 0, 0, 0)
				else
					PlaySoundFromEntity(snd_lxsiren[veh], "VEHICLES_HORNS_POLICE_WARNING", veh, 0, 0, 0)
				end
				TogMuteDfltSrnForVeh(veh, true)
			else
				TogMuteDfltSrnForVeh(veh, true)
			end
			state_lxsiren[veh] = newstate
		end
	end
end

function TogPowercallStateForVeh(veh, newpstate)
	if DoesEntityExist(veh) and not IsEntityDead(veh) then
		if snd_pwrcall[veh] ~= nil then
			StopSound(snd_pwrcall[veh])
			ReleaseSoundId(snd_pwrcall[veh])
			snd_pwrcall[veh] = nil
		end
		if newpstate == 1 then -- Wail.
			if useFiretruckSiren(veh) then
				TogMuteDfltSrnForVeh(veh, false)
			else
				if useEMSSiren(veh)then
					snd_pwrcall[veh] = GetSoundId()
					PlaySoundFromEntity(snd_pwrcall[veh], "RESIDENT_VEHICLES_SIREN_WAIL_01", veh, 0, 0, 0)
					TogMuteDfltSrnForVeh(veh, true)
				elseif useBikeSiren(veh) then 
					snd_pwrcall[veh] = GetSoundId()
					PlaySoundFromEntity(snd_pwrcall[veh], "RESIDENT_VEHICLES_SIREN_WAIL_03", veh, 0, 0, 0)
					TogMuteDfltSrnForVeh(veh, true)
				elseif useFIBSiren(veh) then 
					snd_pwrcall[veh] = GetSoundId()
					PlaySoundFromEntity(snd_pwrcall[veh], "RESIDENT_VEHICLES_SIREN_WAIL_02", veh, 0, 0, 0)
					TogMuteDfltSrnForVeh(veh, true)
				elseif usePrkRngrSiren(veh) then 
					snd_pwrcall[veh] = GetSoundId()
					PlaySoundFromEntity(snd_pwrcall[veh], "RESIDENT_VEHICLES_SIREN_WAIL_04", veh, 0, 0, 0)
					TogMuteDfltSrnForVeh(veh, true)
				else
					snd_pwrcall[veh] = GetSoundId()	
					PlaySoundFromEntity(snd_pwrcall[veh], "VEHICLES_HORNS_SIREN_1", veh, 0, 0, 0)
					TogMuteDfltSrnForVeh(veh, true)
				end
			end
		elseif newpstate == 2 then -- Yelp.
			if useFiretruckSiren(veh) then
				--TogMuteDfltSrnForVeh(veh, false) -- RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01 ?.
				snd_pwrcall[veh] = GetSoundId()
				PlaySoundFromEntity(snd_pwrcall[veh], "RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01", veh, 0, 0, 0)
				TogMuteDfltSrnForVeh(veh, true)
			elseif useEMSSiren(veh) then
				snd_pwrcall[veh] = GetSoundId()
				PlaySoundFromEntity(snd_pwrcall[veh], "RESIDENT_VEHICLES_SIREN_QUICK_01", veh, 0, 0, 0)
				TogMuteDfltSrnForVeh(veh, true)
			elseif useBikeSiren(veh) then
				snd_pwrcall[veh] = GetSoundId()
				PlaySoundFromEntity(snd_pwrcall[veh], "RESIDENT_VEHICLES_SIREN_QUICK_03", veh, 0, 0, 0)
				TogMuteDfltSrnForVeh(veh, true)
			elseif useFIBSiren(veh) then
				snd_pwrcall[veh] = GetSoundId()
				PlaySoundFromEntity(snd_pwrcall[veh], "RESIDENT_VEHICLES_SIREN_QUICK_02", veh, 0, 0, 0)
				TogMuteDfltSrnForVeh(veh, true)
			elseif usePrkRngrSiren(veh) then
				snd_pwrcall[veh] = GetSoundId()
				PlaySoundFromEntity(snd_pwrcall[veh], "RESIDENT_VEHICLES_SIREN_QUICK_04", veh, 0, 0, 0)
				TogMuteDfltSrnForVeh(veh, true)
			else
				snd_pwrcall[veh] = GetSoundId()
				PlaySoundFromEntity(snd_pwrcall[veh], "VEHICLES_HORNS_SIREN_2", veh, 0, 0, 0)
				TogMuteDfltSrnForVeh(veh, true)
			end
		elseif newpstate == 3 then -- Phazer.
			snd_pwrcall[veh] = GetSoundId()
			if useFiretruckSiren(veh) then
				PlaySoundFromEntity(snd_pwrcall[veh], "VEHICLES_HORNS_AMBULANCE_WARNING", veh, 0, 0, 0)
			elseif useEMSSiren(veh) then
				PlaySoundFromEntity(snd_pwrcall[veh], "VEHICLES_HORNS_AMBULANCE_WARNING", veh, 0, 0, 0)
			else
				PlaySoundFromEntity(snd_pwrcall[veh], "VEHICLES_HORNS_POLICE_WARNING", veh, 0, 0, 0)
			end
		end
		state_pwrcall[veh] = newpstate
	end
end
function SetAirManuStateForVeh(veh, newstate)
	if DoesEntityExist(veh) and not IsEntityDead(veh) then
		if newstate ~= state_airmanu[veh] then
			if snd_airmanu[veh] ~= nil then
				StopSound(snd_airmanu[veh])
				ReleaseSoundId(snd_airmanu[veh])
				snd_airmanu[veh] = nil
			end
			if newstate == 1 then
				snd_airmanu[veh] = GetSoundId()
				if useFiretruckSiren(veh) then
					PlaySoundFromEntity(snd_airmanu[veh], "VEHICLES_HORNS_FIRETRUCK_WARNING", veh, 0, 0, 0)
				else
					PlaySoundFromEntity(snd_airmanu[veh], "SIRENS_AIRHORN", veh, 0, 0, 0)
				end
			elseif newstate == 2 then
				if useFiretruckSiren(veh) then
					snd_airmanu[veh] = GetSoundId()
					PlaySoundFromEntity(snd_airmanu[veh], "RESIDENT_VEHICLES_SIREN_FIRETRUCK_WAIL_01", veh, 0, 0, 0)
				elseif useEMSSiren(veh) then
					snd_airmanu[veh] = GetSoundId()
					PlaySoundFromEntity(snd_airmanu[veh], "RESIDENT_VEHICLES_SIREN_WAIL_01", veh, 0, 0, 0)
				elseif useBikeSiren(veh) then
					snd_airmanu[veh] = GetSoundId()
					PlaySoundFromEntity(snd_airmanu[veh], "RESIDENT_VEHICLES_SIREN_WAIL_03", veh, 0, 0, 0)
				elseif useFIBSiren(veh) then
					snd_airmanu[veh] = GetSoundId()
					PlaySoundFromEntity(snd_airmanu[veh], "RESIDENT_VEHICLES_SIREN_WAIL_02", veh, 0, 0, 0)
				elseif usePrkRngrSiren(veh) then
					snd_airmanu[veh] = GetSoundId()
					PlaySoundFromEntity(snd_airmanu[veh], "RESIDENT_VEHICLES_SIREN_WAIL_04", veh, 0, 0, 0)
				else
					snd_airmanu[veh] = GetSoundId()
					PlaySoundFromEntity(snd_airmanu[veh], "VEHICLES_HORNS_SIREN_1", veh, 0, 0, 0)
				end
			elseif newstate == 3 then
				if useFiretruckSiren(veh) then
					snd_airmanu[veh] = GetSoundId()
					PlaySoundFromEntity(snd_airmanu[veh], "RESIDENT_VEHICLES_SIREN_FIRETRUCK_QUICK_01", veh, 0, 0, 0)
				elseif useEMSSiren(veh) then
					snd_airmanu[veh] = GetSoundId()
					PlaySoundFromEntity(snd_airmanu[veh], "RESIDENT_VEHICLES_SIREN_QUICK_01", veh, 0, 0, 0)
				elseif useBikeSiren(veh) then
					snd_airmanu[veh] = GetSoundId()
					PlaySoundFromEntity(snd_airmanu[veh], "RESIDENT_VEHICLES_SIREN_QUICK_03", veh, 0, 0, 0)
				elseif useFIBSiren(veh) then
					snd_airmanu[veh] = GetSoundId()
					PlaySoundFromEntity(snd_airmanu[veh], "RESIDENT_VEHICLES_SIREN_QUICK_02", veh, 0, 0, 0)
				elseif usePrkRngrSiren(veh) then
					snd_airmanu[veh] = GetSoundId()
					PlaySoundFromEntity(snd_airmanu[veh], "RESIDENT_VEHICLES_SIREN_QUICK_04", veh, 0, 0, 0)
				else
					snd_airmanu[veh] = GetSoundId()
					PlaySoundFromEntity(snd_airmanu[veh], "VEHICLES_HORNS_SIREN_2", veh, 0, 0, 0)
				end
			end
			state_airmanu[veh] = newstate
		end
	end
end

RegisterNetEvent("lvc_TogIndicState_c")
AddEventHandler("lvc_TogIndicState_c", function(sender, newstate)
	local player_s = GetPlayerFromServerId(sender)
	local ped_s = GetPlayerPed(player_s)
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= PlayerPedId() then
			if IsPedInAnyVehicle(ped_s, false) then
				local veh = GetVehiclePedIsUsing(ped_s)
				TogIndicStateForVeh(veh, newstate)
			end
		end
	end
end)

RegisterNetEvent("lvc_TogDfltSrnMuted_c")
AddEventHandler("lvc_TogDfltSrnMuted_c", function(sender, toggle)
	local player_s = GetPlayerFromServerId(sender)
	local ped_s = GetPlayerPed(player_s)
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= PlayerPedId() then
			if IsPedInAnyVehicle(ped_s, false) then
				local veh = GetVehiclePedIsUsing(ped_s)
				TogMuteDfltSrnForVeh(veh, toggle)
			end
		end
	end
end)

RegisterNetEvent("lvc_SetLxSirenState_c")
AddEventHandler("lvc_SetLxSirenState_c", function(sender, newstate)
	local player_s = GetPlayerFromServerId(sender)
	local ped_s = GetPlayerPed(player_s)
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= PlayerPedId() then
			if IsPedInAnyVehicle(ped_s, false) then
				local veh = GetVehiclePedIsUsing(ped_s)
				SetLxSirenStateForVeh(veh, newstate)
			end
		end
	end
end)

RegisterNetEvent("lvc_TogPwrcallState_c")
AddEventHandler("lvc_TogPwrcallState_c", function(sender, toggle)
	local player_s = GetPlayerFromServerId(sender)
	local ped_s = GetPlayerPed(player_s)
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= PlayerPedId() then
			if IsPedInAnyVehicle(ped_s, false) then
				local veh = GetVehiclePedIsUsing(ped_s)
				TogPowercallStateForVeh(veh, toggle)
			end
		end
	end
end)

RegisterNetEvent("lvc_SetAirManuState_c")
AddEventHandler("lvc_SetAirManuState_c", function(sender, newstate)
	local player_s = GetPlayerFromServerId(sender)
	local ped_s = GetPlayerPed(player_s)
	if DoesEntityExist(ped_s) and not IsEntityDead(ped_s) then
		if ped_s ~= PlayerPedId() then
			if IsPedInAnyVehicle(ped_s, false) then
				local veh = GetVehiclePedIsUsing(ped_s)
				SetAirManuStateForVeh(veh, newstate)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = 500
		CleanupSounds()
		-- Is in vehicle.
		local playerped = PlayerPedId()
		if IsPedInAnyVehicle(playerped, false) then
			wait = 0
			-- Is the driver.
			local veh = GetVehiclePedIsUsing(playerped)	
			if GetIsTaskActive(playerped,2) then
				angle = GetVehicleSteeringAngle(veh)
				Citizen.Wait(10)
				SetVehicleSteeringAngle(veh, angle)
			end
			if GetPedInVehicleSeat(veh, -1) == playerped then
				if state_indic[veh] ~= ind_state_o and state_indic[veh] ~= ind_state_l and state_indic[veh] ~= ind_state_r and state_indic[veh] ~= ind_state_h then
					state_indic[veh] = ind_state_o
					leftturn = false
					rightturn = false
					hazard = false
				end
				-- Indic audio control.
				if actv_ind_timer == true then	
					if state_indic[veh] == ind_state_l or state_indic[veh] == ind_state_r then
						if GetEntitySpeed(veh) < 6 then
							count_ind_timer = 0
						else
							if count_ind_timer > delay_ind_timer then
								count_ind_timer = 0
								actv_ind_timer = false
								state_indic[veh] = ind_state_o
								PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
								TogIndicStateForVeh(veh, state_indic[veh])
								leftturn = false
								rightturn = false
								hazard = false
								count_bcast_timer = delay_bcast_timer
							else
								count_ind_timer = count_ind_timer + 1
							end
						end
					end
				end
				-- Is an emergency vehicle.
				if GetVehicleClass(veh) == 18 then
					if state_pwrcall[veh] == nil then
						state_pwrcall[veh] = 0
					end
					if state_lxsiren[veh] == nil then
						state_lxsiren[veh] = 0
					end
					local actv_manu = false
					local actv_horn = false
					DisableControlAction(0, 86, true) -- INPUT_VEH_HORN.
					DisableControlAction(0, 80, true) -- INPUT_VEH_CIN_CAM.
					SetVehRadioStation(veh, "OFF")
					SetVehicleRadioEnabled(veh, false)
					if state_lxsiren[veh] <= 0 and state_lxsiren[veh] >= 4 then
						state_lxsiren[veh] = 0
					end
					if state_pwrcall[veh] <= 0 and state_pwrcall[veh] >= 4 then
						state_pwrcall[veh] = 0
					end
					if state_airmanu[veh] ~= 1 and state_airmanu[veh] ~= 2 and state_airmanu[veh] ~= 3 then
						state_airmanu[veh] = 0
					end
					if useFiretruckSiren(veh) and state_lxsiren[veh] == 1 then
						TogMuteDfltSrnForVeh(veh, false)
						dsrn_mute = false
					else
						TogMuteDfltSrnForVeh(veh, true)
						dsrn_mute = true
					end
					if not IsVehicleSirenOn(veh) and state_lxsiren[veh] > 0 then
						PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
						SetLxSirenStateForVeh(veh, 0)
						count_bcast_timer = delay_bcast_timer
					end
					if not IsVehicleSirenOn(veh) and state_pwrcall[veh] > 0 then
						PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
						TogPowercallStateForVeh(veh, 0)
						count_bcast_timer = delay_bcast_timer
					end
					-- Controls.
					-- HORN FLASH
					-- if (IsControlPressed(1, 21) and IsDisabledControlPressed(1, 86)) then
					-- 	actv_horn = true
					-- 	SetVehicleLights(veh, 2)
					-- 	SetVehicleLightMultiplier(veh, lightMultiplier)
					-- else
					-- 	actv_horn = false
					-- 	if tdown == false then
					-- 		SetVehicleLights(veh, 0)
					-- 		SetVehicleLightMultiplier(veh, 1.0)
					-- 	end
					-- end
					-- HORN
				end
			end
			-- If sirens are on when exiting.
			if IsVehicleSirenOn(veh) then
				if GetPedInVehicleSeat(veh, -1) == playerped then
					if GetIsTaskActive(playerped, 2) or GetIsTaskActive(playerped, 167) then
						SetLxSirenStateForVeh(veh, 0)
						TogPowercallStateForVeh(veh, 0)
						SetAirManuStateForVeh(veh, 0)
						TriggerServerEvent("lvc_TogDfltSrnMuted_s", dsrn_mute)
						TriggerServerEvent("lvc_SetLxSirenState_s", state_lxsiren[veh])
						TriggerServerEvent("lvc_TogPwrcallState_s", state_pwrcall[veh])
						TriggerServerEvent("lvc_SetAirManuState_s", state_airmanu[veh])
					end
				end
			end
			-- local mph = GetEntitySpeed(veh)*2.23694
			-- if takedown and mph > takedownspeed then
			-- 	PlaySoundFrontend(-1,"Highlight_Cancel", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1) -- off
			-- 	SetVehicleLights(veh, 0)
			-- 	SetVehicleLightMultiplier(veh, 1.0)
			-- 	takedown = false
			-- end
			-- Is any land vehicle.
			if GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 21 then
				-- Auto broadcast vehicle states.
				if count_bcast_timer > delay_bcast_timer then
					count_bcast_timer = 0
					-- Is an emergency vehicle.
					if GetVehicleClass(veh) == 18 then
						TriggerServerEvent("lvc_TogDfltSrnMuted_s", dsrn_mute)
						TriggerServerEvent("lvc_SetLxSirenState_s", state_lxsiren[veh])
						TriggerServerEvent("lvc_TogPwrcallState_s", state_pwrcall[veh])
						TriggerServerEvent("lvc_SetAirManuState_s", state_airmanu[veh])
					end
					-- Is any other vehicle.
					TriggerServerEvent("lvc_TogIndicState_s", state_indic[veh])
				else
					count_bcast_timer = count_bcast_timer + 1
				end
			end
		end
		Citizen.Wait(wait)
	end
end)
-- Toggle Code 2.
RegisterCommand( "-lightbar", function()
	if not IsPauseMenuActive() then
		local playerped = PlayerPedId()
		local veh = GetVehiclePedIsUsing(playerped)
		if IsPedInAnyVehicle(playerped, false) then
			if GetPedInVehicleSeat(veh, -1) == playerped then
				if GetVehicleClass(veh) == 18 then
					if IsVehicleSirenOn(veh) then
						PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
						SetVehicleSiren(veh, false)
					else
						PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
						SetVehicleSiren(veh, true)
						count_bcast_timer = delay_bcast_timer
					end
				end
			end
		end
	end
end, true)
-- Primary Siren.
RegisterCommand( "-siren", function()
	if not IsPauseMenuActive() then
		local playerped = PlayerPedId()
		local veh = GetVehiclePedIsUsing(playerped)
		if IsPedInAnyVehicle(playerped, false) then
			if GetPedInVehicleSeat(veh, -1) == playerped then
				if GetVehicleClass(veh) == 18 then
					local cstate = state_lxsiren[veh]
					if cstate == 0 then
						if IsVehicleSirenOn(veh) then
							PlaySoundFrontend(-1,"5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 1) -- on
							SetLxSirenStateForVeh(veh, 1)
							count_bcast_timer = delay_bcast_timer
						end
					else
						PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) -- off
						SetLxSirenStateForVeh(veh, 0)
						count_bcast_timer = delay_bcast_timer
					end
				end
			end
		end
	end
end, true)
-- Cycle Primary Siren.
RegisterCommand( "-csiren", function()
	if not IsPauseMenuActive() then	
		local playerped = PlayerPedId()
		local veh = GetVehiclePedIsUsing(playerped)
		if IsPedInAnyVehicle(playerped, false) then
			if GetPedInVehicleSeat(veh, -1) == playerped then
				if GetVehicleClass(veh) == 18 then
					if state_lxsiren[veh] > 0 then
						if IsVehicleSirenOn(veh) then
							local cstate = state_lxsiren[veh]
							local nstate = 1
							PlaySoundFrontend(-1, "MP_5_SECOND_TIMER", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1) -- on
							if cstate == 1 then
								nstate = 2
							elseif cstate == 2 then
								nstate = 3
							else	
								nstate = 1
							end
							SetLxSirenStateForVeh(veh, nstate)
							count_bcast_timer = delay_bcast_timer
						end
					end
				end
			end
		end
	end
end, true)
-- Secondary Siren.
RegisterCommand( "-2siren", function()
	if not IsPauseMenuActive() then
		local playerped = PlayerPedId()
		local veh = GetVehiclePedIsUsing(playerped)
		if IsPedInAnyVehicle(playerped, false) then
			if GetPedInVehicleSeat(veh, -1) == playerped then
				if GetVehicleClass(veh) == 18 then
					local cstate = state_pwrcall[veh]
					if cstate == 0 then
						if IsVehicleSirenOn(veh) then
							PlaySoundFrontend(-1,"5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 1) -- on
							TogPowercallStateForVeh(veh, 1)
							count_bcast_timer = delay_bcast_timer
						end
					else
						PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1) -- off
						TogPowercallStateForVeh(veh, 0)
						count_bcast_timer = delay_bcast_timer
					end
				end
			end
		end
	end
end, true)
-- Cycle Secondary Siren.
RegisterCommand( "-c2siren", function()
	if not IsPauseMenuActive() then	
		local playerped = PlayerPedId()
		local veh = GetVehiclePedIsUsing(playerped)
		if IsPedInAnyVehicle(playerped, false) then
			if GetPedInVehicleSeat(veh, -1) == playerped then
				if GetVehicleClass(veh) == 18 then
					if state_pwrcall[veh] > 0 then
						if IsVehicleSirenOn(veh) then
							local cstate = state_pwrcall[veh]
							local nstate = 1
							PlaySoundFrontend(-1, "MP_5_SECOND_TIMER", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1) -- on
							if cstate == 1 then
								nstate = 2
							elseif cstate == 2 then
								nstate = 3
							else	
								nstate = 1
							end
							TogPowercallStateForVeh(veh, nstate)
							count_bcast_timer = delay_bcast_timer
						end
					end
				end
			end
		end
	end
end, true)
--Manual Tone.
Ismanual = false
modifier = false
takedown = false
leftturn = false
rightturn = false
hazard = false
Citizen.CreateThread(function()
	while true do
		local playerped = PlayerPedId()
		local veh = GetVehiclePedIsUsing(playerped)
		if IsPedInAnyVehicle(playerped, false) then
			if GetPedInVehicleSeat(veh, -1) == playerped then
				if GetVehicleClass(veh) == 18 then
					local retval, lightsOn, highbeamsOn = GetVehicleLightsState(veh)
					if takedown and IsControlJustPressed(0, 74) and highbeamsOn == 1 then
						takedown = false
						SetVehicleLights(veh, 0)
						SetVehicleLightMultiplier(veh, 1.0)
					end
					local hmanu_state_new = 0
					if IsDisabledControlPressed(1, 86) then
						actv_horn = true
					else
						actv_horn = false
					end
					local hmanu_state_new = 0
					if actv_horn == true and actv_manu == false then
						hmanu_state_new = 1
					elseif actv_horn == false and actv_manu == true then
						hmanu_state_new = 2
					elseif actv_horn == true and actv_manu == true then
						hmanu_state_new = 3
					end
					if hmanu_state_new == 1 then
						if not useFiretruckSiren(veh) then
							if (state_lxsiren[veh] or 0) > 0 and not IsVehicleSirenOn(veh) and actv_lxsrnmute_temp == false then
								srntone_temp = state_lxsiren[veh]
								SetLxSirenStateForVeh(veh, 0)
								actv_lxsrnmute_temp = true
							end
						else
							if not useFiretruckSiren(veh) then
								if actv_lxsrnmute_temp == true then
									SetLxSirenStateForVeh(veh, srntone_temp)
									actv_lxsrnmute_temp = false
								end
							end
						end
					end
					if state_airmanu[veh] ~= hmanu_state_new then
						SetAirManuStateForVeh(veh, hmanu_state_new)
						count_bcast_timer = delay_bcast_timer
					end
					if Ismanual then
						if state_lxsiren[veh] < 1 then
							if not IsPauseMenuActive() then
								actv_manu = true
							end
						end
					else
						actv_manu = false
					end
				end
			end
		end
		Citizen.Wait(10)
	end
end)
RegisterCommand("+manualtone", function()
	Ismanual = true
end, true)
RegisterCommand("-manualtone", function()
	Ismanual = false
end, true)
RegisterCommand("-leftturn", function()
	local playerped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(playerped)
	if IsPedInAnyVehicle(playerped, false) then
		if GetPedInVehicleSeat(veh, -1) == playerped then
			if GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 21 then
				if not IsPauseMenuActive() then
					local cstate = state_indic[veh]
					if leftturn then
						state_indic[veh] = ind_state_o
						actv_ind_timer = false
						PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
						leftturn = false
					else
						leftturn = true
						if rightturn then
							rightturn = false
						elseif hazard then
							hazard = false
						end
						state_indic[veh] = ind_state_l
						actv_ind_timer = true
						PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
					end
				end
			end
		end
	end
	TogIndicStateForVeh(veh, state_indic[veh])
	count_ind_timer = 0
	count_bcast_timer = delay_bcast_timer
end, true)
RegisterCommand("-rightturn", function()
	local playerped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(playerped)
	if IsPedInAnyVehicle(playerped, false) then
		if GetPedInVehicleSeat(veh, -1) == playerped then
			if GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 21 then
				if not IsPauseMenuActive() then
					local cstate = state_indic[veh]
					if rightturn then
						state_indic[veh] = ind_state_o
						actv_ind_timer = false
						PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
						rightturn = false
					else
						rightturn = true
						if leftturn then
							leftturn = false
						elseif hazard then
							hazard = false
						end
						state_indic[veh] = ind_state_r
						actv_ind_timer = true
						PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
					end
				end
			end
		end
	end
	TogIndicStateForVeh(veh, state_indic[veh])
	count_ind_timer = 0
	count_bcast_timer = delay_bcast_timer
end, true)
RegisterCommand("-hazard", function()
	local playerped = PlayerPedId()
	local veh = GetVehiclePedIsUsing(playerped)
	if IsPedInAnyVehicle(playerped, false) then
		if GetPedInVehicleSeat(veh, -1) == playerped then
			if GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 21 then
				if not IsPauseMenuActive() then
					local cstate = state_indic[veh]
					if hazard then
						state_indic[veh] = ind_state_o
						actv_ind_timer = false
						PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
						hazard = false
					else
						hazard = true
						if leftturn then
							leftturn = false
						elseif rightturn then
							rightturn = false
						end
						state_indic[veh] = ind_state_h
						actv_ind_timer = true
						PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
					end
				end
			end
		end
	end
	TogIndicStateForVeh(veh, state_indic[veh])
	count_ind_timer = 0
	count_bcast_timer = delay_bcast_timer
end, true)
RegisterCommand("-takedown", function()
	if not IsPauseMenuActive() then	
		local playerped = PlayerPedId()
		local veh = GetVehiclePedIsUsing(playerped)
		if IsPedInAnyVehicle(playerped, false) then
			if GetPedInVehicleSeat(veh, -1) == playerped then
				if GetVehicleClass(veh) == 18 then
					local retval, lightsOn, highbeamsOn = GetVehicleLightsState(veh)
					if takedown then
						takedown = false
						PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
						SetVehicleLights(veh, 0)
						SetVehicleLightMultiplier(veh, 1.0)
					elseif not takedown and (highbeamsOn == 1 or lightsOn == 1) then
						takedown = true
						PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
						SetVehicleLights(veh, 2)
						SetVehicleLightMultiplier(veh, lightMultiplier)
					end
				end
			end
		end
	end
end, true)