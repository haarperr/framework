_Cache = {
	BreakOut = false,
	CanBreakOut = false,
	EndTime = 0,
	Initialized = false,
	Reported = false,
	StartTime = 0,
}

--[[ Threads ]]--
Citizen.CreateThread(function()
	RegisterAlarms()
end)

Citizen.CreateThread(function()
	while true do
		if _Cache.Jailed then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local bounds = Config.Bounds[_Cache.Jailed.type]
			local shouldBreakout = false
			if _Cache.BreakOut then
				shouldBreakout = GetGameTimer() - _Cache.BreakOut > Config.Breakout.Time * 60000
			end
			if #(coords - bounds.Center) > bounds.Radius then
				if GetTimeLeft() <= 0 then
					TriggerServerEvent("jail:leave")
					TriggerEvent("jail:leave", true)
				elseif shouldBreakout then
					TriggerEvent("chat:notify", Config.Breakout.Success, "success")
					TriggerServerEvent("jail:leave", true)
					TriggerEvent("jail:leave", true, true)
				elseif not _Cache.BreakOut then
					_Cache.BreakOut = GetGameTimer()
				elseif _Cache.BreakOut and _Cache.CanBreakOut and not _Cache.Reported and (GetGameTimer() - _Cache.BreakOut) > 5000 then
					TriggerServerEvent("jail:breakout")
					_Cache.Reported = true
				end
			elseif shouldBreakout then
				TriggerEvent("chat:notify", Config.Breakout.Failed, "error")
				_Cache.BreakOut = false
			else
				_Cache.CanBreakOut = true
			end

			Citizen.Wait(1000)
		else
			Citizen.Wait(5000)
		end
	end
end)

--[[ Functions ]]--
function RegisterAlarms()
	for k, alarm in ipairs(Config.Alarms) do
		local id = ("alarm-%s"):format(k)
		
		exports.interact:Register({
			id = id,
			embedded = {
				{
					id = "prison-alarm",
					text = "Toggle Alarm",
				},
			},
			coords = alarm.Coords,
			radius = alarm.Radius,
		})
	end
end

function GetTimeLeft()
	return math.ceil((_Cache.EndTime - GetGameTimer()) / 60000)
end

function IsJailed()
	while not _Cache.Initialized do
		Citizen.Wait(20)
	end

	return _Cache.Jailed ~= nil
end
exports("IsJailed", IsJailed)

function Spawn()
	local spawn = Config.Spawn.Coords[_Cache.Jailed.type]
	if type(spawn) == "table" then
		spawn = spawn[GetRandomIntInRange(1, #spawn + 1)]
	end
	exports.teleporters:TeleportTo(spawn)
end
exports("Spawn", Spawn)

--[[ Events ]]--
RegisterNetEvent("jail:setalarm")
AddEventHandler("jail:setalarm", function(AlarmTriggered)
	local alarmIpl = GetInteriorAtCoordsWithType(1787.004,2593.1984,45.7978,"int_prison_main")

	RefreshInterior(alarmIpl)
	if AlarmTriggered then
		EnableInteriorProp(alarmIpl, "prison_alarm")

		Citizen.CreateThread(function()
			while not PrepareAlarm("PRISON_ALARMS") do
				Citizen.Wait(100)
			end
			StartAlarm("PRISON_ALARMS", true)
		end)
	else
		DisableInteriorProp(alarmIpl, "prison_alarm")

		Citizen.CreateThread(function()
			while not PrepareAlarm("PRISON_ALARMS") do
				Citizen.Wait(100)
			end
			StopAllAlarms(true)
		end)
	end
end)

RegisterNetEvent("jail:breakout")
AddEventHandler("jail:breakout", function(presence)
	local success = presence >= Config.Breakout.MinPresence
	if not success then
		TriggerEvent("chat:notify", Config.Breakout.Cannot:format(presence, Config.Breakout.MinPresence), "inform")
		Spawn()
		
		Citizen.Wait(1000)

		_Cache.BreakOut = false
		_Cache.CanBreakOut = true
		_Cache.Reported = false

		return
	end

	TriggerEvent("chat:notify", Config.Breakout.Message:format(Config.Breakout.Time), "inform")
end)

RegisterNetEvent("jail:jailed")
AddEventHandler("jail:jailed", function(info, timeServed, skipSpawn)
	_Cache.Initialized = true
	
	if not info then
		return
	end
	
	_Cache.Jailed = info
	_Cache.StartTime = GetGameTimer()
	_Cache.EndTime = _Cache.StartTime + (info.end_time - info.start_time) - (timeServed or 0)
	_Cache.BreakOut = false
	_Cache.Reported = false
	_Cache.CanBreakOut = false

	if not skipSpawn then
		Spawn()
		TriggerEvent("chat:notify", Config.Spawn.Message:format(math.ceil((_Cache.EndTime - _Cache.StartTime) / 60000)), "inform")
	end
end)

RegisterNetEvent("jail:leave")
AddEventHandler("jail:leave", function(keepPosition, skipAlert)
	if not _Cache.Jailed then return end

	if not keepPosition then
		local exit = Config.Exit.Coords[_Cache.Jailed.type]

		exports.teleporters:TeleportTo(exit)
	end

	if not skipAlert then
		TriggerEvent("chat:notify", Config.Exit.Message, "inform")
	end

	_Cache.Jailed = nil
	_Cache.Breakout = false
	_Cache.Reported = false
end)

RegisterNetEvent("character:switch")
AddEventHandler("character:switch", function()
	_Cache.Initialized = false
	_Cache.Jailed = nil
end)

AddEventHandler("jail:clientStart", function()
	for _type, coords in pairs(Config.TimeLeft.Coords) do
		local callbackId = "jail-checkTime_".._type
		exports.markers:CreateUsable(GetCurrentResourceName(), coords, callbackId, Config.TimeLeft.Markers.Text, Config.TimeLeft.Markers.DrawRadius, Config.TimeLeft.Markers.Radius)
		AddEventHandler("markers:use_"..callbackId, function()
			if not _Cache.Jailed then return end
			
			local timeLeft = GetTimeLeft()

			if timeLeft > 0 then
				TriggerEvent("chat:notify", Config.TimeLeft.Message:format(timeLeft), duration, "inform")
			else
				TriggerEvent("jail:leave")
				TriggerServerEvent("jail:leave")
			end
		end)
	end
end)

AddEventHandler("jail:start", function()
	if GetResourceState("cache") == "started" then
		_Cache = exports.cache:Get("Jail") or _Cache
	end
end)

AddEventHandler("jail:stop", function()
	if GetResourceState("cache") == "started" then
		exports.cache:Set("Jail", _Cache)
	end
end)