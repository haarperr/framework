CurrentWeather = "EXTRASUNNY"

function GetHour()
	return math.floor((GetTime() / 60.0) % 24.0)
end

function GetMinute()
	return math.floor(GetTime() % 60.0)
end

function GetSecond()
	return math.floor((GetTime() * 60.0) % 60.0)
end

function GetTimes()
	serverTime = GetTime()

	local day, month, year, hour, minute, second =
		math.floor((serverTime / 1440) % 31),
		math.floor((serverTime / 44640) % 12),
		math.floor(serverTime / 535680),
		math.floor((serverTime / 60) % 24),
		math.floor(serverTime % 60),
		math.floor((serverTime * 60) % 60)

	return day, month, year, hour, minute, second
end