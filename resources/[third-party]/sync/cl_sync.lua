Main = Main or {}

--[[ Functions ]]--
function Main:Update()
	-- Update weather.
	if self.nextWeather and self.weather ~= self.nextWeather then
		self:SetWeather(self.nextWeather)
		self.nextWeather = nil
	end

	-- Update time.
	local day, month, year, hour, minute, second = self:GetTimes()

	if self.night then
		hour = 0
	end

	NetworkOverrideClockTime(hour, minute, 0)
	SetClockDate(day, month, year)
end

function Main:SetBlackout(value)
	SetArtificialLightsState(value)
	SetArtificialLightsStateAffectsVehicles(false)
end

function Main:SetWeather(weather)
	self.weather = weather
	SetWeatherTypeOvertimePersist(weather, 15.0)
end

function Main:GetTime()
	return self:GetServerTime() / 1000.0 * Config.TimeScale
end

function Main:GetServerTime()
	return GetGameTimer() - (self.syncTime or 0) + (self.serverTime or 0)
end

function Main:UpdateTime(time)
	self.syncTime = GetGameTimer()
	self.serverTime = time * 1000.0
end

function Main:UpdateWeather(weather)
	self.nextWeather = weather
end

function Main:UpdateBoth(time, weather)
	self:UpdateTime(time)
	self:UpdateWeather(weather)
end

--[[ Events ]]--
RegisterNetEvent("sync:update", function(name, ...)
	local func = Main["Update"..name]
	if func then
		func(Main, ...)
	end
end)

--[[ Exports ]]--
exports("SetNighttime", function(value)
	Main.night = value
end)

exports("SetBlackout", function(value)
	Main:SetBlackout(value)
end)

exports("GetTimes", function()
	return { Main:GetTimes() }
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(20)
	end
end)