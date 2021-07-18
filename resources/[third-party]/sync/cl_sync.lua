WeatherOverride = nil
LastWeather = CurrentWeather
ServerTime = 0
SyncTime = 0
BlackoutTime = 0
Blackout = false

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local weather = WeatherOverride or CurrentWeather
		if LastWeather ~= weather then
			if weather == "XMAS" or LastWeather == "XMAS" then
				DoScreenFadeOut(250)
				Citizen.Wait(250)
				
				SetWeatherTypeNow(weather)
				DoScreenFadeIn(250)
			else
				SetWeatherTypeOverTime(weather, Config.TransitionTime)
				
				Citizen.Wait(math.floor(1000 * Config.TransitionTime))
			end
			LastWeather = weather
		end
		ClearOverrideWeather()
		ClearWeatherTypePersist()
		SetWeatherTypePersist(LastWeather)
		SetWeatherTypeNow(LastWeather)
		SetWeatherTypeNowPersist(LastWeather)
		if LastWeather == "XMAS" then
			SetForceVehicleTrails(true)
			SetForcePedFootstepsTracks(true)
		else
			SetForceVehicleTrails(false)
			SetForcePedFootstepsTracks(false)
		end
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	local serverTime = 0
	local year = 0
	local month = 0
	local day = 0
	local hour = 0
	local minute = 0

	while true do
		Citizen.Wait(0)

		local day, month, year, hour, minute, second = GetTimes()
		
		NetworkOverrideClockTime(hour, minute, 0)
		SetClockDate(day, month, year)

		-- print(day, month, year, hour, minute, second, "("..serverTime..")")

		if BlackoutTime > 0 then
			local time = GetGameTimer() - BlackoutTime

			local flickerTime = 4000.0
			local thunderTime = 15000.0

			local lightState = false
			if time > thunderTime and time < thunderTime + flickerTime then
				local x = math.cos((math.pi * (time - thunderTime) / 7.0)^0.5)
				lightState = x > 0.0
			elseif time > thunderTime + flickerTime then
				lightState = true
			end

			SetArtificialLightsState(lightState)
		end

		local shouldBlackout = GlobalState.powerDisabled
		if Blackout ~= shouldBlackout then
			Blackout = shouldBlackout
			SetArtificialLightsState(shouldBlackout)
		end
	end
end)

--[[ Functions ]]--
function GetTime()
	return GetServerTime() / 1000.0 * Config.TimeScale
end

function GetServerTime()
	return GetGameTimer() - SyncTime + ServerTime
end

function OverrideWeather(weather)
	WeatherOverride = weather
end
exports("OverrideWeather", OverrideWeather)

--[[ Events ]]--
RegisterNetEvent("sync:update")
AddEventHandler("sync:update", function(time, weather)
	SyncTime = GetGameTimer()
	ServerTime = time * 1000
	CurrentWeather = weather
end)

AddEventHandler("sync:clientStart", function()
	TriggerServerEvent("sync:requestSync")
	SetArtificialLightsState(false)
	SetArtificialLightsStateAffectsVehicles(false)
end)

RegisterNetEvent("schedule:warn")
AddEventHandler("schedule:warn", function()
	BlackoutTime = GetGameTimer()
end)