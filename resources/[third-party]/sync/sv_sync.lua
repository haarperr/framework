DynamicWeather = true
TimeOffset = 0

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30000)
		Sync()
	end
end)

Citizen.CreateThread(function()
	while true do
		if DynamicWeather then
			local previousWeather = CurrentWeather
			NextWeatherStage()
			if previousWeather ~= CurrentWeather then
				print("[SYNC] Weather transitioning from "..previousWeather.." to "..CurrentWeather)
			end
		end
		Citizen.Wait(60000 * 15)
	end
end)

--[[ Events ]]--
RegisterServerEvent("sync:requestSync")
AddEventHandler("sync:requestSync", function()
	local source = source
	Sync(source, true, true)
end)

AddEventHandler("schedule:warn", function()
	SetWeather("THUNDER")
	Sync(-1, true, true)
end)

--[[ Functions ]]--
function GetTime()
	return os.time() * Config.TimeScale
end

function NextWeatherStage()
	local weatherSettings = Config.Weathers[CurrentWeather]
	if not weatherSettings.Next then
		return
	end

	local day, month, year, hour, minute, second = GetTimes()
	
	local nextWeather
	local totalProbability = 0.0
	for weather, chance in pairs(weatherSettings.Next) do
		totalProbability = totalProbability + chance
	end
	local random = math.random() * totalProbability
	for weather, chance in pairs(weatherSettings.Next) do
		if chance > random then
			nextWeather = weather
			break
		end
		random = random - chance
	end
	if nextWeather then
		-- print(nextWeather)
		SetWeather(nextWeather)
		return nextWeather
	end
end

function Sync(source, weather, time)
	if not source then source = -1 end
	-- TriggerClientEvent("sync:update", source, data)
	TriggerClientEvent("sync:update", source, os.time() + TimeOffset, CurrentWeather)
end

function SetWeather(weather)
	weather = weather:upper()
	if weather == CurrentWeather or not Config.Weathers[weather] then
		return false
	end
	CurrentWeather = weather
	Sync()
	return true
end

function SetTimeOfDay(hour, minute, second)
	local currentHour, currentMinute, currentSecond = GetHour(), GetMinute(), GetSecond()
	
	TimeOffset =
		(hour - currentHour) * (60.0 / Config.TimeScale) +
		(minute - currentMinute) * (1.0 / Config.TimeScale) +
		(second - currentSecond) * (0.016667 / Config.TimeScale)

	Sync()
end

function SendMessage(source, message)
	if source == 0 then
		print(message)
	else
		TriggerEvent("chat:addMessage", source, message)
	end
end

--[[ Commands ]]--
exports.chat:RegisterCommand("a:weather", function(source, args, rawCommand)
	local weather = args[1]:upper()
	if not weather then return end

	local message = ""
	local lastWeather = CurrentWeather
	if SetWeather(weather) then
		message = "Weather set to "..weather.."!"
		exports.log:Add({
			source = source,
			verb = "set",
			noun = "weather",
			extra = ("%s to %s"):format(lastWeather, weather),
			channel = "admin",
		})
	else
		if weather == CurrentWeather then
			message = "Already set to "..weather.."!"
		else
			message = "Weather "..weather.." does not exist!"
		end
	end
	SendMessage(source, message)
end, {
	description = "Change the weather!",
	parameters = {
		{ name = "Weather", description = "Weather types: EXTRASUNNY, CLEAR, NEUTRAL, SMOG, FOGGY, OVERCAST, CLOUDS, CLEARING, RAIN, THUNDER, SNOW, BLIZZARD, SNOWLIGHT, XMAS, HALLOWEEN" },
	}
}, "Admin")

exports.chat:RegisterCommand("a:time", function(source, args, rawCommand)
	local hour, minute, second = tonumber(args[1]) or 12, tonumber(args[2]) or 0, tonumber(args[3]) or 0
	SetTimeOfDay(hour, minute, second)
	exports.log:Add({
		source = source,
		verb = "set",
		noun = "time",
		extra = ("%s:%s:%s"):format(hour, minute, second),
		channel = "admin",
	})
end, {
	description = "Change the time instantly.",
	parameters = {
		{ name = "Hour", description = "Hour of day (1-24)" },
		{ name = "Minute", description = "Minute of day (0-60)" },
		{ name = "Second", description = "Second of day (0-60)" },
	}
}, "Admin")

RegisterCommand("nextweather", function(source)
	if source ~= 0 then return end

	NextWeatherStage()
	print(("[SYNC] next into %s"):format(CurrentWeather))
end, true)