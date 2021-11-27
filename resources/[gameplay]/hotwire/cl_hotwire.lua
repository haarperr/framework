Main = {}

--[[ Functions: Main ]]--
function Main:Update()
	local tier = self.tier
	if not tier then return end
	
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped)

	if vehicle ~= self.vehicle or GetPedInVehicleSeat(vehicle, -1) ~= ped then
		self:Cancel()
		return
	end

	local time = GetGameTimer()
	if not self.nextEvent then
		self.nextEvent = time + GetRandomIntInRange(table.unpack(tier.EventDelay))
	elseif self.nextEvent and time > self.nextEvent and self.endTime - time > 8000 then
		local success = exports.quickTime:Begin(tier.QuickTime)
		if not success then
			self:Cancel()
			return
		end

		self.nextEvent = nil
	end
end

function Main:Finish(success)
	if success then
		TriggerServerEvent("hotwire:finish", NetworkGetNetworkIdFromEntity(self.vehicle))
	end
	
	self.nextEvent = nil
	self.tier = nil
	self.vehicle = nil

	exports.quickTime:Cancel(success)
end

function Main:Cancel()
	self:Finish()
	TriggerEvent("inventory:cancel")
end

--[[ Events ]]--
AddEventHandler("inventory:use", function(item, slot, cb)
	local settings = Config.Items[item.name]
	if not settings then return end

	-- Get/check the vehicle.
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped)
	if not DoesEntityExist(vehicle or 0) or GetPedInVehicleSeat(vehicle, -1) ~= ped then return end

	-- Get tier level.
	local class = GetVehicleClass(vehicle)
	local tierLevel = Config.Classes[class]
	local tier = Config.Tiers[tierLevel or false]

	-- Class cannot be hotwired.
	if not tier or tierLevel > settings.MaxLevel then
		TriggerEvent("chat:notify", "Vehicle cannot be hotwired...", "error")
		return
	end

	-- Check already hotwired.
	local state = (Entity(vehicle) or {}).state
	if state and state.hotwired then
		TriggerEvent("chat:notify", "Vehicle has already been hotwired...", "error")
		return
	end

	-- Update cache.
	Main.tier = tier
	Main.vehicle = vehicle
	Main.duration = tier.Duration * settings.Scale * 1000.0

	Main.startTime = GetGameTimer()
	Main.endTime = Main.startTime + Main.duration

	-- Trigger callback.
	-- cb(1000, Config.Anim)
	cb(Main.duration, Config.Anim)
end)

AddEventHandler("inventory:useFinish", function(item, slot)
	if not Main.vehicle then return end
	
	Main:Finish(true)
end)

AddEventHandler("inventory:useCancel", function(item, slot)
	if not Main.vehicle then return end

	Main:Finish()
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Main.vehicle then
			Main:Update()
		end
		Citizen.Wait(200)
	end
end)