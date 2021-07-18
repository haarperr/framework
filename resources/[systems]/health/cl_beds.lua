CurrentBed = nil
LeavingBed = false

--[[ Functions ]]--
function FindBed(distance, zone)
	local objects = exports.oldutils:GetObjects()
	local peds = exports.oldutils:GetPeds()

	local pedCoords = GetEntityCoords(PlayerPedId())
	for _, object in ipairs(objects) do
		local bed = Config.Beds.Models[GetEntityModel(object)]
		if bed then
			local coords = GetEntityCoords(object)
			if distance == nil or #(coords - pedCoords) < distance then
				local inZone = false
				for _, zone in ipairs(Config.Beds.Zones) do
					if #(zone.Center - coords) < zone.Radius then
						inZone = true
						break
					end
				end
				if inZone then
					local isOccupied = false
					for __, ped in ipairs(peds) do
						if #(GetEntityCoords(ped) - coords) < 3.0 then
							isOccupied = true
							break
						end
					end
					if not isOccupied then
						return object
					end
				end
			end
		end
	end
end

function EnterBed(object, time)
	LeavingBed = false
	CurrentBed = object
	
	local bed = Config.Beds.Models[GetEntityModel(CurrentBed)]
	local coords = GetEntityCoords(CurrentBed) + (bed.Offset or vector3(0.0, 0.0, 0.0))
	local rot = GetEntityRotation(CurrentBed)
	local ped = PlayerPedId()
	
	FreezeEntityPosition(ped, true)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z + 0.4)
	SetEntityRotation(ped, rot.x, rot.y, rot.z + 180.0)

	exports.emotes:PerformEmote({
		Dict = "missheist_agency3amcs_4b",
		Name = "lying_idle_crew2",
		Flag = 1,
		IgnoreCancel = true,
	}, function()
		if LeavingBed then return end

		CurrentBed = nil
		FreezeEntityPosition(ped, false)
	end)

	if time then
		Citizen.CreateThread(function()
			local startTime = GetGameTimer()
			while GetGameTimer() - startTime < time * 1000 do
				if not CurrentBed then return end
				Citizen.Wait(1000)
			end
			LeaveBed(true)
		end)
	end
end

function LeaveBed(heal)
	local bed = Config.Beds.Models[GetEntityModel(CurrentBed)]
	local coords = GetEntityCoords(CurrentBed) + (bed.Offset or vector3(0.0, 0.0, 0.0))
	local rot = GetEntityRotation(CurrentBed)
	local ped = PlayerPedId()

	if heal then
		if IsDead then
			ResurrectPed()
		else
			HealPed()
		end
	end
	
	LeavingBed = true
	
	FreezeEntityPosition(ped, false)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z - 0.3)
	SetEntityRotation(ped, rot.x, rot.y, rot.z - 90.0)

	local startTime = GetGameTimer()
	
	exports.emotes:PerformEmote({
		Dict = "switch@franklin@bed",
		Name = "sleep_getup_rubeyes",
		Flag = 0,
		IgnoreCancel = true,
	}, function()
		CurrentBed = nil
		FreezeEntityPosition(ped, false)
		LeavingBed = false
	end, ped, true)
end

--[[ Events ]]--
RegisterNetEvent("health:checkIn")
AddEventHandler("health:checkIn", function()
	local object = FindBed()
	if object then
		exports.interaction:StopBeingEscorted()
		EnterBed(object, Config.Beds.Duration)
	end
end)

AddEventHandler("health:clientStart", function()
	for k, zone in ipairs(Config.Beds.Zones) do
		local callbackId = "HealthCheckIn-"..tostring(k)
		if not zone.Coords then return end
		exports.markers:CreateUsable(GetCurrentResourceName(), zone.Coords, callbackId, "Check In", Config.Markers.DrawRadius, Config.Markers.Radius, Config.Markers.Blip)

		AddEventHandler("markers:use_"..callbackId, function()
			local escorting = exports.interaction:GetEscorting()
			local anim = {}
			local duration = Config.Beds.CheckInDuration * 1000
			-- escorting = GetPlayerServerId(PlayerId()) -- Debug self.

			local currentJob = exports.jobs:GetCurrentJob()

			print(escorting, ((currentJob or {}).Emergency or {}).CheckIn)
			if escorting and ((currentJob or {}).Emergency or {}).CheckIn then
				anim = Config.Medical.Action.Anim
				duration = 4000
			else
				escorting = nil
				anim = {
					Dict = "missheistdockssetup1clipboard@base",
					Name = "base",
					Flag = 1,
					Props = {
						{ Model = "p_amb_clipboard_01", Bone = 18905, Offset = { 0.10, 0.02, 0.08, -80.0, 0.0, 0.0 } },
						{ Model = "prop_pencil_01", Bone = 58866, Offset = { 0.12, 0.0, 0.001, -150.0, 0.0, 0.0 } },
					}
				}
			end

			exports.mythic_progbar:Progress({
				Anim = anim,
				Label = "Checking In...",
				Duration = duration,
				UseWhileDead = true,
				DisableMovement = true,
				CanCancel = true,
				Disarm = true,
			}, function(wasCancelled)
				if not wasCancelled then
					if escorting then
						-- Check that they're still escorting.
						escorting = exports.interaction:GetEscorting()
						-- escorting = GetPlayerServerId(PlayerId()) -- Debug self.
						if escorting then
							TriggerServerEvent("health:checkIn", escorting)
						end
					else
						local object = FindBed()
						if object then
							EnterBed(object, Config.Beds.Duration)
							TriggerServerEvent("health:checkIn", false, GetDamageValue())
						else
							exports.mythic_notify:SendAlert("error", "No beds available...", 7000)
						end
					end
				end
			end)
		end)
	end
end)

--[[ Commands ]]--
RegisterCommand("bed", function(source, args, command)
	if CurrentBed then
		LeaveBed()
	else
		local object = FindBed(2.0)
		if object then
			EnterBed(object)
		end
	end
end)